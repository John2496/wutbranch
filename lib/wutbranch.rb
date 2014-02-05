#!/usr/bin/env ruby

require 'net/ssh'
require 'optparse'
require 'yaml'

options = { }

OptionParser.new do |opts|
    opts.banner = "wutbranch"

    opts.on("-g", "--group [Group name]", String, "Show branch status for servers in this group") do |v|
        options[:group] = v
    end

    opts.on("-s", "--silent", String, "Hide messages") do |v|
        options[:silent] = v
    end
end.parse!

useConfigFile = ''
configFilePaths = [
    File.expand_path('~/.wutbranch/config.yaml'),
    File.dirname(__FILE__) + "/../config.yaml"
]

configFilePaths.each do |path|
    if File.exists? path
        useConfigFile = path
        break
    end
end

if useConfigFile.empty?
    puts "config.yaml not found in " + configFilePaths.join(', ');
end

config = YAML.load(File.read(useConfigFile))

servers = config['servers']

if options[:group]
    servers = servers.reject {|key, value| key['group'] != options[:group] }
end

servers.each do |server|
    if server['is_disabled']
        next
    end

    puts server['name']
    puts "-----------------"

    Net::SSH.start(server['host'], server['user'], :keys => [ server['key'] ]) do |ssh|
        server['repos'].each do |name, path|
            cmd = "cd \"#{path}\"; git rev-parse --abbrev-ref HEAD;"
            branch = ssh.exec!(cmd)
            branch.gsub!("\n", '').gsub!("\r", '')
            cmd = "cd \"#{path}\"; git log --format=\"%aN @ %cr -- \\\"%s\\\"\" -n 1"
            commit = ssh.exec!(cmd)
            puts "#{name} on '#{branch}' last commit by #{commit}"
        end
    end

    puts "\n"
end