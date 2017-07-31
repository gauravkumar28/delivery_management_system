class Order

attr_accessor :id, :ordered_time, :restaurent_location_lat, :restaurent_location_lng

  def city
    @city ||= find_city(restaurent_location_lat, restaurent_location_lng)
  end
  
end