# encoding: utf-8

module OhMyLoog
  module Writers
    
    # TODO implement default colors (first 16)
    class XTerm256 < AbstractWriter
        
    protected

      # Flags may be :b for bold, :i for italic, :u for underline,
      #              :r for reverse  
      def colorize txt, fg = nil, bg = nil, flags
        fgc = (fg.nil? || Color === fg ) ? fg : Color.parse(fg)
        bgc = (bg.nil? || Color === bg) ? bg : Color.parse(bg)
        esc = []
        esc << '01' if flags[:b]
        esc << '03' if flags[:i]
        esc << '04' if flags[:u]
        esc << '07' if flags[:r]
        esc << "38;05;#{fgc.xterm256}" if fgc
        esc << "48;05;#{bgc.xterm256}" if bgc
        
        esc.empty? ? txt : "\e[#{esc.join(';')}m#{txt}\e[0m" 
      end
        
    end
  end
end 
