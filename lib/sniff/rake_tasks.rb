require 'rake'
require 'rake/clean'
require 'rdoc/task'
require 'rake/tasklib'

module Sniff
  class RakeTasks
    include Rake::DSL

    def self.define_tasks(&blk)
      new(&blk).define_tasks
    end

    attr_accessor :earth_domains, :cucumber, :rspec, :coverage, :rocco, :bueller

    def initialize
      self.earth_domains = :all
      self.cucumber = true
      self.rspec = false
      self.coverage = true
      self.rocco = true
      self.bueller = true
      yield self if block_given?
    end

    def ruby18?
      RUBY_VERSION =~ /^1\.8/ ? true : false
    end

    def rcov=(val)
      self.coverage = val
    end

    def gemname
      @gemname ||= File.basename(Dir.glob(File.join(Dir.pwd, '*.gemspec')).first, '.gemspec')
    end

    def git(cmd, dir = nil, &blk)
      full_cmd = ''
      full_cmd << "cd #{dir} && " if dir
      full_cmd << "unset GIT_DIR && unset GIT_INDEX_FILE && unset GIT_WORK_TREE && git #{cmd}"
      sh full_cmd, &blk
    end

    def define_tasks
      if coverage && ruby18?
        require 'rcov'
      elsif coverage
        task :simplecov do
          require 'simplecov' 

          SimpleCov.start do
            add_filter '/spec/'
            add_filter '/features/'
            add_filter '/vendor/'
          end
        end
      end

      task :console do
        require 'sniff'
        cwd = Dir.pwd
        Sniff.init cwd, :earth => earth_domains

        require 'irb'
        ARGV.clear
        IRB.start
      end

      if rocco
        require 'rocco'
        require 'rocco/tasks'

        Rocco::make 'docs/', "lib/#{gemname}/carbon_model.rb"

        desc 'Set up and build rocco docs'
        task :docs_init => :rocco

        task :google_analyzed_rocco => :rocco do
          source = File.read "docs/lib/#{gemname}/carbon_model.html"
          unless source =~ /_gaq/
            source.sub! '</head>', <<-HTML
  <script type="text/javascript">
    var _gaq = _gaq || [];
    _gaq.push(['_setAccount', 'UA-1667526-20']);
    _gaq.push(['_trackPageview']);

    (function() {
      var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
      ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
      var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
    })();
  </script>
</head>
          HTML
            File.open "docs/lib/#{gemname}/carbon_model.html", 'w' do |f|
              f.puts source
            end
          end
        end

        desc 'Rebuild rocco docs'
        task :docs => ['pages:sync', :google_analyzed_rocco]
        directory 'docs/'

        desc 'Update rocco docs on gh-pages branch'
        task :pages => :docs do
          rev = `git rev-parse --short HEAD`.strip
          sh "mv docs/lib/#{gemname}/carbon_model.html docs/carbon_model.html"
          git 'add *.html', 'docs'
          puts "Commiting with message 'Rebuild pages from #{rev}'"
          git "commit -m 'Rebuild pages from #{rev}'", 'docs' do |ok,res|
            if ok
              puts "Pushing to HEAD"
              git 'push -q o HEAD:gh-pages', 'docs' unless ENV['NO_PUSH']
            end
          end
        end

        # Update the pages/ directory clone
        namespace :pages do
          task 'sync' => ['.git/refs/heads/gh-pages', 'docs/.git/refs/remotes/o'] do |f|
            git 'fetch -q o', 'docs'
            git 'reset -q --hard o/gh-pages', 'docs'
            sh 'touch docs'
          end

          file '.git/refs/heads/gh-pages' => 'docs/' do |f|
            unless File.exist? f.name
              git 'branch gh-pages', 'docs' 
            end
          end

          file 'docs/.git/refs/remotes/o' => 'docs/' do |f|
            unless File.exist? f.name
              git 'init -q docs'
              git 'remote add o ../.git', 'docs'
            end
          end
        end

        CLOBBER.include 'docs/.git'
      end

      if cucumber
        require 'cucumber'
        require 'cucumber/rake/task'

        desc 'Run all cucumber tests'
        Cucumber::Rake::Task.new(:features) do |t|
          if ENV['CUCUMBER_FORMAT']
            t.cucumber_opts = "features --format #{ENV['CUCUMBER_FORMAT']}"
          else
            t.cucumber_opts = 'features --format pretty'
          end
        end

        if coverage && ruby18?
          desc "Run cucumber tests with RCov"
          Cucumber::Rake::Task.new(:features_with_coverage) do |t|
            t.cucumber_opts = "features --format pretty"
            t.rcov = true
            t.rcov_opts = ['--exclude', 'features']
          end
        elsif coverage
          task :features_with_coverage => [:simplecov, :features]
        end
      end

      if rspec
        require 'rspec/core/rake_task'

        desc "Run all examples"
        RSpec::Core::RakeTask.new('examples') do |c|
          if ENV['RSPEC_FORMAT']
            c.rspec_opts = "-Ispec --format #{ENV['RSPEC_FORMAT']}"
          else
            c.rspec_opts = '-Ispec --format documentation'
          end
        end

        if coverage && ruby18?
          desc "Run specs with RCov"
          RSpec::Core::RakeTask.new(:examples_with_coverage) do |t|
            t.rcov = true
            t.rcov_opts = ['--exclude', 'spec']
            t.rspec_opts = '-Ispec'
          end
        elsif coverage
          task :examples_with_coverage => [:simplecov, :examples]
        end
      end

      directory 'log/'

      test_tasks = ['log/']
      test_tasks << :examples if rspec
      test_tasks << :features if cucumber
      unless test_tasks.empty?
        task :test => test_tasks
        task :default => :test
      end

      RDoc::Task.new do |rdoc|
        version = File.exist?('VERSION') ? File.read('VERSION') : ""

        rdoc.rdoc_dir = 'rdoc'
        rdoc.title = "#{gemname} #{version}"
        rdoc.rdoc_files.include('README*')
        rdoc.rdoc_files.include('lib/**/*.rb')
      end

      if bueller
        require 'bueller'
        Bueller::Tasks.new
      end
    end
  end
end
