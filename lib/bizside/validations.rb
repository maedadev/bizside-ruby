validations_dir = File.dirname(File.dirname(File.dirname(__FILE__)))

Dir[File.join(validations_dir, 'validations/*.rb')].each do |f|
  begin
    load f
  rescue LoadError
  end
end
