require './common.rb'

arel = User.arel_table[:id].eq(1)
n = 50000

Benchmark.bm(10) do |x|
  x.report('String:')     { n.times { User.where("id = ?", 1)    }}
  x.report('Hash:')       { n.times { User.where(id: 1)          }}
  x.report('ARel exp:')   { n.times { User.arel_table[:id].eq(1) }}
  x.report('ARel:')       { n.times { User.where(arel)           }}
end

s1 = User.where("id = ?", 1)
s2 = User.where(id: 1)
s3 = User.where(User.arel_table[:id].eq(1))

n = 50000
Benchmark.bm(10) do |x|
  x.report('SQL+String:') { n.times { s1.to_sql}}
  x.report('SQL+Hash:')   { n.times { s2.to_sql}}
  x.report('SQL+ARel:')   { n.times { s3.to_sql}}
end
