require 'yaml'

module Fasterer
  class Config
    FILE_NAME         = '.fasterer.yml'
    SPEEDUPS_KEY      = 'speedups'
    EXCLUDE_PATHS_KEY = 'exclude_paths'

    def ignored_speedups
      @ignored_speedups ||=
        file[SPEEDUPS_KEY].select { |_, value| !value}.keys.map(&:to_sym)
    end

    def ignored_files
      @ignored_files ||=
        file[EXCLUDE_PATHS_KEY].flat_map { |path| Dir[path] }
    end

    def file
      @file ||= begin
        return nil_file unless File.exist?(FILE_NAME)
        # Yaml.load_file returns false if the content is blank
        loaded = YAML.load_file(FILE_NAME) || nil_file
        # if the loaded file misses any of the two keys.
        loaded.merge!(nil_file) { |_k, v1, v2| v1 || v2 }
      end
    end

    def nil_file
      { SPEEDUPS_KEY => {}, EXCLUDE_PATHS_KEY => [] }
    end
  end
end
