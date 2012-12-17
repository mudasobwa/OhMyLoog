# encoding: utf-8

require 'singleton'

module OhMyLoog
  module Writers
    module Writer
      class WriterInterfaceNotImplemented < NoMethodError
      end
 
      def self.included(clazz)
        clazz.send(:include, Writer::Methods)
        clazz.send(:extend, Writer::Methods)
        clazz.send(:extend, Writer::ClassMethods)
      end
 
      module Methods
        def not_implemented(clazz, method = nil)
          if method.nil?
            caller.first.match(/in \`(.+)\'/)
            method = $1
          end
          raise Writer::WriterInterfaceNotImplemented.new("#{clazz.class.name} is abstract ('#{method}' must be implemented.)")
        end
      end
 
      module ClassMethods
        def to_implement!(name, *args)
          self.class_eval do
            define_method(name) do |*args|
              not_implemented(self, name)
            end
          end
        end
      end  	  
    end

    class AbstractWriter
      include Singleton
      include Writer

      DTFMT = '%y-%m-%d %H:%M:%S'
      
      to_implement! :colorize

      attr_reader :fg, :bg
      
      @fg = Color.parse('#fff')
      @bg = nil

      def setFG fg
        @fg = Color.parse(fg)
      end
      
      def setBG bg
        @bg = Color.parse(bg)
      end

      def pattern s, fg = nil, bg = nil, flags
        colorize s, fg, bg, flags
      end
    
      def dt_size
        return 2 + DTFMT.length
      end

      # schild is printed out at the beginning of line
      # if size is less or equal zero, the datetime in standard from is being printed
      def schild type, dt = nil
        colorize dt ? " #{Time.now.strftime(DTFMT)} " : dt_size, @fg, Color.preset(type), {}     
      end

      # separator is printed out between columns
      def separator 
        colorize ' | ', Color.parse('#999'), nil, :b => true
      end
      alias sep separator

    end

  end
end
