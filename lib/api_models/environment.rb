require 'rufus-scheduler'
require 'stretcher'
require 'eventmachine'
require 'net/http'
require 'em-http-request'
require 'logger'
require 'mailgun'
require './lib/api_models/user_preferences'
module NotificationHandler
	KB_LOG = "/Users/joshthedudeoflife/email_scheduler_svc/log/run.log"
	LOG = Logger.new(KB_LOG)
  LOG.info "Started running (#{self}): Log file: #{KB_LOG}"
  puts "Logging to #{KB_LOG}"
	MG_CLIENT = Mailgun::Client.new "key-82v3h2hpckh-lpa48s9-y7a62hw6-4x9"
	ES_SERVER = Stretcher::Server.new('http://localhost:9200')
	index_name = 'keepbusy_user_preferences'
	ES_INDEX = ES_SERVER.index(index_name)
	other_index = 'matching_projects'
	PROJECTS_INDEX = ES_SERVER.index(other_index)
	def self.logger
  	LOG
  end
 	
 logger.info "this is start"


end