require 'test_helper'

class Bizside::FileConverterTest < ActiveSupport::TestCase

  def test_ClassMethod_convert_to_image_pdf
    png_binary_prefix = [0x89, 0x50, 0x4e, 0x47].pack('C*')
    image_file = nil

    mkworkdir do |workdir|
      prepare_data('man.pdf', to: workdir)
      File.open(File.join(workdir, 'man.pdf')) do |pdf|
        assert_nothing_raised do
          image_file = Bizside::FileConverter.convert_to_image(pdf)
        end

        assert image_file, '成功していること'
        assert_equal File.join(workdir, 'man.pdf.png'), image_file.path
        assert_equal png_binary_prefix, image_file.read(4), '生成した画像はPNGであること'
      end
    end

  ensure
    image_file.close if image_file
  end

  private

    def mkworkdir
      Dir.mktmpdir(nil, Rails.root.join('tmp').tap(&:mkpath).to_s) do |dir|
        yield dir
      end
    end

    def prepare_data(*filenames, to: )
      data_dir = Rails.root.join('test/data')
      filenames.each do |name|
        FileUtils.cp_r(data_dir.join(name).to_s, to)
      end
    end
end
