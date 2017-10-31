#!/usr/bin/env ruby

$LOAD_PATH.unshift('./lib')
#p $LOAD_PATH

require 'net/http'
require 'json'
require "openssl"
require 'optparse'
# My Modules
require 'a10Methods'
require 'myOptions'

ARGV << '-h' if ARGV.empty?
options_list = { "p" => "Required", 
		 "v" => "Required", 
		 "s" => "Optional", 
		 "t" => "Optional", 
               }
banner = "Usage: #{$0} -p partition -v virtual-server [-s service-group] [-t template-client-ssl]"
options = MyOptions.parser(options_list, banner)

# Checking for a required argument
MyOptions.checkRequired(options, 'p')
MyOptions.checkRequired(options, 'v')

## Too many arguments have been supplied:
raise "Too many arguments" unless ARGV.empty?

# Variables
partition = options['p']
vs = options['v']
sg = options['s']
ssl = options['t']
home = Dir.pwd
config_data = MyMethods.JsonToHash(home+'/config/config.json')

# Logging On
sign = MyMethods.loggingOn(config_data)

# Switch partition
MyMethods.switch(config_data, sign, partition)

# Set Port URI
ip = config_data['mgmt-ip']
api_vs = config_data['api-vs']
url = "https://"+ip+api_vs+'/'+vs+'/port'

# Port Data
port_data = MyMethods.JsonToHash(home+'/config/port-list.json')

# Set Service Group
unless sg.nil?
  port_data['port-list'][0]['service-group'] = sg # port 80
  port_data['port-list'][1]['service-group'] = sg # port 443
  #p port_data
end

# Template Client SSL
unless ssl.nil?
  port_data['port-list'][1]['template-client-ssl'] = ssl # port 443
  #p port_data
end

# API Call
json = JSON.generate(port_data)
res = MyMethods.http(url, 'POST', json, sign)
puts human = JSON.pretty_generate(res) 

# Logging Off
MyMethods.loggingOff(config_data, sign)
