module Hihi
  class << self
    module_eval %{
      def hello
        puts "win"
      end
    }
  end
end

Hihi.hello

Hihi.module_eval %{
 puts @foo
}
