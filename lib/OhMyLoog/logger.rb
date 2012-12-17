# encoding: utf-8
require 'logger'
require 'OhMyLoog/writers'

module OhMyLoog
  class Loogger
    attr_accessor :colored

    def initialize(name)
      @logger = Logger.new(name)
      @tty = Writers::XTerm256.instance if (IO === name) && name.tty?
      @colored = true
    end

    def pattern s, fg = nil, bg = nil, flags
      @tty.pattern s, fg, bg, flags
    end
    

    def info msg
      add Logger::INFO, msg
    end

  protected
    def add severity = Logger::UNKNOWN, msg = nil
      @logger.formatter = lambda do |severity, datetime, progname, msg|
        dt = @tty.schild(@colored ? type_by_severity(severity) : nil, datetime)
        f, l, m, d = Loogger.caller_method
        format dt, "+#{l} #{f}", msg, m, d
      end
      @logger.add severity, msg
    end

    # dt_size | +row file | msg | method | dir
    def format dt, f, msg, m, d
      dt_sz = @tty.dt_size
      f_sz  = 5 + 1 + 8
      m_sz = 10
      d_sz = 10
      #msg_sz = columns() - 4 * @tty.sep().length - dt_sz - f_sz - m_sz - d_sz
      msg_sz = cols - 12 - dt_sz - f_sz - m_sz - d_sz
      msgs = []
      mc = ''
      msg.split.each do |ms|
        if (mc + ' ' + ms).length > msg_sz
          msgs << mc + ' ' * (msg_sz - mc.length)
          mc = ms + ' '
        else
         mc += ms + ' '
        end
      end
      msgs << mc + ' ' * (msg_sz - mc.length)
      ds = "#{d}".split(File::SEPARATOR)
      ds.shift
      ds_tmp = ds.shift
      dsz = d_sz - ds_tmp.length - 1
      ddd = dsz <= 0 ? ds_tmp.slice(0, d_sz - 1) : ds_tmp + '/' + ' ' * dsz
      
      s = [ 
        "#{dt}", 
        "#{f}", 
        "#{msgs.shift}", 
        "#{m}" + ' ' * (m_sz - m.length), 
        ddd  
      ].join(@tty.sep)

      msgs.each do |msg|
        ds_tmp = ds.shift
        if ds_tmp.nil?
          ddd = ''
        else
          dsz = d_sz - ds_tmp.length - 1
          ddd = dsz <= 0 ? ds_tmp.slice(0, d_sz - 1) : ds_tmp + '/' + ' ' * dsz
        end

        s += "\n" + [ " " * dt_sz, " " * f_sz, "#{msg}", " " * m_sz, ddd ].join(@tty.sep)
      end
      s

    end

    def cols
      (Writers::XTerm256 === @tty) ? Integer(ENV['COLUMNS']) : 80
    end

    def self.caller_method(depth=1)
      parse_caller(caller(depth+1).first)
    end

  private
    # type of message by severity
    def type_by_severity severity
      case severity
        when Logger::UNKNOWN, 'UNKNOWN'
          :label
        when Logger::INFO, 'INFO'
          :info
        when Logger::FATAL, 'FATAL'
          :error
        when Logger::ERROR, 'ERROR'
          :important
        when Logger::WARN, 'WARN'
          :warning
        when Logger::DEBUG, 'DEBUG'
          :inverse
        else
          :success
      end
    end

    #Stolen from ActionMailer, where this was used but was not made reusable
    def self.parse_caller(at)
      if /^(.+?):(\d+)(?::in `(.*)')?/ =~ at
        dir, file = Pathname.new(Regexp.last_match[1]).split
        line      = Regexp.last_match[2].to_i
        method    = Regexp.last_match[3]
        [file, line, method, dir]
      end
    end

  end
end
