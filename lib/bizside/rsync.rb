module Bizside
  module Rsync

    def self.cleanup_old_dirs(backup_dirs, generations)
      if backup_dirs.size > generations
        puts '--------------------'
        while backup_dirs.size > generations
          old_backup_dir = backup_dirs.shift
          puts "古いバックアップを削除します。#{old_backup_dir}"
          FileUtils.rm_r(old_backup_dir, :force => true)
        end
        puts '--------------------'
      end
    end

    def self.next_generation(backup_dir)
      running_dir = backup_dir + '.running'
      failure_dir = backup_dir + '.failed'

      begin
        FileUtils.ln_s(backup_dir, running_dir)
        yield
      rescue => e
        FileUtils.ln_s(backup_dir, failure_dir)
        raise e
      ensure
        FileUtils.rm_f(running_dir)
      end
    end

    # YYYYMMDDHHMMSS形式
    # .failed や .running は除外する
    def self.get_backup_dirs(backup_base_dir)
      ret = Dir::glob(File.join(backup_base_dir, '2*')).reject{|dir| File.basename(dir).index('.') }
      ret = ret.sort
      ret
    end

  end
end
