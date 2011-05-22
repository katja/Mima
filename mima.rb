$:.push(File.expand_path(File.dirname(__FILE__) + '/lib'))

require 'tokenizer'
require 'mima'
require './init.rb'


if ARGV[0]
  tokenizer = Tokenizer.new(File.open(ARGV[0]))
  mima = Mima.new(tokenizer)
  puts "MEMORY:"
  mima.print_memory
  puts "MIMA IS RUNNING"
  begin
    mima.run
  ensure
    puts "MIMA STOPPED"
    mima.print_memory
  end
  puts "Akku: 0x#{mima.akku.to_s(16)}"
else
  puts "Usage: ruby mima.rb <file>"
end