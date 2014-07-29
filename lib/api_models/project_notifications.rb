
module NotificationHandler
	class ProjectNotifications

	KB_LOG = "/Users/joshthedudeoflife/email_scheduler_svc/log/run.log"
	LOG = Logger.new(KB_LOG)
  LOG.info "Started running (#{self}): Log file: #{KB_LOG}"
  puts "Logging to #{KB_LOG}"
		
		def logger
  	LOG
  	end

  	def initialize projectsid
  		@projectsid = projectsid
			
  	end
		def method
			@projectsid = [@project_notifcations]
			if @projectsid.include? @project_notifcations
					puts "dont do anything"
			else 
				@email send
			end
		
			# if project_notifcations already has the projectid in the arrary
 		# 	dont do anything
	
			# else
			# send projects and place the projectid in the array
			# end
			# (make second recorod for list item 2)
			
			# if
			# the user prefs is modified since the last time we have sent a notification
			# get all projects that correspond with the new user prefs and send a new notification
			# else
			# dont do anything
			# end

			# if
			# the date sent has been 24 hours and the user prefs has not been modified and there are no new projects that matches the user prefs
			# dont do anything
			# else
			# send projects and place the projectid in the array
			# end
		end

	end
end
