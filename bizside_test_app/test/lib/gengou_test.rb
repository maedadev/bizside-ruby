require 'test_helper'

class GengouTest < ActiveSupport::TestCase

  test "西暦から和暦_フォーマット_999" do
    assert_nil Gengou.to_wareki('201')
  end

  test "西暦から和暦_フォーマット_9999" do
    assert_not_nil Gengou.to_wareki('2019')
  end

  test "西暦から和暦_フォーマット_99999" do
    assert_nil Gengou.to_wareki('20191')
  end

  test "西暦から和暦_フォーマット_999999" do
    assert_not_nil Gengou.to_wareki('201901')
  end

  test "西暦から和暦_フォーマット_9999999" do
    assert_nil Gengou.to_wareki('2019011')
  end

  test "西暦から和暦_フォーマット_99999999" do
    assert_not_nil Gengou.to_wareki('20190101')
  end

  test "西暦から和暦_フォーマット_999999999" do
    assert_nil Gengou.to_wareki('201901011')
  end

  test "西暦から和暦_フォーマット_9999-" do
    assert_nil Gengou.to_wareki('2019-')
  end

  test "西暦から和暦_フォーマット_9999-9" do
    assert_not_nil Gengou.to_wareki('2019-1')
  end

  test "西暦から和暦_フォーマット_9999-99" do
    assert_not_nil Gengou.to_wareki('2019-01')
  end

  test "西暦から和暦_フォーマット_9999-999" do
    assert_nil Gengou.to_wareki('2019-011')
  end

  test "西暦から和暦_フォーマット_9999-9-" do
    assert_nil Gengou.to_wareki('2019-1-')
  end

  test "西暦から和暦_フォーマット_9999-99-" do
    assert_nil Gengou.to_wareki('2019-01-')
  end

  test "西暦から和暦_フォーマット_9999-999-" do
    assert_nil Gengou.to_wareki('2019-011-')
  end

  test "西暦から和暦_フォーマット_9999-9-9" do
    assert_not_nil Gengou.to_wareki('2019-1-1')
  end

  test "西暦から和暦_フォーマット_9999-9-99" do
    assert_not_nil Gengou.to_wareki('2019-1-01')
  end

  test "西暦から和暦_フォーマット_9999-9-999" do
    assert_nil Gengou.to_wareki('2019-1-011')
  end

  test "西暦から和暦_フォーマット_9999-99-9" do
    assert_not_nil Gengou.to_wareki('2019-01-1')
  end

  test "西暦から和暦_フォーマット_9999-99-99" do
    assert_not_nil Gengou.to_wareki('2019-01-01')
  end

  test "西暦から和暦_フォーマット_9999-99-990" do
    assert_nil Gengou.to_wareki('2019-01-011')
  end

  test "西暦から和暦_フォーマット_9999/" do
    assert_nil Gengou.to_wareki('2019/')
  end

  test "西暦から和暦_フォーマット_9999/9" do
    assert_not_nil Gengou.to_wareki('2019/1')
  end

  test "西暦から和暦_フォーマット_9999/99" do
    assert_not_nil Gengou.to_wareki('2019/01')
  end

  test "西暦から和暦_フォーマット_9999/9/" do
    assert_nil Gengou.to_wareki('2019/1/')
  end

  test "西暦から和暦_フォーマット_9999/99/" do
    assert_nil Gengou.to_wareki('2019/01/')
  end

  test "西暦から和暦_フォーマット_9999/99/9" do
    assert_not_nil Gengou.to_wareki('2019/01/1')
  end

  test "西暦から和暦_フォーマット_9999/99/99" do
    assert_not_nil Gengou.to_wareki('2019/01/01')
  end

  test "西暦から和暦_フォーマット_9999年" do
    assert_not_nil Gengou.to_wareki('2019年')
  end

  test "西暦から和暦_フォーマット_9999年9" do
    assert_nil Gengou.to_wareki('2019年1')
  end

  test "西暦から和暦_フォーマット_9999年99" do
    assert_nil Gengou.to_wareki('2019年01')
  end

  test "西暦から和暦_フォーマット_9999年9月" do
    assert_not_nil Gengou.to_wareki('2019年1月')
  end

  test "西暦から和暦_フォーマット_9999年99月" do
    assert_not_nil Gengou.to_wareki('2019年01月')
  end

  test "西暦から和暦_フォーマット_9999年99月9" do
    assert_nil Gengou.to_wareki('2019年01月1')
  end

  test "西暦から和暦_フォーマット_9999年99月99" do
    assert_nil Gengou.to_wareki('2019年01月01')
  end

  test "西暦から和暦_フォーマット_9999年99月9日" do
    assert_not_nil Gengou.to_wareki('2019年01月1日')
  end

  test "西暦から和暦_フォーマット_9999年99月99日" do
    assert_not_nil Gengou.to_wareki('2019年01月01日')
  end

  test "西暦から和暦_日付が存在しない" do
    assert_nil Gengou.to_wareki('2019-02-29')
  end

  test "西暦から和暦_年_元号が存在しない" do
    assert_nil Gengou.to_wareki('1867')
  end

  test "西暦から和暦_年_明治元年" do
    assert_equal "明治元", Gengou.to_wareki('1868')
  end

  test "西暦から和暦_年_明治44年" do
    assert_equal "明治44", Gengou.to_wareki('1911')
  end

  test "西暦から和暦_年_大正元年" do
    assert_equal "大正元", Gengou.to_wareki('1912')
  end

  test "西暦から和暦_年_大正14年" do
    assert_equal "大正14", Gengou.to_wareki('1925')
  end

  test "西暦から和暦_年_昭和元年" do
    assert_equal "昭和元", Gengou.to_wareki('1926')
  end

  test "西暦から和暦_年_昭和63年" do
    assert_equal "昭和63", Gengou.to_wareki('1988')
  end

  test "西暦から和暦_年_平成元年" do
    assert_equal "平成元", Gengou.to_wareki('1989')
  end

  test "西暦から和暦_年_平成30年" do
    assert_equal "平成30", Gengou.to_wareki('2018')
  end

  test "西暦から和暦_年_令和元年" do
    assert_equal "令和元", Gengou.to_wareki('2019')
  end

  test "西暦から和暦_年月_元号が存在しない" do
    assert_nil Gengou.to_wareki('1867-12')
  end

  test "西暦から和暦_年月_明治元年" do
    assert_equal "明治元", Gengou.to_wareki('1868-01')
  end

  test "西暦から和暦_年月_明治45年" do
    assert_equal "明治45", Gengou.to_wareki('1912-06')
  end

  test "西暦から和暦_年月_大正元年" do
    assert_equal "大正元", Gengou.to_wareki('1912-07')
  end

  test "西暦から和暦_年月_大正15年" do
    assert_equal "大正15", Gengou.to_wareki('1926-11')
  end

  test "西暦から和暦_年月_昭和元年" do
    assert_equal "昭和元", Gengou.to_wareki('1926-12')
  end

  test "西暦から和暦_年月_昭和63年" do
    assert_equal "昭和63", Gengou.to_wareki('1988-12')
  end

  test "西暦から和暦_年月_平成元年" do
    assert_equal "平成元", Gengou.to_wareki('1989-01')
  end

  test "西暦から和暦_年月_平成31年" do
    assert_equal "平成31", Gengou.to_wareki('2019-04')
  end

  test "西暦から和暦_年月_令和元年" do
    assert_equal "令和元", Gengou.to_wareki('2019-05')
  end

  test "西暦から和暦_年月日_元号が存在しない" do
    assert_nil Gengou.to_wareki('1868-01-24')
  end

  test "西暦から和暦_年月日_明治元年" do
    assert_equal "明治元", Gengou.to_wareki('1868-01-25')
  end

  test "西暦から和暦_年月日_明治45年" do
    assert_equal "明治45", Gengou.to_wareki('1912-07-29')
  end

  test "西暦から和暦_年月日_大正元年" do
    assert_equal "大正元", Gengou.to_wareki('1912-07-31')
  end

  test "西暦から和暦_年月日_大正15年" do
    assert_equal "大正15", Gengou.to_wareki('1926-12-24')
  end

  test "西暦から和暦_年月日_昭和元年" do
    assert_equal "昭和元", Gengou.to_wareki('1926-12-25')
  end

  test "西暦から和暦_年月日_昭和64年" do
    assert_equal "昭和64", Gengou.to_wareki('1989-01-07')
  end

  test "西暦から和暦_年月日_平成元年" do
    assert_equal "平成元", Gengou.to_wareki('1989-01-08')
  end

  test "西暦から和暦_年月日_平成31年" do
    assert_equal "平成31", Gengou.to_wareki('2019-04-30')
  end

  test "西暦から和暦_年月日_令和元年" do
    assert_equal "令和元", Gengou.to_wareki('2019-05-01')
  end

  def test_和暦から西暦
    assert_equal '1989', Gengou.to_seireki('平成', 1)
  end
end
