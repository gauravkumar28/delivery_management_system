require 'yaml'
class AutoAssigner
  
  #ASSIGN DELIVERY EXECUTIVE FOR GIVEN ORDER

  # def initialize  
  #   @config = (YAML.load_file('config.yml')).to_properties
  # end

  # def config
  #   @config ||= (YAML.load_file('config.yml')).to_properties
  # end

  # def run order
  #   restaurent_location_lat = order.restaurent_location_lat
  #   restaurent_location_lng = order.restaurent_location_lng
  #   delivery_executives = DeliveryExecutive.list(restaurent_location_lat, restaurent_location_lng, config)
  # end

  def self.execute orders, delivery_executives
    assignment_info = []
    orders = orders.sort{|x, y| y.ordered_time <=> x.ordered_time} 
    orders.each do | order |
      order_locality_id = Locality.find_locality_id(order.restaurent_location_lat, order.restaurent_location_lng)
      assignment_rules = AutoAssignmentRule.get_rules(order_locality_id)
      de_id = find_executive(order, delivery_executives, rules)
      assignment_info << {"order_id" => order.id, "de_id" => de_id}
    end
    assignment_info
  end

  def self.find_executive(order, delivery_executives, rules)
    rules.each do |rule|
      delivery_executives = find_executive_first_mile(order, delivery_executives)  if rule.name == AutoAssignmentRule::Rules::FIRST_MILE
      delivery_executives = find_executive_de_wait_time(order, delivery_executives)  if rule.name == AutoAssignmentRule::Rules::DE_WAITING_TIME
      delivery_executives = find_executive_order_delay_time(order, delivery_executives)  if rule.name == AutoAssignmentRule::Rules::ORDER_DELAY_TIME
    end
    delivery_executives.first.id
  end

  def self.find_executive_first_mile(order, delivery_executives)
    delivery_executives.sort{ |x| x.distance(order)}
  end

  def self.find_executive_de_wait_time(order, delivery_executives)
    delivery_executives = delivery_executives.sort{|x, y| y.last_order_delivered_time <=> x.last_order_delivered_time}
  end

  def self.find_executive_order_delay_time(order, delivery_executives)

  end

end