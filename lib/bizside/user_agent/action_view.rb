# TODO: Rails 5 のサポートが終了したらこのファイルは不要になるので削除する

case Rails::VERSION::MAJOR
when 5
  unless Bizside.config.user_agent.use_variant?
    raise 'ERROR: config/bizside.yml で "use_varint: true" を指定してください。デバイスにより View ファイル を切り替えている場合は、ファイル名を Rails 標準の形式に変更してください'
  end
when 6
  if Bizside.config.user_agent.to_h.has_key?('use_variant')
    warn("DEPRECATION WARNING: use_variant is deprecated. Delete it from config/bizside.yml")
  end
else
  raise "Rails#{Rails::VERSION::MAJOR} はサポートしていません。"
end
