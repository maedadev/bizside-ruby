require 'rake'
require 'erb'
require 'yaml'
require 'socket'
require 'bizside'

def self.rails_root
  if ENV['RAILS_ROOT'].to_s.empty?
    if interactive?
      case ENV['RAILS_ENV']
      when 'production'
        ret = "/home/#{ENV['USER']}/rails_apps/#{self.add_on_name}/current"
      else
        if defined?(Rails)
          ret = Rails.root.to_s
        else
          ret = `pwd`.strip
        end
      end

      print "RAILS_ROOT [#{ret}]: "
      answer = STDIN.gets.strip
      ret = answer unless answer.empty?
    else
      case ENV['RAILS_ENV']
      when 'test'
        if defined?(Rails)
          ret = Rails.root.to_s
        else
          ret = `pwd`.strip
        end
      end
      puts "RAILS_ROOT [#{ret}]: "
    end
  else
    ret = ENV['RAILS_ROOT']
    puts "RAILS_ROOT [#{ret}]: "
  end

  ENV['RAILS_ROOT'] ||= ret

  if ENV['RAILS_ROOT'].to_s.empty?
    raise "必須です。処理を中止します。"
  end

  ret
end

def self.rails_env
  ret = 'development'

  # RAILS_ENV が未指定の時は、BIZSIDE_ENV を利用できるか確認する
  if ENV['RAILS_ENV'].to_s.empty?
    unless ENV['BIZSIDE_ENV'].to_s.empty?
      case ENV['BIZSIDE_ENV']
      when 'production', 'staging', 'education'
        ret = ENV['RAILS_ENV'] = 'production'
      else
        ret = ENV['RAILS_ENV'] = ENV['BIZSIDE_ENV']
      end
    end
  end

  if ENV['RAILS_ENV'].to_s.empty?
    puts 'RAILS_ENVを選択してください。'
    puts '  1 - production'
    puts '* 2 - development'
    puts '  3 - test'
    puts
    print '> '

    if interactive?
      selected = STDIN.gets.strip.to_i
      ret = ['production', 'development', 'test'][selected - 1] if selected > 0
    else
      puts
      raise "必須です。処理を中止します。"
    end
  else
    ret = ENV['RAILS_ENV']
    puts "RAILS_ENV: #{ret}"
  end

  ENV['RAILS_ENV'] ||= ret
  ret
end

def self.add_on_name
  ret = ENV['ADD_ON_NAME']
  unless ret
    ret = Bizside.config.add_on_name if Bizside.config.add_on_name?
  end
  ret
end

def self.prefix
  ret = ENV['PREFIX']
  unless ret
    ret = Bizside.config.prefix if Bizside.config.prefix?
  end
  raise 'prefix は / から指定してください。' if ret and not ret.start_with?('/')
  ret ||= '/' + add_on_name if Bizside.config.add_on_name?
  ret ||= ask('プリフィックス', :required => true)
  ret
end

def self.interactive?
  yes_confirmed?(ENV['INTERACTIVE'] || 'true')
end

def self.gem_dir
  File.expand_path('../../../..', __FILE__)
end

def self.ask(prompt, options = {})
  raise 'プロンプトは必須です。' if prompt.to_s.empty?

  if options[:default].to_s.empty?
    print prompt + ': '
  elsif options[:password]
    print prompt + " [FILTERED]: "
  else
    print prompt + " [#{options[:default]}]: "
  end

  answer = ''
  if answer.empty? and options.has_key?(:env_key)
    answer = ENV[options[:env_key].to_s].to_s
  end

  if answer.empty?
    if interactive?
      if options[:password]
        system("stty -echo")
        at_exit do
          system("stty echo")
        end
      end
  
      answer = STDIN.gets.strip
  
      if options[:password]
        system("stty echo")
        puts
      end
    else
      puts
    end
  else
    if options[:password]
      puts 'FILTERED'
    else
      puts answer
    end
  end

  if answer.empty? and options.has_key?(:default)
    answer = options[:default].to_s
  end

  if answer.empty? and options[:required]
    raise "必須です。処理を中止します。"
  end

  if block_given?
    answer = yield answer
  end

  answer
end

def self.ask_yes(prompt, options = {})
  answer = ask(prompt, options)
  yes_confirmed?(answer, :fail_on_error => true)
end

def self.ask_env(env_key, options = {})
  cache_file = 'tmp/cache/env'
  cache = File.exist?(cache_file) ? YAML.load_file(cache_file) : {}

  if options.fetch(:cache, false)
    options = options.merge(default: cache.fetch(env_key, options[:default]))
  end

  ENV[env_key] ||= ask(env_key, options.merge(env_key: env_key))

  if options.fetch(:cache, false)
    FileUtils.mkdir_p(File.dirname(cache_file))
    
    cache[env_key] = ENV[env_key]
    File.write(cache_file, YAML.dump(cache))
  else
    if File.exist?(cache_file) and cache[env_key]
      cache.delete(env_key)
      File.write(cache_file, YAML.dump(cache))
    end
  end

  ENV[env_key]
end

def self.yes_confirmed?(yes_value, options = {})
  ret = Bizside::Yes.confirmed?(yes_value)
  if ret.nil?
    if options[:fail_on_error]
      fail "yes/no または true/false 形式で入力してください。answer=#{yes_value}"
    else
      ret = false
    end
  end

  ret
end

def self.ask_host(prompt, options = {})
  if options.has_key?(:default)
    ask(prompt, options)
  else
    ask(prompt, options.merge(default: dev_default_host))
  end
end

def self.dev_default_host
  ret = nil

  udp = UDPSocket.new
  begin
    # クラスBの先頭アドレス,echoポート 実際にはパケットは送信されない。
    udp.connect("128.0.0.0", 7)
    ret = Socket.unpack_sockaddr_in(udp.getsockname)[1]
  ensure
    udp.close
  end

  ret
end

def self.run(*commands)
  commands.each do |c|
    puts c
    fail unless system(c)
  end
end

def self.render(template, options = {})
  FileUtils.mkdir_p(File.dirname(options[:to]))
  File.write(options[:to], ERB.new(File.read(template), 0, '-').result)
end

def self.ip_addresses
  unless @_ip_addresses
    @_ip_addresses = []
    `/sbin/ip route`.split("\n").each do |line|
      elements = line.split.map(&:strip)
      if index = elements.index('src')
        @_ip_addresses << elements[index + 1]
      end
    end
    @_ip_addresses
  end

  @_ip_addresses
end
