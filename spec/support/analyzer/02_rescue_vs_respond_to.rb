begin
  'abakus'.to_a
rescue NoMethodError

end

begin
  'abakus'.to_a
rescue NoMethodError => e

end

begin
  'abakus'.to_a
rescue NoMethodError, StandardError => e

end

begin
  'abakus'.to_a
rescue => e

end

begin
  'abakus'.to_a
rescue

end

begin
  'abakus'.to_a
rescue StandardError

end

