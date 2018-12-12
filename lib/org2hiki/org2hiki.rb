# -*- coding: utf-8 -*-

class To_Hiki
  def convert(lines)
    @in_example = false
    @outputs = []

    lines.split(/\n/).each do |line|
      if m = line.match(/^\#\+(.+)/)
        if m[1]=="begin_example" 
          @in_example = true
          @outputs << "<<<"
          next
        elsif m[1]=="begin_src ruby"
          @in_example = true
          @outputs << "<<< ruby"
          next
        elsif m[1].include?(["end_src","end_example"])
          @in_example = false
          @outputs << ">>>"
          next
        else
          @outputs <<  "// "+line
          next
        end
      end

      if @in_example == true
        @outputs << line
        next
      end

      line.gsub!(/^\* /,'! ')
      line.gsub!(/^\*\* /,'!! ')
      line.gsub!(/^\*\*\* /,'!!! ')

      @outputs << line
    end
    @outputs.join("\n")
  end
  
end
