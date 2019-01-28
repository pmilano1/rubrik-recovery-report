$LOAD_PATH.unshift File.expand_path('../lib/', __FILE__)
require 'parseoptions.rb'
require 'getCreds.rb'
require 'restCall.rb'
require 'json'
require 'uri'

Options = ParseOptions.parse(ARGV)
Creds = getCreds(Options.cluster)
if (!Creds)
  puts "Couldn't get Credentials!"
  exit
end

if !Options.from_date || !Options.to_date || !Options.cluster
  print "Message: --from and --to must be specified"
  exit()
end

# Page through results to assemble hash of events
dataset = Array.new
last = false
done = false
page = 0
puts "Getting report data from Rubrik"
from_date = URI::encode(Options.from_date.gsub(/\-/, '/'))
to_date = URI::encode(Options.to_date.gsub(/\-/, '/'))
until done
  if last
    page += 1
    go = "after_id=#{last}"
    call = "/api/internal/event?limit=100&object_type=VmwareVm&event_type=Recovery&before_date=#{to_date}&after_date=#{from_date}&#{go}"
    puts "Page #{page}"
  else
    page += 1
    call = "/api/internal/event?limit=100&event_type=Recovery&before_date=#{to_date}&after_date=#{from_date}"
    #call = "/api/internal/event?limit=100&object_type=VmwareVm&event_type=Recovery&before_date=#{to_date}&after_date=#{from_date}"
    puts "Page #{page}"
  end
  o = restCall(Creds[Options.cluster], call, '', 'get')
  o['data'].each do |l|
    dataset << l
    last = l['id']
  end
  if o['hasMore'] == false
    done = 1
  end
end

# Assemble output for file
header = "Mount Time, Object Name, Message"
reportname = "#{Options.cluster}-#{Options.from_date}~#{Options.to_date}"
IO.write(reportname + ".csv", header + "\n")
dataset.each do |d|
  arr = Array.new
  arr << d['time']
  arr << d['objectName']
  arr << JSON.parse(d['eventInfo'])['message']
  IO.write(reportname + ".csv", (arr.map! {|e| "\"#{e}\""}).join(',') + "\n", mode: 'a')
end
pp "Report was saved as " + reportname + ".csv"
