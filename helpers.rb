require_relative 'geocoder_wrapper'
require_relative 'google_directions_wrapper'

def update_record_stores
  if Store.count > 0 && Store.last.created_at > (Time.now - 1.day)
    puts "Not getting stores - too soon"
  else
    puts "Getting updated list of record stores"
    n = 0
    raw_store_data = Typhoeus.get "http://www.recordshops.org/php/ajax/getshops.php"
    raw_store_data = JSON.parse(raw_store_data.body)
    raw_store_data['shops'].each do |shop|
      store = Store.find_by_id(shop['id'])
      next if store
      n += 1
      shop['location'] = [shop['lat'].to_f, shop['lng'].to_f]
      store = Store.create(shop)
    end
    puts "Updated stores. Added #{n} new stores."
  end
end
