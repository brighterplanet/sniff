# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sniff}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Derek Kastner"]
  s.date = %q{2010-07-13}
  s.description = %q{# sniff
Testing environment for Brighter Planet Climate Middleware emission calculation gems.

This gem provides:
 * Sample climate data, representative of data found on http://data.brighterplanet.com
 * References to gems needed by each emitter gem  

# Usage
Within an emitter gem's test setup, you can:
    require 'sniff'
    
    Sniff.init '/path/to/emitter_project'

# How to contribute
Typical contributions will include updates to test data.

1. Fork the project.
1. Make your feature addition or bug fix.
1. Commit, do not mess with rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
1. Send me a pull request. Bonus points for topic branches.

# Local Gems
Sniff depends on several gems, some of which are developed by Brighter Planet.  You can tell Sniff or any of the carbon gems to use your local repos in lieu of installed rubygems through the following steps:


Paste the following functions into your ~/.bash_profile
    function mod_devgem() {
      var="LOCAL_`echo $2 | tr 'a-z' 'A-Z'`"
      
      if [ "$1" == "disable" ]
      then
        echo "unset $var"
        unset $var
      else
        dir=${3:-"~/$2"}
        echo "export $var=$dir"
        export $var=$dir
      fi
    }
    
    function devgems () {
      # Usage: devgems [enable|disable] [gemname]
      cmd=${1:-"enable"}
      if [ -z $2 ]
      then
        mod_devgem $cmd characterizable
        mod_devgem $cmd cohort_scope
        mod_devgem $cmd falls_back_on
        mod_devgem $cmd leap
        mod_devgem $cmd loose_tight_dictionary
        mod_devgem $cmd sniff
        mod_devgem $cmd data_miner
      else
        mod_devgem $cmd $2
      fi
    }

To enable all local gems, run `devgems enable`
To turn off devgems, run `devgems disable`
To turn off a specific gem, run `devgems disable leap`
To turn on a specific gem, run `devgems enable leap`

Typical development process:
    cd ~
    git clone http://github.com/rossmeissl/leap.git
    cd leap
    <do some development on leap>
    cd ~/sniff
    devgems enable leap
    rake gemspec
    rm -f Gemfile.lock
    bundle install
    <run tests, e.g. `spec spec`>
}
  s.email = %q{derek.kastner@brighterplanet.com}
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.files = [
    "lib/sniff.rb",
     "lib/sniff/active_record_ext.rb",
     "lib/sniff/conversions_ext.rb",
     "lib/sniff/database.rb",
     "lib/sniff/emitter.rb",
     "lib/sniff/tasks.rb",
     "lib/sniff/timeframe.rb",
     "lib/test_support/data_models/census_division.rb",
     "lib/test_support/data_models/census_region.rb",
     "lib/test_support/data_models/climate_division.rb",
     "lib/test_support/data_models/country.rb",
     "lib/test_support/data_models/egrid_region.rb",
     "lib/test_support/data_models/egrid_subregion.rb",
     "lib/test_support/data_models/gender.rb",
     "lib/test_support/data_models/petroleum_administration_for_defense_district.rb",
     "lib/test_support/data_models/state.rb",
     "lib/test_support/data_models/urbanity.rb",
     "lib/test_support/data_models/zip_code.rb",
     "lib/test_support/db/fixtures/census_divisions.csv",
     "lib/test_support/db/fixtures/census_regions.csv",
     "lib/test_support/db/fixtures/climate_divisions.csv",
     "lib/test_support/db/fixtures/countries.csv",
     "lib/test_support/db/fixtures/egrid_regions.csv",
     "lib/test_support/db/fixtures/egrid_subregions.csv",
     "lib/test_support/db/fixtures/genders.csv",
     "lib/test_support/db/fixtures/petroleum_administration_for_defense_districts.csv",
     "lib/test_support/db/fixtures/states.csv",
     "lib/test_support/db/fixtures/urbanities.csv",
     "lib/test_support/db/fixtures/yearly_anonymous_emissions.csv",
     "lib/test_support/db/fixtures/yearly_typical_emissions.csv",
     "lib/test_support/db/fixtures/zip_codes.csv",
     "lib/test_support/db/schema.rb",
     "vendor/geokit-rails/CHANGELOG.rdoc",
     "vendor/geokit-rails/MIT-LICENSE",
     "vendor/geokit-rails/README.markdown",
     "vendor/geokit-rails/Rakefile",
     "vendor/geokit-rails/about.yml",
     "vendor/geokit-rails/assets/api_keys_template",
     "vendor/geokit-rails/init.rb",
     "vendor/geokit-rails/install.rb",
     "vendor/geokit-rails/lib/geokit-rails.rb",
     "vendor/geokit-rails/lib/geokit-rails/acts_as_mappable.rb",
     "vendor/geokit-rails/lib/geokit-rails/adapters/abstract.rb",
     "vendor/geokit-rails/lib/geokit-rails/adapters/mysql.rb",
     "vendor/geokit-rails/lib/geokit-rails/adapters/postgresql.rb",
     "vendor/geokit-rails/lib/geokit-rails/adapters/sqlserver.rb",
     "vendor/geokit-rails/lib/geokit-rails/defaults.rb",
     "vendor/geokit-rails/lib/geokit-rails/geocoder_control.rb",
     "vendor/geokit-rails/lib/geokit-rails/ip_geocode_lookup.rb",
     "vendor/geokit-rails/test/acts_as_mappable_test.rb",
     "vendor/geokit-rails/test/boot.rb",
     "vendor/geokit-rails/test/database.yml",
     "vendor/geokit-rails/test/fixtures/companies.yml",
     "vendor/geokit-rails/test/fixtures/custom_locations.yml",
     "vendor/geokit-rails/test/fixtures/locations.yml",
     "vendor/geokit-rails/test/fixtures/mock_addresses.yml",
     "vendor/geokit-rails/test/fixtures/mock_families.yml",
     "vendor/geokit-rails/test/fixtures/mock_houses.yml",
     "vendor/geokit-rails/test/fixtures/mock_organizations.yml",
     "vendor/geokit-rails/test/fixtures/mock_people.yml",
     "vendor/geokit-rails/test/fixtures/stores.yml",
     "vendor/geokit-rails/test/ip_geocode_lookup_test.rb",
     "vendor/geokit-rails/test/models/company.rb",
     "vendor/geokit-rails/test/models/custom_location.rb",
     "vendor/geokit-rails/test/models/location.rb",
     "vendor/geokit-rails/test/models/mock_address.rb",
     "vendor/geokit-rails/test/models/mock_family.rb",
     "vendor/geokit-rails/test/models/mock_house.rb",
     "vendor/geokit-rails/test/models/mock_organization.rb",
     "vendor/geokit-rails/test/models/mock_person.rb",
     "vendor/geokit-rails/test/models/store.rb",
     "vendor/geokit-rails/test/schema.rb",
     "vendor/geokit-rails/test/tasks.rake",
     "vendor/geokit-rails/test/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/brighterplanet/sniff}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Test support for Brighter Planet carbon gems}
  s.test_files = [
    "spec/lib/sniff/database_spec.rb",
     "spec/spec_helper.rb",
     "lib/test_support/data_models/census_division.rb",
     "lib/test_support/data_models/census_region.rb",
     "lib/test_support/data_models/climate_division.rb",
     "lib/test_support/data_models/country.rb",
     "lib/test_support/data_models/egrid_region.rb",
     "lib/test_support/data_models/egrid_subregion.rb",
     "lib/test_support/data_models/gender.rb",
     "lib/test_support/data_models/petroleum_administration_for_defense_district.rb",
     "lib/test_support/data_models/state.rb",
     "lib/test_support/data_models/urbanity.rb",
     "lib/test_support/data_models/zip_code.rb",
     "lib/test_support/db/schema.rb",
     "spec/spec.opts"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, ["= 3.0.0.beta4"])
      s.add_runtime_dependency(%q<sqlite3-ruby>, ["= 1.3.0"])
      s.add_runtime_dependency(%q<falls_back_on>, ["= 0.0.2"])
      s.add_runtime_dependency(%q<cohort_scope>, ["= 0.0.5"])
      s.add_runtime_dependency(%q<leap>, ["= 0.3.3"])
      s.add_runtime_dependency(%q<summary_judgement>, ["= 1.3.8"])
      s.add_runtime_dependency(%q<fast_timestamp>, ["= 0.0.4"])
      s.add_runtime_dependency(%q<common_name>, ["= 0.1.5"])
      s.add_runtime_dependency(%q<conversions>, ["= 1.4.5"])
      s.add_runtime_dependency(%q<geokit>, ["= 1.5.0"])
      s.add_runtime_dependency(%q<data_miner>, ["= 0.4.44"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, [">= 0"])
    else
      s.add_dependency(%q<activerecord>, ["= 3.0.0.beta4"])
      s.add_dependency(%q<sqlite3-ruby>, ["= 1.3.0"])
      s.add_dependency(%q<falls_back_on>, ["= 0.0.2"])
      s.add_dependency(%q<cohort_scope>, ["= 0.0.5"])
      s.add_dependency(%q<leap>, ["= 0.3.3"])
      s.add_dependency(%q<summary_judgement>, ["= 1.3.8"])
      s.add_dependency(%q<fast_timestamp>, ["= 0.0.4"])
      s.add_dependency(%q<common_name>, ["= 0.1.5"])
      s.add_dependency(%q<conversions>, ["= 1.4.5"])
      s.add_dependency(%q<geokit>, ["= 1.5.0"])
      s.add_dependency(%q<data_miner>, ["= 0.4.44"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<rdoc>, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>, ["= 3.0.0.beta4"])
    s.add_dependency(%q<sqlite3-ruby>, ["= 1.3.0"])
    s.add_dependency(%q<falls_back_on>, ["= 0.0.2"])
    s.add_dependency(%q<cohort_scope>, ["= 0.0.5"])
    s.add_dependency(%q<leap>, ["= 0.3.3"])
    s.add_dependency(%q<summary_judgement>, ["= 1.3.8"])
    s.add_dependency(%q<fast_timestamp>, ["= 0.0.4"])
    s.add_dependency(%q<common_name>, ["= 0.1.5"])
    s.add_dependency(%q<conversions>, ["= 1.4.5"])
    s.add_dependency(%q<geokit>, ["= 1.5.0"])
    s.add_dependency(%q<data_miner>, ["= 0.4.44"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<rdoc>, [">= 0"])
  end
end

