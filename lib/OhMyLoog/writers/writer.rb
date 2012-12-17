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

      attr_reader :fg, :bg, :flags
     
      def initialize(*args)
        @fg = Color.parse('#fff')
        @bg = nil
        @flags = {}
      end

      def setFg fg
        @fg = Color.parse(fg)
      end
      
      def setBg bg
        @bg = Color.parse(bg)
      end

      def setBold b
        b ? @flags[:b] = b : @flags.delete(:b)
      end

      def setItalic i
        i ? @flags[:i] = i : @flags.delete(:i)
      end

      def setUnderline u
        u ? @flags[:u] = u : @flags.delete(:u)
      end

      def setReverse r
        r ? @flags[:r] = r : @flags.delete(:r)
      end

      def format msg, severity = Logger::UNKNOWN
        "#{auxiliary(severity)}\n#{msg}"
      end
    
      # separator is printed out between columns
      def separator 
        colorize ' | ', Color.parse('#999'), nil, :b => true
      end
      alias sep separator

      #Stolen from ActionMailer, where this was used but was not made reusable
      def self.parse_caller(depth=1)
        if /^(.+?):(\d+)(?::in `(.*)')?/ =~ caller(depth + 1).first
          dir, file = Pathname.new(Regexp.last_match[1]).split
          line      = Regexp.last_match[2].to_i
          method    = Regexp.last_match[3]
          [file, line, method, dir]
        end
      end

    protected
      def prepare str
        colorize str, @fg, @bg, @flags
      end

      def auxiliary severity
        ([aux_which(severity), aux_when(severity), aux_where(severity)] - [nil]).join(sep)
      end

      def aux_where severity
        f, l, m, d = AbstractWriter.parse_caller
        ["+#{l} #{f}", "#{m}()", "#{d}"].join(sep)
      end

    protected
      # type of message by severity
      def self.type_by_severity severity
        case severity
          when Logger::UNKNOWN, 'UNKNOWN'
            :label
          when Logger::INFO, 'INFO'
            :info
          when Logger::FATAL, 'FATAL'
            :fatal
          when Logger::ERROR, 'ERROR'
            :error
          when Logger::WARN, 'WARN'
            :warning
          when Logger::DEBUG, 'DEBUG'
            :inverse
          else
            :important
#            :success
        end
      end

    end

  end
end
