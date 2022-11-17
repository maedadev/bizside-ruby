require 'test_helper'

class Bizside::JobUtilsTest < ActiveSupport::TestCase

  def test_already_in_jobs?
    jobs = [
      {
        'class': Bizside::JobUtilsTest.to_s,
        'args': [{'add_on_name': 'test1', 'table_name': 'test_table1'}]
      },
      {
        'class': Bizside::JobUtilsTest.to_s,
        'args': [{'add_on_name': 'test2', 'table_name': 'test_table2'}]
      }
    ]
    
    assert Bizside::JobUtils.__send__(:already_in_jobs?, Bizside::JobUtilsTest, {add_on_name: 'test1', table_name: 'test_table1'}, jobs)
    assert Bizside::JobUtils.__send__(:already_in_jobs?, Bizside::JobUtilsTest, {add_on_name: 'test2', table_name: 'test_table2'}, jobs)
    
    assert_not Bizside::JobUtils.__send__(:already_in_jobs?, Bizside::JobUtilsTest, {add_on_name: 'test1', table_name: 'test_table2'}, jobs)
    assert_not Bizside::JobUtils.__send__(:already_in_jobs?, Bizside::JobUtilsTest, {add_on_name: 'test2', table_name: 'test_table1'}, jobs)
    assert_not Bizside::JobUtils.__send__(:already_in_jobs?, Bizside::JobUtilsTest, {add_on_name: 'test2'}, jobs)
  end

  def test_already_in_jobs_with_except
    jobs = [
      {
        'class': Bizside::JobUtilsTest.to_s,
        'args': [{'add_on_name': 'test', 'table_name': 'test_table', 'build_id': 12345}]
      }
    ]
    
    assert_not Bizside::JobUtils.__send__(:already_in_jobs?, Bizside::JobUtilsTest, {add_on_name: 'test', table_name: 'test_table', build_id: 56789}, jobs)
    assert Bizside::JobUtils.__send__(:already_in_jobs?, Bizside::JobUtilsTest, {add_on_name: 'test', table_name: 'test_table', build_id: 56789}, jobs, except: [:build_id])
    assert Bizside::JobUtils.__send__(:already_in_jobs?, Bizside::JobUtilsTest, {add_on_name: 'test', table_name: 'test_table', build_id: 56789}, jobs, except: :build_id)
  end

  def test_rest_count
    assert_equal 0, Bizside::JobUtils.__send__(:rest_count, 0, 10), 'キュー内の未チェックジョブ無し'
    assert_equal 0, Bizside::JobUtils.__send__(:rest_count, 1, 10), 'キュー内の未チェックジョブ無し'
    assert_equal 0, Bizside::JobUtils.__send__(:rest_count, 9, 10), 'キュー内の未チェックジョブ無し'
    assert_equal 0, Bizside::JobUtils.__send__(:rest_count, 10, 10), 'キュー内の未チェックジョブ無し'
    assert_equal 1, Bizside::JobUtils.__send__(:rest_count, 11, 10), 'キュー内の未チェックジョブ 1件'
    assert_equal 9, Bizside::JobUtils.__send__(:rest_count, 19, 10), 'キュー内の未チェックジョブ 9件'
    assert_equal 10, Bizside::JobUtils.__send__(:rest_count, 20, 10), 'キュー内の未チェックジョブ 10件'
    assert_equal 10, Bizside::JobUtils.__send__(:rest_count, 21, 10), 'キュー内の未チェックジョブのうち、チェック対象 10件'
  end

  def test_hooks_called_in_expected_order
    {add_job: [], set_job_at: [10], enqueue_at_with_queue: [:normal, 10]}.each do |test_method, extra_args|

      current_hook = 0

      mock = MiniTest::Mock.new
      mock.expect(:before_enqueue, true) do
        assert_equal(0, current_hook)
        current_hook += 1
      end
      mock.expect(:after_enqueue, nil) do
        assert_equal(1, current_hook)
        current_hook += 1
      end
      mock.expect(:before_perform, nil) do
        assert_equal(2, current_hook)
        current_hook += 1
      end
      # TODO: around_perform should also be tested but yield within mock does not work.
      # mock.expect(:around_perform, true) do
      #   assert_equal(3, current_hook)
      #   current_hook += 1
      #   yield
      # end
      mock.expect(:perform, nil) do
        assert_equal(3, current_hook)
        current_hook += 1
      end
      mock.expect(:after_perform, nil) do
        assert_equal(4, current_hook)
        current_hook += 1
      end

      Bizside::JobUtils.send(test_method, *(extra_args + [mock]))

      mock.verify
    end
  end

  def test_dequeue
    mock = MiniTest::Mock.new
    mock.expect(:before_dequeue, nil)
    mock.expect(:after_dequeue, nil)

    Bizside::JobUtils.dequeue(mock)

    mock.verify
  end

  def test_before_enqueue
    {add_job: [], set_job_at: [10], enqueue_at_with_queue: [:normal, 10]}.each do |test_method, extra_args|

      mock = MiniTest::Mock.new
      mock.expect(:before_enqueue, false)

      def mock.after_enqueue(*args); fail("before_enqueue did not stop enqueueing(args: #{args})"); end
      def mock.before_perform(*args); fail("before_enqueue did not stop enqueueing(args: #{args})"); end
      def mock.perform(*args); fail("before_enqueue did not stop enqueueing(args: #{args})"); end
      def mock.after_perform(*args); fail("before_enqueue did not stop enqueueing(args: #{args})"); end
      def mock.on_failure(*args); fail("before_enqueue did not stop enqueueing(args: #{args})"); end

      Bizside::JobUtils.send(test_method, *(extra_args + [mock]))

      mock.verify
    end

    # the job will be placed if before_enqueue returns nil instead of false
    {add_job: [], set_job_at: [10], enqueue_at_with_queue: [:normal, 10]}.each do |test_method, extra_args|

      mock = MiniTest::Mock.new
      mock.expect(:before_enqueue, nil)
      mock.expect(:after_enqueue, nil)
      mock.expect(:before_perform, nil)
      mock.expect(:perform, nil)
      mock.expect(:after_perform, nil)

      Bizside::JobUtils.send(test_method, *(extra_args + [mock]))

      mock.verify
    end
  end

  def test_before_perform
    {add_job: [], set_job_at: [10], enqueue_at_with_queue: [:normal, 10]}.each do |test_method, extra_args|

      mock = MiniTest::Mock.new
      mock.expect(:before_enqueue, true)
      mock.expect(:after_enqueue, nil)
      mock.expect(:before_perform, nil) do
        raise ::Resque::Job::DontPerform
      end

      def mock.perform(*args); fail("before_perform did not abort job (args: #{args})"); end
      def mock.after_perform(*args); fail("before_perform did not abort job (args: #{args})"); end
      def mock.on_failure(*args); fail("before_perform did not abort job (args: #{args})"); end

      Bizside::JobUtils.send(test_method, *(extra_args + [mock]))

      mock.verify
    end
  end

  def test_on_failure
    {add_job: [], set_job_at: [10], enqueue_at_with_queue: [:normal, 10]}.each do |test_method, extra_args|

      mock = MiniTest::Mock.new
      mock.expect(:before_enqueue, true)
      mock.expect(:after_enqueue, nil)
      mock.expect(:before_perform, nil) do
        raise 'errors passed to on_failure'
      end
      mock.expect(:on_failure, nil) do |e, _args|
        assert_equal 'errors passed to on_failure', e.message
      end
      def mock.perform(*args); fail("before_perform did not abort job (args: #{args})"); end
      def mock.after_perform(*args); fail("before_perform did not abort job (args: #{args})"); end

      e = assert_raise do
        Bizside::JobUtils.send(test_method, *(extra_args + [mock]))
      end

      assert_equal 'errors passed to on_failure', e.message,
                   'In test environment Bizside::JobUtils propagates errors raise by worker to the code that enqueued the job.'
      mock.verify
    end

    {add_job: [], set_job_at: [10], enqueue_at_with_queue: [:normal, 10]}.each do |test_method, extra_args|
      mock = MiniTest::Mock.new
      mock.expect(:before_enqueue, true)
      mock.expect(:after_enqueue, nil) do
        raise 'errors not passed to on_failure'
      end
      mock.expect(:perform, nil)
      def mock.on_failure(_e, args); fail("after_enqueue aborted job (args: #{args})"); end

      e = assert_raise do
        Bizside::JobUtils.send(test_method, *(extra_args + [mock]))
      end

      assert_equal 'errors not passed to on_failure', e.message
      mock.verify
    end
  end

  def test_keys_converted_to_string_in_resque_worker
    {add_job: [], set_job_at: [10], enqueue_at_with_queue: [:normal, 10]}.each do |test_method, extra_args|
      mock = MiniTest::Mock.new
      original_options = {foo: 1, bar: {baz: 2}, 3 => 4}
      mock.expect(:before_enqueue, true) do |options|
        assert_equal({foo: 1, bar: {baz: 2}, 3 => 4}, options)
      end
      mock.expect(:perform, nil) do |options|
        assert_equal({'foo' => 1, 'bar' => {'baz' => 2}, "3" => 4}, options)
      end

      Bizside::JobUtils.send(test_method, *(extra_args + [mock, original_options]))

      mock.verify
      assert_equal({foo: 1, bar: {baz: 2}, 3 => 4}, original_options, 'keys in passed args did not convert to string.')
    end
  end

  def test_changes_to_args_in_after_enqueue_not_propagated_to_resque_worker
    {add_job: [], set_job_at: [10], enqueue_at_with_queue: [:normal, 10]}.each do |test_method, extra_args|
      mock = MiniTest::Mock.new
      original_options = {foo: 1}
      mock.expect(:before_enqueue, true) do |options|
        options[:before_enqueue] = 2
      end
      mock.expect(:after_enqueue, nil) do |options|
        options[:after_enqueue] = 3
      end
      mock.expect(:perform, nil) do |options|
        assert_equal({'foo' => 1, 'before_enqueue' => 2}, options, 'changes in after_perform was not propagated to resque worker')
      end

      Bizside::JobUtils.send(test_method, *(extra_args + [mock, original_options]))

      mock.verify
      assert_equal({foo: 1, before_enqueue: 2, after_enqueue: 3}, original_options, 'changes in after_perform was propagated to code that enqueued the job')
    end
  end

  def test_job_is_performed_even_if_after_enqueue_raises_error
    {add_job: [], set_job_at: [10], enqueue_at_with_queue: [:normal, 10]}.each do |test_method, extra_args|
      mock = MiniTest::Mock.new
      mock.expect(:after_enqueue, nil) do
        raise 'error in after_enqueue'
      end
      mock.expect(:perform, nil)

      e = assert_raise do
        Bizside::JobUtils.send(test_method, *(extra_args + [mock]))
      end

      assert_equal 'error in after_enqueue', e.message
      mock.verify
    end
  end
end
