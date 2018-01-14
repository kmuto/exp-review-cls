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

    def inline_i(str)
      macro('reviewit', escape(str))
    end

    def inline_b(str)
      macro('reviewbf', escape(str))
    end

    def inline_code(str)
      macro('reviewtt', escape(str))
    end

    def inline_tt(str)
      macro('reviewtt', escape(str))
    end

    def inline_tti(str)
      macro('reviewtt', macro('reviewit', escape(str)))
    end

    def inline_ttb(str)
      macro('reviewtt', macro('reviewbf', escape(str)))
    end

    def common_code_block(id, lines, command, caption, _lang)
      @doc_status[:caption] = true
      puts '\begin{reviewlistblock}'
      if caption.present?
        if command =~ /emlist/ || command =~ /cmd/ || command =~ /source/
          puts macro(command + 'caption', '', compile_inline(caption))
        else
          begin
            if get_chap.nil?
              puts macro('reviewlistcaption', "#{I18n.t('list')}#{I18n.t('format_number_header_without_chapter', [@chapter.list(id).number])}", compile_inline(caption))
            else
              puts macro('reviewlistcaption', "#{I18n.t('list')}#{I18n.t('format_number_header', [get_chap, @chapter.list(id).number])}", compile_inline(caption))
            end
          rescue KeyError
            error "no such list: #{id}"
          end
        end
      end
      @doc_status[:caption] = nil
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

    def imgtable(lines, id, caption = nil, metric = nil)
      unless @chapter.image(id).bound?
        warn "image not bound: #{id}"
        image_dummy id, caption, lines
        return
      end

      begin
        if caption.present?
          @table_caption = true
          @doc_status[:caption] = true
          puts '\begin{table}[H]'
          puts macro('reviewimgtablecaption', compile_inline(caption))
          @doc_status[:caption] = nil
        end
        puts macro('label', table_label(id))
      rescue ReVIEW::KeyError
        error "no such table: #{id}"
      end
      imgtable_image(id, caption, metric)

      puts '\end{table}' if @table_caption
      @table_caption = nil
      blank
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

    def table(lines, id = nil, caption = nil)
      rows = []
      sepidx = nil
      lines.each_with_index do |line, idx|
        if /\A[\=\{\-\}]{12}/ =~ line
          # just ignore
          # error "too many table separator" if sepidx
          sepidx ||= idx
          next
        end
        rows.push(line.strip.split(/\t+/).map { |s| s.sub(/\A\./, '') })
      end
      rows = adjust_n_cols(rows)

      puts '\begin{table}[H]'
      begin
        table_header id, caption if caption.present?
      rescue KeyError
        error "no such table: #{id}"
      end
      return if rows.empty?
      table_begin rows.first.size
      if sepidx
        sepidx.times do
          tr(rows.shift.map { |s| th(s) })
        end
        rows.each do |cols|
          tr(cols.map { |s| td(s) })
        end
      else
        rows.each do |cols|
          h, *cs = *cols
          tr([th(h)] + cs.map { |s| td(s) })
        end
      end
      table_end
    end

    def table_header(id, caption)
      if id.nil?
        if caption.present?
          @table_caption = true
          @doc_status[:caption] = true
          puts macro('reviewtablecaption*', compile_inline(caption))
          @doc_status[:caption] = nil
        end
      else
        if caption.present?
          @table_caption = true
          @doc_status[:caption] = true
          puts macro('reviewtablecaption', compile_inline(caption))
          @doc_status[:caption] = nil
        end
        puts macro('label', table_label(id))
      end
    end

    def table_end
      puts macro('end', 'reviewtable')
      puts '\end{table}'
      @table_caption = nil
      blank
    end
  end

  class LATEXBuilder
    prepend LATEXBuilderOverride
  end
end
