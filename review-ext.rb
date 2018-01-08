require 'review'

module ReVIEW
  module HTMLBuilderOverride
    def inline_balloon(str)
      %Q(<span class="balloon">#{escape_html(str)}</span>)
    end
  end

  class HTMLBuilder
    prepend HTMLBuilderOverride
  end

  module LATEXBuilderOverride
    def inline_balloon(str)
      %Q(←#{escape(str)})
    end

    def common_code_block(id, lines, command, caption, _lang)
      puts '\begin{reviewlistblock}'
      if caption.present?
        cmd = "#{command.sub(/num\Z/, '')}caption"
        if %w(reviewlist).include?(command)
          begin
            if get_chap.nil?
              puts macro(cmd, "#{I18n.t('list')}#{I18n.t('format_number_header_without_chapter', [@chapter.list(id).number])}#{I18n.t('caption_prefix')}#{compile_inline(caption)}")
            else
              puts macro(cmd, "#{I18n.t('list')}#{I18n.t('format_number_header', [get_chap, @chapter.list(id).number])}#{I18n.t('caption_prefix')}#{compile_inline(caption)}")
            end
          rescue KeyError
            error "no such list: #{id}"
          end
        else
          puts macro(cmd, compile_inline(caption))
        end
      end
      body = ''
      lines.each_with_index do |line, idx|
        body.concat(yield(line, idx))
      end
      puts macro('begin', command)
      print body
      puts macro('end', command)
      puts '\end{reviewlistblock}'
      blank
    end

    def common_code_block_lst(_id, lines, command, title, caption, lang, first_line_num: 1)
      puts '\begin{reviewlistblock}'
      body = lines.inject('') { |i, j| i + detab(unescape_latex(j)) + "\n" }
      args = make_code_block_args(title, caption, lang, first_line_num: first_line_num)
      puts %Q(\\begin{#{command}}[#{args}])
      print body
      puts %Q(\\end{#{command}})
      puts '\end{reviewlistblock}'
      blank
    end

    def make_code_block_args(title, caption, lang, first_line_num: 1)
      caption_str = compile_inline((caption || ''))
      if title == 'title' && caption_str == ''
        caption_str = '\relax' ## dummy charactor to remove lstname
      end
      lexer = if @book.config['highlight'] && @book.config['highlight']['lang']
                @book.config['highlight']['lang'] # default setting
              else
                ''
              end
      lexer = lang if lang.present?
      args = %Q(#{title}={#{caption_str}},language={#{lexer}})
      if first_line_num != 1
        args += ",firstnumber=#{first_line_num}"
      end
      args
    end

    def imgtable_image(id, _caption, metric)
      metrics = parse_metric('latex', metric)
      if metrics.present?
        puts "\\includegraphics[#{metrics}]{#{@chapter.image(id).path}}"
      else
        puts "\\includegraphics[width=\\maxwidth]{#{@chapter.image(id).path}}"
      end
    end

    def captionblock(type, lines, caption)
      if caption.present?
        puts "\\begin{review#{type}}[#{compile_inline(caption)}]\n"
      else
        puts "\\begin{review#{type}}\n"
      end
      blocked_lines = split_paragraph(lines)
      puts blocked_lines.join("\n\n")
      puts "\\end{review#{type}}\n"
    end

    def inline_uchar(str)
      [str.to_i(16)].pack('U')
    end

    def column_begin(level, label, caption)
      blank
      if label
        puts "\\hypertarget{#{column_label(label)}}{}"
      else
        puts "\\hypertarget{#{column_label(caption)}}{}"
      end
      if level <= @book.config['toclevel'].to_i
        puts "\\addcontentsline{toc}{#{HEADLINE[level]}}{#{compile_inline(caption)}}"
      end
      puts "\\begin{reviewcolumn}[#{compile_inline(caption)}]\n"
    end
  end

  class LATEXBuilder
    prepend LATEXBuilderOverride
  end
end
