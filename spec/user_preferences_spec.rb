require './lib/api_models/environment.rb'
require './lib/api_models/user_preferences.rb'
require 'rspec'

describe '#get_matching_projects'do
	before(:all) do
		require 'stretcher'
		ES_SERVER = Stretcher::Server.new('http://localhost:9200')
		# ES_SERVER.index(:matching_projects).delete
		# ES_SERVER.index(:matching_projects).create
		# index_name = 'matching_projects'
		# ES_INDEX = ES_SERVER.index(index_name)

		# data = [{"_type" => "project", status: "active", name: "Brooklyn Project", value: "15,0000,0000", assetclass: "A", state: "New York"},
		# 		{"_type" => "project", status: "active", name: "Flushing Meddows", value: "18,0000,0000", assetclass: "A", state: "New York"},
		# 		{"_type" => "project", status: "active", name: "Cleveland", value: "12,5000,0000", assetclass: "B+", state: "Ohio"},
		# 		{"_type" => "project", status: "inactive", name: "Brookline", value: "18,0000,0000", assetclass: "A+", state: "Massachusetts"},
		# 		{"_type" => "project", status: "active", name: "Oakland", value: "7,0000,0000", assetclass: "C", state: "California"},
		# 		{"_type" => "project", status: "inactive", name: "Reno", value: "3,0000,0000", assetclass: "B", state: "Nevada"},
		# 		{"_type" => "project", status: "active", name: "Chicago", value: "1,0000,0000", assetclass: "C+", state: "Illinois"},
		# 		{"_type" => "project", status: "active", name: "Louisville", value: "6,0000,0000", assetclass: "A", state: "Kentucky"},
		# 		{"_type" => "project", status: "active", name: "Seattle", value: "13,0000,0000", assetclass: "A+", state: "Washington"}]

		# 			res = ES_INDEX.bulk_index(data)
					
		# 			ES_INDEX.status
		# 			puts res
		#
		#<Hashie::Mash _id="H1pntmAxRsu-9qnaEG1Zww" _index="keepbusy_user_preferences" _score=1.0 _source=#<Hashie::Mash assetclass=["C+", "C"] debtinvestments=#<Hashie::Mash maximum=1000000 minimum=50001> debtirr=#<Hashie::Mash minimum="4"> equityinvestments=#<Hashie::Mash maximum=10000000 minimum=50001> equityirr=#<Hashie::Mash minimum="5"> locationclass=["A"] propertytype=["Multi-family", "Retail"] states=["Illinois"]> _type="user_preference" assetclass=["C+", "C"] debtinvestments=#<Hashie::Mash maximum=1000000 minimum=50001> debtirr=#<Hashie::Mash minimum="4"> equityinvestments=#<Hashie::Mash maximum=10000000 minimum=50001> equityirr=#<Hashie::Mash minimum="5"> locationclass=["A"] propertytype=["Multi-family", "Retail"] states=["Illinois"]>
	end

		it "should get matching projects with the name not nil" do
		

			prefhash = {"assetclass"=>["B+"],"states"=>["Ohio"],"investments"=>{"minimum"=>50001,"maximum"=>60000}, "locationclass" =>["B+"], "propertytype" =>["Warehouse"]}
			user = NotificationHandler::UserPreferences.new(prefhash)
			res = user.get_matching_projects 
			puts res.inspect
			prefhash["states"].should include "Ohio"
			res.first[:state].should eql "Ohio"
			puts "you have a matching project"
		 
		  
  	end
  	it "should return no projects" do
  		prefhash = {"assetclass"=>["B+"],"states"=>["Wisconsin"],"investments"=>{"minimum"=>50001,"maximum"=>60000}, "locationclass" =>["C+"], "propertytype" =>["Multi-family"]}
  		user = NotificationHandler::UserPreferences.new(prefhash)
  		res = user.get_matching_projects
  		 prefhash["states"].should include "Wisconsin"
  		res.length.should eql 0
  		puts "you have no matching projects"
  	end
#locationclass=["A"] propertytype=["Multi-family", "Retail"]
		it "should return a value based on assetclass" do
  		prefhash = {"assetclass"=>["A"],"states"=>["Kentucky"],"investments"=>{"minimum"=>50001,"maximum"=>60000}, "locationclass" =>["A"], "propertytype" =>["Mixed-Use"]}
  		user = NotificationHandler::UserPreferences.new(prefhash)
  		res = user.get_matching_projects
  		prefhash["assetclass"].should include "A"
  		res.first[:assetclass].should eql "A"
  		puts "you have a matching project"
  	end
  	#"_id":"ydX-QQ83Sqy5_fVFno-Vgw"
#[{"_type" => "project", "belongs_to" => "profileres[0]._id", status: "active", name: "Brooklyn Project", value: 1500000000, assetclass: "A", state: "New York", propertytype: "Single Family", locationclass: "A"},
  	it "should return a value based on investments" do
  		prefhash = {"assetclass"=>["A"],"_id" => "ydX-QQ83Sqy5_fVFno-Vgw", "states"=>["New York"],"investments"=>{"minimum"=>50001,"maximum"=>60000}, "locationclass" =>["A"], "propertytype" =>["Single Family"]}
  		user = NotificationHandler::UserPreferences.new(prefhash)
  		res = user.get_matching_projects
  		prefhash["investments"]["minimum"].should eql 50001
  		res.first[:value].should eql 1500000000
  		puts "you have a matching project"
  	end
end



