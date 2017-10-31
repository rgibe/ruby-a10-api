module MyOptions

  def MyOptions.parser(list, banner)

    options = {}
    OptionParser.new do |opts|
      opts.banner = banner
      opts.on("-h", "Prints this help") do
        puts opts
        exit
      end
      list.each { |key, value| opts.on("-#{key} NAME", "#{value}") { |i| options["#{key}"] = i } }
    end.parse!

    return options
  end

  def MyOptions.checkRequired(hash, option)
    if hash[option].nil?
      puts "Missed Required Option: -"+option+"\nSee Help: #{$0} -h"
      exit
    end
  end

end
