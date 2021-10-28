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

end
