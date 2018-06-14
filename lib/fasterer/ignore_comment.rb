module Fasterer
  class IgnoreComment
    attr_accessor :comment

    DEFAULT_COMMENT = 'fasterer'.freeze

    def initialize(comment = DEFAULT_COMMENT)
      @comment = comment
    end

    def ignored?(offense)
      return false if comment == DEFAULT_COMMENT
      comment.scan(offense.to_s).include?(offense.to_s)
    end

    def new_comment(new_comment)
      @comment = new_comment
    end

    def reset_comment
      @comment = DEFAULT_COMMENT
    end
  end
end
