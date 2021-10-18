case Rails::VERSION::MAJOR
when 5
  if Bizside.config.user_agent.use_variant?
    load File.expand_path(File.join('action_view', 'use_variant.rb'), __dir__)
  else
    load File.expand_path(File.join('action_view', 'action_view_4.rb'), __dir__)
  end
else
  raise "Rails#{Rails::VERSION::MAJOR} はサポートしていません。"
end
