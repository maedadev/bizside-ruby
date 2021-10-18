module Bizside
  class StringIO < StringIO
    attr_accessor :base_dir
    attr_accessor :fullpath
    attr_accessor :content_type
    attr_accessor :file_size
    attr_accessor :md5

    def initialize(string = '', mode = 'r+')
      super(string, mode)
      begin
        self.md5 = Digest::MD5.hexdigest(self.read)
      rescue
        #失敗しても何もしない。
      ensure
        self.rewind
      end
    end

    def original_filename
      fullpath ? File.basename(fullpath) : ''
    end

    def original_dirname
      fullpath ? File.dirname(fullpath) : ''
    end

    def relative_dirname
      if fullpath
        relpath = fullpath.sub(/^#{Regexp.quote(base_dir)}/,'').sub(/^\//,'')
        File.dirname(relpath) == '.' ? '' : File.dirname(relpath)
      else
        ''
      end
    end

  end

end