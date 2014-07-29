#create a new index to push ES stuff into
require 'stretcher'
ES_SERVER = Stretcher::Server.new('http://localhost:9200')
index_name = 'profile'
ES_SERVER.index(:profile).delete rescue all
ES_SERVER.index(:profile).create( "mappings"=>{
           "project" => {
           "dynamic_templates" => [
             {
                "all_strings" => {
                    "match" => "*",
                    "match_mapping_type" => "string",
                    "mapping" => {
                        "type" => "string",
                        "index" => "not_analyzed"
                    }
                }
            }

          ]}})

server = Stretcher::Server.new('http://localhost:9200')
server.index(:keepbusy_user_preferences).delete rescue all
server.index('keepbusy_user_preferences').create(
 "mappings"=>{
           "keep_busy_user_preferences" => {
               "dynamic_templates" => [ 
                    { 
                         "all_strings" => 
                              { "match" => "*", "match_mapping_type" => "string", "mapping" => { "type" => "string", "index" => "not_analyzed"}}}]
          },
          "keep_busy_project_notifications" => {
               "dynamic_templates" => [ 
                    { 
                         "all_strings" => 
                              { "match" => "*", "match_mapping_type" => "string", "mapping" => { "type" => "string", "index" => "not_analyzed"}}}]
          }
     }
)

#need to add items to data.
ES_INDEX = ES_SERVER.index(index_name)
data = [{"_type" => "profile", email: "jachou4291983@gmail.com"}]
profileres = ES_INDEX.bulk_index(data)
puts profileres.inspect
puts profileres[:items][0][:create][:_id]
puts "this is profilers"

ES_SERVER = Stretcher::Server.new('http://localhost:9200')
index_name = 'matching_projects'
ES_SERVER.index(:matching_projects).delete rescue all
ES_SERVER.index(:matching_projects).create( "mappings"=>{
           "project" => {
           "dynamic_templates" => [
             {
                "all_strings" => {
                    "match" => "*",
                    "match_mapping_type" => "string",
                    "mapping" => {
                        "type" => "string",
                        "index" => "not_analyzed"
                    }
                }
            }

          ]}})
ES_INDEX = ES_SERVER.index(index_name)

			data = [{"_type" => "project","belongs_to" => profileres [:items][0][:create][:_id], status: "active", name: "Brooklyn Project", value: 1500000000, assetclass: "A", state: "New York", propertytype: "Single Family", locationclass: "A"},
				{"_type" => "project", "belongs_to" => profileres [:items][0][:create][:_id], status: "active", name: "Flushing Meddows", value: 1800000000, assetclass: "A", state: "New York", propertytype: "Industrial", locationclass: "A"},
				{"_type" => "project", "belongs_to" => profileres [:items][0][:create][:_id], status: "active", name: "Cleveland", value: 1250000000, assetclass: "B+", state: "Ohio", propertytype: "Warehouse", locationclass: "B+"},
				{"_type" => "project", "belongs_to" => profileres [:items][0][:create][:_id], status: "inactive", name: "Brookline", value: 1800000000, assetclass: "A+", state: "Massachusetts", propertytype: "Other", locationclass: "A+"},
				{"_type" => "project", "belongs_to" => profileres [:items][0][:create][:_id], status: "active", name: "Oakland", value: 700000000, assetclass: "C", state: "California", propertytype: "Industrial", locationclass: "B"},
				{"_type" => "project", "belongs_to" => profileres [:items][0][:create][:_id], status: "inactive", name: "Reno", value: 300000000, assetclass: "B", state: "Nevada", propertytype: "Office", locationclass: "D"},
				{"_type" => "project", "belongs_to" => profileres [:items][0][:create][:_id], status: "active", name: "Chicago", value: 100000000, assetclass: "C+", state: "Illinois", propertytype: "Office", locationclass: "D"},
				{"_type" => "project", "belongs_to" => profileres [:items][0][:create][:_id], status: "active", name: "Louisville", value: 600000000, assetclass: "A", state: "Kentucky", propertytype: "Mixed-Use", locationclass: "A"},
				{"_type" => "project", "belongs_to" => profileres [:items][0][:create][:_id], status: "active", name: "Seattle", value: 1300000000 , assetclass: "A+", state: "Washington", propertytype: "Single Family", locationclass: "A+"}]

			res = ES_INDEX.bulk_index(data)
			#p
			
			ES_INDEX.status
			puts res
