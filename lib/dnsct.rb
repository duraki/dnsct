# frozen_string_literal: true

require "./dnsct/version"
require "./dnsct/search"
require "./dnsct/manager"

require "optparse"

options = {}

module Dnsct
  class Error < StandardError; end
end

index = 0

options = {}
ARGV << '-h' if ARGV.empty?
options[:verbose] = false
options[:resume] = false

OptionParser.new do |opts|
  opts.banner = "Usage: dnsct.rb [options]"

  opts.on('-h', '--help', 'Display this message') do
    puts opts 
    exit
  end

  opts.on('-fFILE', '--file=FILE', String, 'DNS List Input') do |f|
    options[:file] = f
    if !File.exists?(options[:file])
      puts "DNS List Input does not exists. Filename <#{options[:file]}> is missing."
      exit
    end
  end

  opts.on('-r', '--resume', "Resume on index") do |r|
    options[:resume] = r
    if r
      if File.exists?("index")
        index = File.read("index")
      end
    end
  end

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end

  opts.on("--reset", "Reset index") do |rs|
    File.write("index", 0)
    puts "Index reset completed successfully."
    exit
  end
end.parse!

if (options[:file])
  puts "Running dnsct with options:"
  puts "  + Filename: #{options[:file]}"
  puts "  + Resume  : #{options[:resume]} via ix [#{index}]"
  puts "  + Verbose : #{options[:verbose]}"
end

search = Dnsct::Search.new
manager = Dnsct::Manager.new

# We will be working with arrays so it is easier to reindex
cctld = File.open(options[:file], "rb:UTF-8")
cctld.each do |line|
  begin
    puts "Checking domain: #{line}"
    sub_per_domain = search.domain_search(line)
    pp sub_per_domain
  rescue
    next
  end
end
# cctld[index].each do |cctld|
#   pp cctld
#   exit
# end

# search.domain_search("mtel.ba")
