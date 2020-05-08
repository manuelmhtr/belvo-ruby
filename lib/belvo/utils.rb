# frozen_string_literal: true

require 'base64'

# Class with helper functions
class Utils
  def self.read_file_to_b64(path)
    return if path.nil? || !File.file?(path)

    data = File.open(path).read
    Base64.encode64(data)
  end
end
