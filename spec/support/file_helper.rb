require 'fileutils'

# Util methods for processing file.
module FileHelper
  # Create file with at given path with given content. Ensure parent directories
  # exist.
  #
  # path    - An String path of file.
  # content - An String or an Array of Strings content of file.
  def create_file(path, content = '')
    file_path = File.expand_path(path)
    dir_path = File.dirname(file_path)
    FileUtils.makedirs(dir_path) unless File.exist?(dir_path)
    write_file(path, content)
  end

  # Write file content at given path.
  #
  # path    - An String path of file.
  # content - An String or an Array of Strings content of file.
  def write_file(path, content)
    File.open(path, 'w') do |file|
      case content
      when ''
        # Create empty file.
      when String
        file.puts content
      when Array
        file.puts content.join("\n")
      end
    end
  end
end
