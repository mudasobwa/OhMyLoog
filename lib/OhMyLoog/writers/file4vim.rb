# encoding: utf-8

module OhMyLoog
  module Writers
    
    class File4Vim < AbstractWriter
        
    protected

      # Flags may be :b for bold, :i for italic, :u for underline,
      #              :r for reverse  
      def colorize txt, fg, bg, flags
        txt
      end

      def aux_which severity
        "⇒ #{severity} #{'=' * (10 - severity.length)}"
      end
      
      # the datetime is being printed on severity’s dependent background
      def aux_when severity
        "#{Time.now.strftime(DTFMT)}"
      end

    end
  end
end 
