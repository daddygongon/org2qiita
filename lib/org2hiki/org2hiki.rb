# -*- coding: utf-8 -*-

class To_Hiki
  def convert(lines)
    @in_example = false
    @outputs = []

    lines.split(/\n/).each do |line|
      if m = line.match(/^\#\+(.+)/)
        if m[1]=="begin_example" 
          @in_example = true
          @outputs << "<<<\n"
          next
        elsif m[1]=="begin_src ruby"
          @in_example = true
          @outputs << "<<< ruby\n"
          next
        elsif m[1]=="end_src" or m[1]=="end_example"
          @in_example = false
          @outputs << ">>>\n"
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
  end
end
