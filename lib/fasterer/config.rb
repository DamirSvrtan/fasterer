require 'yaml'

module Fasterer
  class Config
    FILE_NAME         = '.fasterer.yml'
    SPEEDUPS_KEY      = 'speedups'
    EXCLUDE_PATHS_KEY = 'exclude_paths'

    def ignored_speedups
      @ignored_speedups ||=
        file[SPEEDUPS_KEY].select { |_, value| value == false }.keys.map(&:to_sym)
    end

    def ignored_files
      @ignored_files ||=
        file[EXCLUDE_PATHS_KEY].flat_map { |path| Dir[path] }
    end

    private

    def file
      @file ||= if File.exists?(FILE_NAME)
        YAML.load_file(FILE_NAME)
      else
        nil_config_file
      end
    end

    def nil_file
      { SPEEDUPS_KEY => {}, EXCLUDE_PATHS_KEY => [] }
    end
  end
end
