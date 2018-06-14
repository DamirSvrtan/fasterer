def not_ignored_rescue_vs_respond
  begin
    'abakus'.to_a
  rescue NoMethodError

  end
end

# :rescue_vs_respond_to
def ignored_rescue_vs_respondd
  begin
    'abakus'.to_a
  rescue NoMethodError

  end
end
