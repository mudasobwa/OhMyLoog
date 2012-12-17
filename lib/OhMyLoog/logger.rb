# encoding: utf-8
require 'logger'
require 'OhMyLoog/writers'

module OhMyLoog
  class Loogger

    def initialize(name)
      @logger = Logger.new(name)
      @tty = ((IO === name) && name.tty?) ? Writers::XTerm256.instance : Writers::File4Vim.instance
    end

    def backend
      @logger.class 
    end

    def fatal msg
      add msg, Logger::FATAL
    end

    def error msg
      add msg, Logger::ERROR
    end

    def warning msg
      add msg, Logger::WARN
    end
    alias warn warning

    def info msg
      add msg, Logger::INFO
    end

    def debug msg
      add msg, Logger::DEBUG
    end

  protected
    def add msg, severity = Logger::UNKNOWN
      @logger.formatter = lambda do |severity, datetime, progname, msg|
        @tty.format msg, severity
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

  end
end
