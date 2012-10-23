require 'rubygems'
 

class Smarty2To3Converter

    @processor
    @file

    def initialize(filename)
        if File.readable? filename then @file = filename end
        @processor = Processor.new
    end

    def run
        File.open(@file, 'r').readlines.each do |line|
            @processor.run line
        end
    end

end


class Processor

    @isLitteral

    def initialize()
        @isLitteral = false
    end
 
    def run line

        if @isLitteral || line.empty?
           puts line 
           return
        end

        # replace first all spacess so that we can search for that pattern
        line = line.gsub(/\{\s+\literal\s+\}/,"{literal}")
        line = line.gsub(/\{\s+\/literal\s+\}/,"{/literal}")

        # start logic
        puts hasLitteralStart(line)

    end

    def hasLitteralStart line

        if (!line.empty? && line.index("{literal}"))
        
            @isLitteral = true
            splitline = line.split("{literal}" , 2)
            

            splitline[0] = searchAndReplace splitline[0]
            splitline[1] = hasLitteralEnd splitline[1] 
            
            return splitline * "{literal}"
        end

        return hasLitteralEnd line

    end

    def hasLitteralEnd line
        if (!line.empty? && line.index("{/literal}"))
           
            @isLitteral = false
            
            splitline = line.split("{/literal}" , 2)

            splitline[1] = hasLitteralStart splitline[1]
            
            return splitline * "{/literal}"
        end

        return searchAndReplace line

    end

    def searchAndReplace line
        line = line.gsub(/\{\s+/,"{")
        line = line.gsub(/\s+\}/, "}")
        line = line.gsub(/(\$\S+)\|isset/, 'isset(\1)')
        line = line.gsub(/value=(\S+\.tpl)\}/, 'value="\1"}')

        return line
    end

  
end

Smarty2To3Converter.new(ARGV[0]).run
