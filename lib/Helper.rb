# This program is intended to help to speed up some common system level management tasks.
# Nov 2012 ys

require "erb"
require_relative "Data"

module Haji

  class Helper

    def initialize(args)
      init_paths
      load_data

      args = args.map { |e| e = e.gsub '-', '_' }

      if File.exists? "#{@home}/Plugin.rb"
        require "#{@home}/Plugin"
        extend Plugin
      end

      case args.length
      when 0
        puts 'You should at least give one action.', '',
             'For more help, input: haji help'
      when 1
        begin
          self.send args[0].sub(/^(_+)/, '')
        rescue NoMethodError => e
          puts e
        end
      else
        begin
          self.send args[0].sub(/^(_+)/, ''), *args[1 .. -1]
        rescue NoMethodError => e
          puts e
        end
      end
    end

    # Display help info.
    def help
      make_help
      system "less #{@help_path}"
    end

    # Add a public key to the 'authorized_keys' file.
    def add_pub_key key = nil
      puts "\n>> Add Public Key <<"

      if not key
        puts 'Input your public key for none pasaaword login: '
        key = input
      end

      if not key.empty?
        path = File.join(File::SEPARATOR , Dir.home, '.ssh', 'authorized_keys')
        File.open(path, 'a') do |f|
          f.write(key)
        end
      else
        puts 'Key not added.'
      end
    end
    
    # Help to setup the basic info of the git.
    def set_git name = nil, email = nil
      puts "\n>> Git Setup <<"

      if not name
        print 'Your name: '
        name = input
      end

      if not name.empty?
        `git config --global user.name '#{name}'`
        @data.name = name
      else
        puts 'Name not changed.'
      end

      if not email
        print 'Your email: '
        email = input
      end

      if not email.empty?
        `git config --global user.email '#{email}'`
        @data.email = email
      else
        puts 'Email not changed.'
      end

      save_data
    end

    # Help to setup the Apache default web directory.
    def set_www_dir dir = nil
      puts "\n>> Apache Default directory Setup <<"

      if not dir
        print 'Input target directory: '
        dir = input
      end

      if not dir.empty?
        dir = File.expand_path(dir)
 
        if Dir.exists? dir
          `rm #{@home}/cradle/www && ln -s '#{dir}' #{@home}/cradle/www`
        else
          puts "'#{dir}' doesn't exists!"
        end
      else
        puts 'Dir not changed.'
      end
    end

    # Clean the system temp files and history cache.
    def clean
      require 'fileutils'

      list = [
        '.zsh_history',
        '.viminfo',
        '.lesshst',
        '.cache',
        '.irb-history',
        '.mysql_history']

      dir = '/root/'
      list.each { |f|
        FileUtils.rm_rf(dir + f)
      }

      dir = "#{@home}/"
      list.each { |f|
        FileUtils.rm_rf(dir + f)
      }
      # Remove all cache files.
      `sudo find #{dir} -name '._*' -exec sudo rm {} \\;`
      `sudo find #{dir} -name '.DS_Store' -exec sudo rm {} \\;`

      # Remove logs
      `sudo find /var/log -iname '*.log' -exec sudo rm {} \\;`
      `sudo find /var/log -iname '*.log.*' -exec sudo rm {} \\;`
      `sudo find /var/log -iname 'log.*' -exec sudo rm {} \\;`
      `sudo find /var/log -iname '*.err' -exec sudo rm {} \\;`
    end

    # Self update tool.
    def update remote = :r
      # Update from Github.com.
      if remote == :r
        system "cd #{@repo_dir}
          git fetch --all
          git reset --hard origin/master"
      end
      
      make_help
      make_scripts

      # Update helpers.
      `sudo rm /usr/bin/haji`
      `sudo ln -s #{@repo_dir}/haji.rb /usr/bin/haji`

      `sudo cp #{@templates_dir}/welcome_msg.tmp /etc/network/if-up.d/welcome_msg`
      `sudo chmod a+x /etc/network/if-up.d/welcome_msg`

      # Copy some script.
      `cp #{@templates_dir}/zshrc.sh #{@home}/.zshrc`
      `cp #{@templates_dir}/.gitconfig #{@home}/.gitconfig`

      if not Dir.exists? "#{@home}/.oh-my-zsh/completions"
        Dir.mkdir "#{@home}/.oh-my-zsh/completions"
      end
      `cp #{@templates_dir}/zsh_completion.tmp #{@home}/.oh-my-zsh/completions/_haji`

      set_git @data.name, @data.email

      puts 'Update Complete.'
    end

    # Setup essential files for the server.
    def setup
      add_pub_key
      set_git
      set_www_dir

      puts "\nCreate essential files..."
      
      if not File.exists? "#{@home}/.bashrc"
        `touch #{@home}/.bashrc`
        `sudo rm /root/.bashrc`
        `sudo ln -s #{@home}/.bashrc /root/.bashrc`
      end

      if not File.exists? "#{@home}/Plugin.rb"
        `cp #{@templates_dir}/Plugin.rb #{@home}/Plugin.rb`
        `sudo ln -s #{@templates_dir}/Plugin.rb /root/Plugin.rb`
      end

      if File.exists? "#{@home}/.sealed"
        File.rename("#{@home}/.sealed", "#{@home}/.unsealed")
      end

      puts "\nSetup complete."
    end

    private

    def init_paths
      @home = '/home/saya'
      @helper_dir = File.dirname __FILE__
      @templates_dir = @helper_dir + '/templates'
      @data_path = @helper_dir + '/data.db'
      @repo_dir = File.dirname @helper_dir
      @help_path = @helper_dir + '/help.tmp'
    end

    def input
      return $stdin.gets.chomp
    end

    def make_help
      ms = self.public_methods(false)

      @@methods_info = []

      File.open(@help_path, "w") { |f|
        f.puts "This a helper to speed up basic system task of Haji server.\n\n"
        f.puts 'SYNOPSIS'
        f.puts ' ' * 4 + 'haji [actions] [arguments...]', ''

        f.puts 'DETAILS'
        ms.each { |m|
          info = metod_reflect(m)
          f.puts ' ' * 4 + info[0],
                 ' ' * 8 + info[1], ''
          @@methods_info.push info
        }

        f.puts "For more detail, please see the source code of file '#{__FILE__}'."
      }
    end

    def make_scripts
      Dir.glob(@templates_dir + '/*.erb.*') { |file|
        src = File.read file
        erb = ERB.new src
        compiled = erb.result binding
        File.open(file.sub(/\.erb.*/, '.tmp'), "w") { |f| f.write compiled }
      }
    end
   
    # Auto get the comments of each function.
    def metod_reflect m
      m = method(m)
      location = m.source_location
      
      if not defined? @@code_num or
        @@code_num != location[0]
      then
        @@code_num = location[0]
        @@code_lines = File.readlines location[0]
      end

      return @@code_lines[location[1] - 1].sub(/\s+def\s+/, '').gsub('_', '-'),
             @@code_lines[location[1] - 2].sub(/\s+#\s+/, '')
    end

    def load_data
      if not File.exists? @data_path
        @data = Data.new
      else
        File.open(@data_path, "r") { |f|
          @data = Marshal.load f
        }
      end
    end

    def save_data
      File.open(@data_path, "w") { |f|
        Marshal.dump @data, f
      }
    end

    def read_line(filename, number)
      counter = 0
      line = nil
      File.foreach(filename) do |l|
        counter += 1
        if counter == number
          line = l.chomp
          break
        end
      end
      line = nil if counter != number
      line
    end

  end

end
