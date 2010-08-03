Given /^a (.+) emitter$/ do |name|
  name = name.gsub(/\s+/,'_').camelize + 'Record'
  @activity = name.constantize
  @characteristics ||= {}
end

Given /^(a )?characteristic "(.*)" of "(.*)"$/ do |_, name, value|
  if name =~ /\./
    model_name, attribute = name.split /\./
    model = begin
      model_name.singularize.camelize.constantize
    rescue NameError
      association = @activity.reflect_on_association model_name.to_sym
      association.klass
    end
    value = model.send "find_by_#{attribute}", value
    @characteristics[model_name.to_sym] = value
  elsif name == 'timeframe' and value.present?
    @characteristics[name.to_sym] = Timeframe.interval value
  else
    value = coerce_value(value)
    @characteristics[name.to_sym] = value
  end
end

When /^the "(.*)" committee is calculated$/ do |committee_name|
  @decision ||= @activity.decisions[:emission]
  @committee = @decision.committees.find { |c| c.name.to_s == committee_name }
  args = [@characteristics]
  if @characteristics[:timeframe]
    args << [@characteristics[:timeframe]]
  else
    args << []
  end
  @report = @committee.report *args
  @characteristics[committee_name.to_sym] = @report.andand.conclusion
end

Then /^the committee should have used quorum "(.*)"$/ do |quorum|
  raise "Missing report for committee #{@committee.name}" if @report.nil?
  @report.quorum.name.should == quorum
end

Then /^the conclusion of the committee should be "(.*)"$/ do |conclusion|
  compare_values(@report.andand.conclusion, conclusion)
end

Then /^the conclusion of the committee should be nil$/ do
  compare_values(@report.andand.conclusion, nil)
end

Then /^the conclusion of the committee should include a key of (.*) and value (.*)$/ do |key, value|
  if key.present?
    @report.conclusion.keys.map(&:to_s).should include(key)
  else
    @report.conclusion.keys.map(&:to_s).should be_empty
  end

  if value.present?
    @report.conclusion.each do |k, v|
      @report.conclusion[k.to_s] == v
    end
    compare_values(@report.conclusion[key.to_s], value)
  end
end

Then /^the conclusion of the committee should have "(.*)" of "(.*)"$/ do |attribute, value|
  report_value = coerce_value @report.conclusion.send(attribute)
  report_value.should == coerce_value(value)
end

Then /^the conclusion of the committee should have a record identified with "(.*)" of "(.*)" and having "(.*)" of "(.*)"$/ do |id_field, id, field, value|
  id_field = id_field.to_sym
  records = @report.conclusion
  record = records.send("find_by_#{id_field}", id)
  coerce_value(record.send(field)).should == coerce_value(value)
end

Then /^the conclusion of the committee should have a record with "([^"]*)" equal to "([^"]*)"$/ do |field, value|
  record = @report.conclusion
  compare_values(coerce_value(record.send(field)),value)
end

Then /^the conclusion of the committee should include a key of "(.*)" and subvalue "(.*)" of "(.*)" and subvalue "(.*)" of "(.*)"$/ do |key, subkey1, subvalue1, subkey2, subvalue2|
  if key.present?
    @report.conclusion.keys.map(&:to_s).should include(key)
    actual_subvalue1 = coerce_value(@report.conclusion[key.to_s][subkey1.to_sym].to_s)
    compare_values(actual_subvalue1, subvalue1)
    actual_subvalue2 = coerce_value(@report.conclusion[key.to_s][subkey2.to_sym].to_s)
    compare_values(actual_subvalue2, subvalue2)
  else
    @report.conclusion.keys.map(&:to_s).should be_empty
  end
end