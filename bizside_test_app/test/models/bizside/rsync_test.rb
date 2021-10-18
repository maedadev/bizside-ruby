require 'test_helper'
require 'bizside/rsync'

class Bizside::RsyncTest < ActiveSupport::TestCase

  def test_get_backup_dirs
    base_dir = 'tmp/test/rsync_test'
    today = Date.today

    FileUtils.rm_rf(base_dir)
    3.times do |i|
      dir = (today + i.days).strftime('%Y%m%d%H%M%S')
      FileUtils.mkdir_p(File.join(base_dir, dir))
      FileUtils.mkdir_p(File.join(base_dir, dir + '.failed'))
      FileUtils.mkdir_p(File.join(base_dir, dir + '.running'))
    end

    dirs = Bizside::Rsync.get_backup_dirs(base_dir)
    assert_equal 3, dirs.size
    3.times do |i|
      expected = (today + i.days).strftime('%Y%m%d%H%M%S')
      assert_equal expected, File.basename(dirs[i])
    end
  end

end
