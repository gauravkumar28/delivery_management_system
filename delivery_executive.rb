require 'haversine'

class DeliveryExecutive
attr_accessor :id, :current_location_lat, :current_location_lng, :last_order_delivered_time


  def distance order
    Haversine.distance(current_location_lat, current_location_lat, order.restaurent_location_lat, order.restaurent_location_lng).to_kilometers
  end
end