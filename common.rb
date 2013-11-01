require 'bundler/setup'
require 'active_record'
require 'benchmark'
require 'perftools'

db_config = {
  adapter:  "postgresql",
  host:     "localhost",
  username: "rails",
  password: "rails",
  database: "rm2-auth"
}
ActiveRecord::Base.establish_connection(db_config)

ActiveRecord::Base.connection.execute(<<SQL
DROP TABLE IF EXISTS "public"."users";

CREATE TABLE "public"."users" (
	"id" int4 NOT NULL,
	"name" varchar(255) NOT NULL,
	CONSTRAINT "users_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."users" OWNER TO "rails";
SQL
                                     )

class User < ActiveRecord::Base
end

#100.times do |i|
#  User.create!(id: i, name: 'Name ' + i.to_s)
#end
