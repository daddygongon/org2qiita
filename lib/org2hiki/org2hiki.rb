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
        @outputs << check_options(m, line)
        next
      end

      if @in_example == true
        @outputs << line
        next
      end

            m = line.match(/^\[\[file:(.+)\]\]/)
      line = m ? convert_attach(m, line) : line

      line =
        case line_match(line)
        when 0; convert_head(line)
        when 1; convert_desc(line)
        when 2; convert_list(line)
        else line
        end


      @outputs << line
    end
    @outputs.join("\n")
  end

  private
  def check_options(m, line)
    case m[1]
    when 'begin_example'
      @in_example = true
      return '<<<'
    when 'begin_src ruby'
      @in_example = true
      return '<<< ruby'
    when 'end_src', 'end_example'
      @in_example = false
      return '>>>'
    else
      return '// ' + line
    end
  end

  HEAD = Regexp.new(/^(\*+) (.+)$/)
  DESC = Regexp.new(/^- (.+) :: (.+)$/)
  LIST = Regexp.new(/^(\s*)- (.+)$/)

  def line_match(line)
    [HEAD, DESC, LIST].each_with_index do |test, i|
      return i if line.match(test)
    end
  end

  def convert_head(line)
    m = line.match(HEAD)
    return m ? ("!" * m[1].size + " #{m[2]}") : line
  end

  def convert_desc(line)
    m = line.match(DESC)
    return m ? (": #{m[1]} : #{m[2]}") : line
  end

  def convert_list(line)
    m = line.match(LIST)
    n = (m[1].size+2) / 2
    return m ? ("*" * n + " #{m[2]}") : line
  end

  def convert_attach(m, line)
    line.gsub!(m[0],"\{\{attach_view(#{m[1]})\}\}")
  end
end
