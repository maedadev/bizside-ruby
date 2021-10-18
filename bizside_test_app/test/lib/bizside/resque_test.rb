require 'test_helper'
require 'resque'
require 'bizside/resque'

class Bizside::ResqueTest < ActiveSupport::TestCase

  def test_ログ出力内容確認
    error_message = 'resque error test.'
    exception = Exception.new(error_message)
    exception.set_backtrace(["sushioke/app/jobs/user_changes_remind_job.rb:5:in `perform'",
                             "sushioke/app/jobs/user_changes_remind_job.rb:6:in `perform'",
                             "sushioke/app/jobs/user_changes_remind_job.rb:7:in `perform'",
                             "sushioke/app/jobs/user_changes_remind_job.rb:8:in `perform'",
                             "sushioke/app/jobs/user_changes_remind_job.rb:9:in `perform'",
                             "sushioke/app/jobs/user_changes_remind_job.rb:10:in `perform'",
                             "sushioke/app/jobs/user_changes_remind_job.rb:11:in `perform'",
                             "sushioke/app/jobs/user_changes_remind_job.rb:12:in `perform'"])
    resque_job_class_name = 'SampleJob'
    resque_job_args = { company_id: 1, user_id: 100 }
    payload = { 'class' => resque_job_class_name, 'args' => resque_job_args }
    queue = 'high'
    worker = Resque::Worker

    job_audit_log = Resque::Failure::JobAuditLog.new(exception, worker, queue, payload)
    error_log = job_audit_log.save
    assert_not_nil error_log[:time]
    assert_equal payload['class'].to_s, error_log[:class]
    assert_equal payload['args'].to_s, error_log[:args]
    assert_equal queue, error_log[:queue]
    assert_equal worker.to_s, error_log[:worker]
    assert_equal exception.class, error_log[:exception]
    assert_equal exception.to_s, error_log[:exception_message]
    assert_equal exception.backtrace[0..10].join("\n"), error_log[:exception_backtrace]
  end

end
