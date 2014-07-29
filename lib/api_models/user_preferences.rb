
module NotificationHandler
	class UserPreferences

	KB_LOG = "/Users/joshthedudeoflife/email_scheduler_svc/log/run.log"
	LOG = Logger.new(KB_LOG)
  LOG.info "Started running (#{self}): Log file: #{KB_LOG}"
  puts "Logging to #{KB_LOG}"
		
		def logger
  	LOG
  end
		def initialize prefhash 
			@emailtemplate = File.open("/Users/joshthedudeoflife/email_scheduler_svc/lib/api_models/email_template.html", "r+")
			@contents = @emailtemplate.read
			@project_listings = File.open("/Users/joshthedudeoflife/email_scheduler_svc/lib/api_models/project_listings.html", "r+")
			@the_project_listings = @project_listings.read.to_s
			 logger.info "where the prefhash begins"
			 @prefhash = prefhash
			 logger.info @prefhash.inspect
			 logger.info prefhash["_id"]
			 logger.info "this is prefhash"
			 @email_address_for_preference = email_address_for_preference
			 @matching_projects = get_matching_projects
			 if !@matching_projects.nil? 
				generate_email
				@project_notifications = ProjectNotifications.new(@prefhash["_id"])
				@email_send = email_send
			else
				puts "this is nil"
			end

		end

		def email_address_for_preference
		 email = "jachou4291983@gmail.com"
		end
	
#get filter to work, emails, handle not to send anything if there are no matching projects, coming up with script to be able to install all these things on another box.
#set up with a VM like virtual box, install ubuntu server (only server), install ES in there, script to take scheduler server to test environment VM,
#these are all the files I need to copy across the my VM
#setup vagrant, (will pull down virtual machines with Ubuntu server setup and running)
#fix rspec test
#create another index in ES, the data will be, one attribute will be email, the other "belongs_to" is going to point to ES generated (its an elastic search ID, this is the specific record in elastic search that I belong to), might have to update user_preferences to include a "belongs_to" field will be a string, make sure to add to mappings in user preferences (the special stuff we had to add into user_preferences)
#this new index will just have email address, ES is going to sign an ID automatically, Userprefs will have to include belongs_to field that contains the ID
#call index profiles will be the first thing to exist, unless you have a profile you cant create any preferences, then Userpreferences is created after, cant exist without profile.
		def get_matching_projects
			query = {
									query: 
									{
									 term: {
									 	status: "active"
									 }
									},
									filter: { 
										and: [
											{
												terms: {
													state: @prefhash["states"]
												}
											},
											{
												terms:{
													assetclass: @prefhash["assetclass"]
												}
											},
												{
												terms:{
													locationclass: @prefhash["locationclass"]
												}
											},
												{
												terms:{
													propertytype: @prefhash["propertytype"]
												}
											}
											 # range: {
            #            investments: {from: @prefhash["minimum"], to: @prefhash["maximum"] }
            #          }
											
										]
									}
							 }
			logger.info query
			logger.info "this is the query"
			res = PROJECTS_INDEX.type(:project).search(query)
			logger.info res
			logger.info "matching_projects"
			res.documents
			logger.info res.documents
			logger.info "res docs"
			res.documents
		end

		def email_send
			logger.info "string contents"
			logger.info @stringcontents
			message_params = {:from    => 'josh.chou@testmail.consected.net',
                  :to      => @email_address_for_preference,
                  :subject => @email_subject,
                  :html    => @stringcontents
                }
			logger.info "message_params"
      logger.info message_params.inspect
      MG_CLIENT.send_message "testmail.consected.net", message_params
		end


		def generate_email
			logger.info @matching_projects
			logger.info "generate email matching_projects"
			@email_text = ""
			template = @the_project_listings
			#regular expressions {.+} the . always means match anycharacter and the + always means at least once, the ? means to go sequentially
			tokens = template.scan(/\{.+?\}/)
			#tokens = ["name", "value", "assetclass"]
			myprojectsnew = @matching_projects.each do |project|
											text = template.dup
											tokens.each do |key|
												key.gsub!(/\{|\}/, "")
												value = project[key]
												puts "#{key} #{value}"
												value ||= "(no value)"
												text.gsub!("{#{key.to_s}}",value.to_s)
											end
											@email_text << text
										end
			@stringcontents = @contents.gsub("aaaaa", @email_text)
			@email_subject = "Your REPSE daily preferences"
		end
	end
end