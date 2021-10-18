require 'test_helper'
require 'bizside/string_io'

class Bizside::StringIOTest < ActiveSupport::TestCase

  def test_string_io

    fullpath = File.expand_path('test/data/test.txt')

    file = Bizside::StringIO.new(File.read(fullpath))
    file.base_dir = fullpath.sub(/test\/data\/test.txt$/, '')
    file.fullpath = fullpath

    assert_equal fullpath, file.fullpath
    assert_equal 'test.txt', file.original_filename
    assert_equal fullpath.sub(/\/test.txt$/, ''), file.original_dirname
    assert_equal 'test/data', file.relative_dirname

    assert_equal Digest::MD5.hexdigest(File.read(fullpath)), file.md5
    assert_equal Digest::MD5.hexdigest(File.read(fullpath)), Digest::MD5.hexdigest(file.read)

    file.base_dir = ''
    assert_equal fullpath.sub(/\/test.txt$/, '').sub(/^\//,''), file.relative_dirname

    file.fullpath = nil
    assert_equal '', file.original_filename
    assert_equal '', file.original_dirname
    assert_equal '', file.relative_dirname

  end

end