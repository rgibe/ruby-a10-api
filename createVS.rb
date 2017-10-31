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
		 "i" => "Required", 
               }
banner = "Usage: #{$0} -p partition -v virtual-server -i vip-address"
options = MyOptions.parser(options_list, banner)

# Checking for a required argument
MyOptions.checkRequired(options, 'p')
MyOptions.checkRequired(options, 'v')
MyOptions.checkRequired(options, 'i')

## Too many arguments have been supplied:
raise "Too many arguments" unless ARGV.empty?

# Variables
partition = options['p']
vs = options['v']
address = options['i']
home = Dir.pwd
config_data = MyMethods.JsonToHash(home+'/config/config.json')

# Logging On
sign = MyMethods.loggingOn(config_data)

# Switch partition
MyMethods.switch(config_data, sign, partition)

# Set Port URI
ip = config_data['mgmt-ip']
api_vs = config_data['api-vs']
url = "https://"+ip+api_vs

# VS Data
vs_data = MyMethods.JsonToHash(home+'/config/virtual-server.json')

# Setting new values
vs_data['virtual-server-list'][0]['name'] = vs
vs_data['virtual-server-list'][0]['ip-address'] = address
#p data_hash

# API Call
json = JSON.generate(vs_data)
res = MyMethods.http(url, 'POST', json, sign)
puts human = JSON.pretty_generate(res) 

# Logging Off
MyMethods.loggingOff(config_data, sign)
