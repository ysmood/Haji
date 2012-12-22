# This program is intended to help to speed up some common system level management tasks.
# Nov 2012 ys
module Ys
  class Haji_helper

    def initialize(args)
      args = args.map { |e| e = e.gsub '-', '_' }

      case args.length
      when 0
        puts 'You should at least give one command.', ''
        help
      when 1
        self.send args[0]
      else
        begin
          self.send args[0], *args[1 .. -1]
        rescue Exception => e
          puts e
        end
      end
    end

    # Display help info.
    def help
      ms = self.public_methods(false)

      puts "This a helper to speed up basic system task of Haji server.\n\n"
      puts 'SYNOPSIS'
      puts '    haji [options] [arguments]', ''

      puts 'OPTIONS'
      ms.each { |m| puts "    " + m.to_s.gsub('_', '-') }
      puts

      puts 'DETAILS'
      ms.each { |m| puts metod_reflect(m) }

      puts '', "For more detail, please see the source code of file '#{__FILE__}'."
    end

    # Add a public key to the 'authorized_keys' file.
    def add_pub_key key = nil
      if not key
        puts 'Input your public key: '
        key = $stdin.gets
      end

      path = File.join(File::SEPARATOR , Dir.home, '.ssh', 'authorized_keys')
      File.open(path, 'a') do |f|
        f.write(key)
      end
    end
    
    # Help to setup the basic info of the git.
    def setup_git name = nil, email = nil
      if not name or not email
        puts 'Git Setup'
        
        print 'Your name: '
        name = $stdin.gets.chomp

        print 'Your email: '
        email = $stdin.gets.chomp
      end

      `git config --global user.name '#{name}'`
      `git config --global user.email '#{email}'`
    end

    # Help to setup the apache2 default web directory.
    def set_www_dir dir = nil
      if not dir
        print 'Input target directory: '
        dir = $stdin.gets.chomp
      end
      dir = File.expand_path dir
      `rm /home/saya/cradle/www && ln -s '#{dir}' /home/saya/cradle/www`
    end

    # Clean the system temp files and history cache.
    def clean
      require 'fileutils'

      list = ['.zsh_history', '.viminfo', '.lesshst', '.cache']

      dir = '/root/'
      list.each { |f|
        FileUtils.rm_rf(dir + f)
      }

      dir = '/home/saya/'
      list.each { |f|
        FileUtils.rm_rf(dir + f)
      }
      # Remove all cache files.
      `find #{dir} -name '._*' -exec rm {} \\;`
      `find #{dir} -name '.DS_Store' -exec rm {} \\;`

      # Remove logs
      `find /var/log -iname '*.log' -exec rm {} \\;`
      `find /var/log -iname '*.log.*' -exec rm {} \\;`
      `find /var/log -iname 'log.*' -exec rm {} \\;`
      `find /var/log -iname '*.err' -exec rm {} \\;`
    end

    def self_update
      
    end

    private
    
    def metod_reflect m
      if not defined? @@code_lines
        @@code_lines = IO.readlines __FILE__
      end

      m = method(m)
      ret = ''
      ret += @@code_lines[m.source_location[1] - 1].gsub('def ', '')
      ret += @@code_lines[m.source_location[1] - 2] + "\n"
      ret
    end

  end
end
