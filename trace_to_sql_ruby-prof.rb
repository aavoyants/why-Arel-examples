require './common.rb'
require 'ruby-prof'

  #  set_trace_func proc { |event, file, line, id, binding, classname|
  #    printf "%8s %s:%-2d %10s %8s\n", event, file, line, id, classname
  #  }



RubyProf.start
1000.times do |i|
  User.where("id = ?", 1)#.to_sql
end
results = RubyProf.stop
File.open "callgrind.string.bin", 'w' do |file|
  RubyProf::CallTreePrinter.new(results).print(file)
end

RubyProf.start
1000.times do |i|
  User.where(id: 1)#.to_sql
end
results = RubyProf.stop
File.open "callgrind.hash.bin", 'w' do |file|
  RubyProf::CallTreePrinter.new(results).print(file)
end

RubyProf.start
1000.times do |i|
  User.arel_table[:id].eq(1)
end
results = RubyProf.stop
File.open "callgrind.arel_build.bin", 'w' do |file|
  RubyProf::CallTreePrinter.new(results).print(file)
end


arel = User.arel_table[:id].eq(1)
RubyProf.start
1000.times do |i|
  User.where(arel)#.to_sql
end
results = RubyProf.stop
File.open "callgrind.arel.bin", 'w' do |file|
  RubyProf::CallTreePrinter.new(results).print(file)
end
