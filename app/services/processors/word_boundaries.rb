module Processors
  class WordBoundaries < Hydra::Derivatives::Processors::Processor
    # Run the word boundary extraction and save the result
    # Result is saved mid-process as a tmp file to work around VCR error
    # See notes on pr #35 in github, story HPT-1561 in JIRA
    def process
      temp_file_name = output_file('tmp')
      File.open(temp_file_name, 'w') { |file| file.write(extract) }
      output_file_service.call(File.open(temp_file_name, 'rb'), directives)
      File.unlink(temp_file_name)
    end
    
    private
      ##
      # Extract word boundaries from the hocr content
      #
      # @return [String] The extracted json
      def extract
        parse_word_boundaries(file_content).to_json
      end

      def output_file(file_suffix)
        Dir::Tmpname.create(['sufia', ".#{file_suffix}"], Hydra::Derivatives.temp_file_base) {}
      end

      def file_content
        @content ||= File.open(source_path).read
      end

      def parse_word_boundaries(hocr)
        doc = Nokogiri::HTML(hocr)
        boundaries = {}
        doc.css('span.ocrx_word').each do |span|
          text = span.text
          next if text.length < 3
          # Filter out non-word characters
          word_match = text.match(/\w+/)
          next if word_match.nil?
    
          title = span['title']
          info = parse_hocr_title(title)
    
          text.split(/\W/).each do |word_part|
            boundaries[word_part] ||= []
            boundaries[word_part] << info
          end
        end
        boundaries
      end

      def parse_hocr_title(title)
        parts = title.split(';').map(&:strip)
        info = {}
        parts.each do |part|
          sections = part.split(' ')
          sections.shift
          if /^bbox/ =~ part
            x0, y0, x1, y1 = sections
            info['x0'] = x0.to_i
            info['y0'] = y0.to_i
            info['x1'] = x1.to_i
            info['y1'] = y1.to_i
          elsif /^x_wconf/ =~ part
            c = sections.first
            info['c'] = c.to_i
          end
        end
        info
      end
  end
end
