# frozen_string_literal: true

# convert org formated lines to hiki
class ToHiki
  # converter
  def convert(lines)
    @in_example = false
    @outputs = []

    lines.split(/\n/).each do |line|
      m = line.match(/^\#\+(.+)$/)
      if m
        if m[1] == 'begin_example'
          @in_example = true
          @outputs << '<<<'
        elsif m[1] == 'begin_src ruby'
          @in_example = true
          @outputs << '<<< ruby'
        elsif (m[1] == 'end_src') || (m[1] == 'end_example')
          @in_example = false
          @outputs << '>>>'
        else
          @outputs << '// ' + line
        end
        next
      end

      if @in_example == true
        @outputs << line
        next
      end

      line.gsub!(/^\* /, '! ')
      line.gsub!(/^\*\* /, '!! ')
      line.gsub!(/^\*\*\* /, '!!! ')

      @outputs << line
    end
    @outputs.join("\n")
  end
end
