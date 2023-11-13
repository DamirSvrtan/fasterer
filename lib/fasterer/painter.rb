module Fasterer
  module Painter
    COLOR_CODES = {
      red: 31,
      green: 32,
    }

    def self.paint(string, color)
      color_code = COLOR_CODES[color.to_sym]
      if color_code.nil?
        raise ArgumentError, "Color #{color} is not supported. Allowed colors are #{COLOR_CODES.keys.join(', ')}"
      end
      paint_with_code(string, color_code)
    end

    def self.paint_with_code(string, color_code)
      "\e[#{color_code}m#{string}\e[0m"
    end
  end
end