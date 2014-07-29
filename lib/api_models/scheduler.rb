require './lib/api_models/environment.rb'
module NotificationHandler

	class Scheduler 


	KB_LOG = "/Users/joshthedudeoflife/email_scheduler_svc/log/run.log"
	LOG = Logger.new(KB_LOG)
  LOG.info "Started running (#{self}): Log file: #{KB_LOG}"
  puts "Logging to #{KB_LOG}"
		
	def logger
  	LOG
  end

 		def initialize
 			@scheduler = Rufus::Scheduler.new
 			timer
			@scheduler.join
 		end

		
		def process_preferences
			list = get_user_preferences
			list.each do |pref|
				up = UserPreferences.new(pref)
				logger.info "this is user_preference beginning"
				logger.info pref.to_json
				logger.info "this is user_preference end"
				# if pref [:assetclass] == ["C"]&&["D"]
				# 	puts "Their assetclass choice is C and D"
				# elsif pref [:assetclass] == ["A"]&&["B"]
				# 	puts "Their assetclass choice is A and B"
				# else
				# 	puts "They have a lot more choices"
				# end
			end
		end

		def get_user_preferences
			#eventually put this in a loop where it will process the first hundered then the next hundred
			#update each record with the last time it was processed, this will effect the query
			#look into the stretcher doc to see how to pull out each JSON documents.
			res = ES_INDEX.type(:user_preference).search(query: {match_all: {}})
			res.documents
		end


		def timer
			NotificationHandler.logger.info "timer"
			@scheduler.every '15s' do
				process_preferences
			end
		end

	end

	scheduler = Scheduler.new
end
