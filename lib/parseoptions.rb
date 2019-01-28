require 'optparse'
require 'optparse/time'
require 'ostruct'
class ParseOptions

  CODES = %w[iso-2022-jp shift_jis euc-jp utf8 binary]
  CODE_ALIASES = {"jis" => "iso-2022-jp", "sjis" => "shift_jis"}

  def self.parse(args)
    options = OpenStruct.new

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: %prog [options]"
      opts.separator ""
      opts.separator "Report options:"
      opts.on('-c', '--cluster [Address]', "Rubrik Cluster Name") do |cluster|
        options[:cluster] = cluster;
      end
      opts.on('-f', '--from [string]', "Start Date (YYYY-mm-dd)") do |g|
        options[:from_date] = g;
      end
      opts.on('-t', '--to [string]', "End Date (YYYY-mm-dd)") do |g|
        options[:to_date] = g;
      end
      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end
    end
    opt_parser.parse!(args)
    options
  end
end
