unless defined?(Rails) or Rake::Task.task_defined?('tmp:cache:clear')
  desc 'tmp/cache 配下のキャッシュファイルを削除します。'
  task 'tmp:cache:clear' do
    FileUtils.rm_rf('tmp/cache/', secure: true)
  end
end
