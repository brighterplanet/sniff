require 'timecop'

Given /it is the year "(.*)"/ do |year|
  @current_date = Time.local(year.to_i, 6, 1, 0, 0, 0)
end

Given /^the current date is "(.+)"$/ do |current_date|
  @current_date = Time.parse(current_date)
end
