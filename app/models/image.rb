require 'RMagick'
require 'color_namer'

class ImageProcess

  def initialize
    
  end

  def self.get_colors
    # Dir.chdir('/Users/josh/Projects/Albumgrid/public/images/')
    Dir.chdir('./public/images/')
    images = Dir.glob "*.jpg"
    files = {}

    Dir.glob("*") do |filename|
      # total = 0
      # avg = { :r => 0.0, :g => 0.0, :b => 0.0 }

      img = Magick::Image.read(filename).first
      img.resize_to_fit!(200)
      quantized = img.quantize(16)
      img.destroy! 

      colors_hash = {}
      quantized.color_histogram.each_pair do |pixel, frequency| # grab list of colors and frequency
        shade = ColorNamer.name_from_html_hash(pixel.to_color(Magick::AllCompliance, false, 8, true)).last # get shade of the color

        # group the colors by shade
        
        if colors_hash[shade].nil?
          colors_hash[shade] = frequency.to_i
        else
          colors_hash[shade] += frequency.to_i
        end
      end

      quantized.destroy! # prevent memory leaks

      # normalize color frequency to percentage

      sum = colors_hash.inject(0){ |s,c| s + c.last.to_i }.to_f
      colors_hash.map{ |c|  c[1] = (c.last.to_f / sum * 100).round; c }.inject({}){ |h,c| h[c[0]] = c[1]; files[filename] = h; h } 

      # puts self.largest colors_hash
    end
    files
  end

  def self.vig(img)
    img = Magick::Image.read(img).first
    newimg = img.vignette
  end

  def self.largest(hash)
    hash.max_by{|k,v| v}
  end

end