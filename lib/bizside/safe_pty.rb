require 'pty'

module Bizside::SafePty

  def self.spawn command, &block
    PTY.spawn(command) do |r, w, p|
      begin
        yield r, w, p
      rescue Errno::EIO
      ensure
        Process.wait p
      end
    end

    $?.exitstatus
  end
end