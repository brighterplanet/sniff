require 'active_support'

require 'sniff/fixture'

module Sniff
  class Database
    class << self
      # Initialize a database used for testing emitter gems
      #
      # local_root: Root directory of the emitter gem to be tested (path to the repo)
      # options: 
      # * :earth is the list of domains Earth.init should load (default: none)
      # * :load_data determines whether fixture data is loaded (default: true)
      # * :fixtures_path is the path to your gem's fixtures (default: local_root/features/support/db/fixtures)
      def init(local_root, options = {})
        db_init options
        earth_init(options[:earth])

        environments = []
        environments << init_environment(local_root, options)

        unless local_root == Sniff.root
          fixtures_path = File.join(Sniff.root, 'lib', 'test_support', 'db', 'fixtures')
          environments << init_environment(Sniff.root, :fixtures_path => fixtures_path)
        end
      end

      def init_environment(root, options = {})
        db = new root, options
        db.init
        db
      end

      # Connect to the database and set up an ActiveRecord logger
      def db_init(options)
        options[:db_adapter] ||= 'sqlite3'
        options[:db_name] ||= ':memory:'
        ActiveRecord::Base.logger = Sniff.logger
        ActiveRecord::Base.establish_connection :adapter => options[:db_adapter],
          :database => options[:db_name]
      end

      # Initialize Earth, tell it to load schemas defined by each domain model's
      # data_miner definition
      def earth_init(domains)
        domains ||= :none
        domains = [domains] unless domains.is_a? Array
        args = domains
        args << {:apply_schemas => true}

        Earth.init *args
      end
    end

    attr_accessor :root, :test_support_path, :fixtures_path,
      :load_data, :logger

    def initialize(root, options)
      self.root = root
      self.test_support_path = File.join(root, 'features', 'support')
      self.load_data = options[:load_data]
      self.fixtures_path = options[:fixtures_path]
      self.logger = Sniff.logger
    end

    def log(str)
      logger.info str
    end

    def load_data?
      @load_data = true if @load_data.nil?
      @load_data
    end

    def fixtures_path
      @fixtures_path ||= File.join(test_support_path, 'db', 'fixtures')
    end

    def init
      load_supporting_libs
      create_emitter_table
      Fixture.load_fixtures fixtures_path
    end

    def emitter_class
      return @emitter_class unless @emitter_class.nil?
      record_class_path = Dir.glob(File.join(test_support_path, '*_record.rb')).first
      if record_class_path
        require record_class_path
        record_class = File.read(record_class_path)
        klass = record_class.scan(/class ([^\s]*Record)/).flatten.first
        @emitter_class = klass.constantize
      end
    end

    def create_emitter_table
      emitter_class.auto_upgrade! if emitter_class
    end

    def populate_fixtures
      Fixture.load_fixtures fixtures_path
    end

    def load_supporting_libs
      $:.unshift File.join(root, 'lib')
      Dir[File.join(root, 'lib', 'test_support', '*.rb')].each do |lib|
        log "Loading #{lib}"
        require lib
      end
    end
  end
end
