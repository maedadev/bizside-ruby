module Bizside
  module FileConverter
    EXT_IMAGE = ['.gif', '.jpg', '.jpeg', '.png']
    EXT_OFFICE = ['.doc', '.docx', '.ppt', '.pptx', '.xls', '.xlsx']
    EXT_PDF = ['.pdf']

    def self.convert_to_pdf(file)
      dest = file.path + '.pdf'

      case File.extname(file.path)
      when *EXT_OFFICE
        unless system("java -Xmx512m -jar /opt/jodconverter/lib/jodconverter-core.jar #{file.path} #{dest}")
          raise "オフィス文書からPDFに変換できませんでした。file=#{file.path}"
        end
      when *EXT_PDF
        unless system("cp #{file.path} #{dest}")
          raise "PDFをコピーできませんでした。file=#{file.path}"
        end
      else
        raise "サポートしていない拡張子です。file=#{file.path}"
      end

      File.new(dest)
    end

    def self.convert_to_image(file)
      require 'rmagick'

      case File.extname(file.path)
      when *EXT_IMAGE
        dest = file.path + File.extname(file.path)
        unless system("cp #{file.path} #{dest}")
          raise "画像をコピーできませんでした。file=#{file.path}"
        end
        ret = File.new(dest)
      when *EXT_OFFICE
        pdf = convert_to_pdf(file)
        ret = convert_to_image(pdf)
      when *EXT_PDF
        dest = file.path + '.png'
        images = Magick::ImageList.new(file.path) do
          self.quality = 100
          self.density = 96
        end
        images.first.write(dest)
        ret = File.new(dest)
      else
        raise "サポートしていない拡張子です。file=#{file.path}"
      end

      ret
    end

  end
end
