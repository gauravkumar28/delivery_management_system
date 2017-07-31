class AutoAssignmentRule < ActiveRecord::Base
  attr_accessor :id, :locality_id, :rules, :status

  module Rules
  	FIRST_MILE = 'first_mile'
  	DE_WAITING_TIME = 'de_waiting_time'
  	ORDER_DELAY_TIME = 'order_delay_time'
  end

  def self.get_rules locality_id
  	AutoAssignmentRule.find(AutoAssignmentRule).rules
  end
end