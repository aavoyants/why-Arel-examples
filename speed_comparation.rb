require './common.rb'
require './sql_generator.rb'
require 'activerecord-import'
require 'securerandom'
require 'json'
require 'pry'

db_config = {
  adapter:  "postgresql",
  host:     "localhost",
  username: "rails",
  password: "rails",
  database: "rm2-auth"
}
ActiveRecord::Base.establish_connection(db_config)

ActiveRecord::Base.connection.execute(<<SQL
DROP TABLE IF EXISTS "public"."postcodes";

CREATE TABLE "public"."postcodes" (
	"id" int4,
	"code" varchar(255) NOT NULL,
	"lat" numeric(8,5) NOT NULL DEFAULT 0.00000,
	"lon" numeric(8,5) NOT NULL DEFAULT 0.00000
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."postcodes" OWNER TO "rails";
SQL
                                     )

class Postcode < ActiveRecord::Base
  validates :code, :lat, :lon, presence: true
  validates_uniqueness_of :code
  validates_numericality_of :lat, :lon
end

postcodes_json = './postcodes.json'
postcodes      = []

if File.exists? postcodes_json
  puts 'Loading postcodes'
  postcodes = JSON.parse(File.read(postcodes_json))
else
  puts "Generating postcodes...\n"
  10000.times do |i|
    postcodes << {'code' => SecureRandom.hex(8), 'lat' => rand.round(5), 'lon' => rand.round(5)}
    print "#{i}... " if i%10_000 == 0
  end

  puts "Done."
  File.open "postcodes.json", 'w' do |file|
    file.write(JSON.dump(postcodes))
  end
end

Benchmark.bm(25) do |x|

  x.report('AR:') do
    postcodes.each { |h| Postcode.create!(h)}
    Postcode.delete_all
  end

  x.report('AR, mass insert:') do
    Postcode.create!(postcodes)
    Postcode.delete_all
  end

  x.report('AR, no validations:') do
    postcodes.each do |h|
      p = Postcode.new(h)
      p.save!(validate: false)
    end
    Postcode.delete_all
  end

  x.report('AR Import gem, models:') do
    ps = []
    postcodes.each do |h|
      ps << Postcode.new(h)
    end
    Postcode.import ps
    Postcode.delete_all
  end

  x.report('AR Import gem, raw data:') do
    columns = postcodes.first.keys
    values  = postcodes.map(&:values)
    Postcode.import columns, values
    Postcode.delete_all
  end

  x.report('Generated SQL:') do
    postcodes.each do |h|
      query = build_query(h['code'], h['lat'].to_f.round(5), h['lon'].to_f.round(5))
      ActiveRecord::Base.connection.execute query
    end
    Postcode.delete_all
  end

  x.report('RAW SQL:') do
    postcodes.each do |h|
      ActiveRecord::Base.connection.execute "INSERT
        INTO postcodes(code, lat,lon)
        VALUES (
          '#{h['code']}',
          #{'%.5f' % h['lat']},
          #{'%.5f' % h['lon']});"
    end
    Postcode.delete_all
  end
end
