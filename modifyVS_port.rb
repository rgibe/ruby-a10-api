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
		 "a" => "Optional - Attribute Key:Value pair", 
		 "k" => "Optional - Permitted values http/https", 
               }
banner = "Usage: #{$0} -p partition -v virtual-server [-a key:value] [-k http/https]"
options = MyOptions.parser(options_list, banner)

# Checking for a required argument
MyOptions.checkRequired(options, 'p')
MyOptions.checkRequired(options, 'v')

## Too many arguments have been supplied:
raise "Too many arguments" unless ARGV.empty?

# Variables
partition = options['p']
vs = options['v']
attr = options['a']
attr_key = attr.split(':')[0]
attr_value = attr.split(':')[1]
port = options['k']
home = Dir.pwd
config_data = MyMethods.JsonToHash(home+'/config/config.json')

# Logging On
sign = MyMethods.loggingOn(config_data)

# Switch partition
MyMethods.switch(config_data, sign, partition)

# Set Port URI
ip = config_data['mgmt-ip']
api_vs = config_data['api-vs']

if port.nil? || port == 'https'
  url = "https://"+ip+api_vs+'/'+vs+'/port/443+https'
elsif port == 'http'
  url = "https://"+ip+api_vs+'/'+vs+'/port/80+http'
else
  raise "Not an acceptable value \nSee Help: #{$0} -h"
end

# Attribute data
port_data = MyMethods.JsonToHash(home+'/config/port-attribute.json')

unless attr.nil?
  port_data['port'][attr_key] = attr_value # port 443
end
 
# API Call
json = JSON.generate(port_data)
res = MyMethods.http(url, 'POST', json, sign)
puts human = JSON.pretty_generate(res) 

# Logging Off
MyMethods.loggingOff(config_data, sign)
