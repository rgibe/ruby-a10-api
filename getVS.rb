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
               }
banner = "Usage: #{$0} -p partition -v virtual-server"
options = MyOptions.parser(options_list, banner)

# Checking for a required argument
MyOptions.checkRequired(options, 'p')
MyOptions.checkRequired(options, 'v')

## Too many arguments have been supplied:
raise "Too many arguments" unless ARGV.empty?

# Variables
partition = options['p']
vs = options['v']
home = Dir.pwd
outfile = 'output.json'
config_data = MyMethods.JsonToHash(home+'/config/config.json')

# Logging On
sign = MyMethods.loggingOn(config_data)

# Switch partition
MyMethods.switch(config_data, sign, partition)

# Set Port URI
ip = config_data['mgmt-ip']
api_vs = config_data['api-vs']
url_vs = "https://"+ip+api_vs
url = url_vs+'/'+vs

# API Call
res = MyMethods.http(url, 'GET', nil, sign)
puts human = JSON.pretty_generate(res) 

# JSON to File
File.write(outfile, human)

# Logging Off
MyMethods.loggingOff(config_data, sign)
