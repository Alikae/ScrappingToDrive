require_relative "scrap_mairies.rb"
require "google_drive"

  session = GoogleDrive::Session.from_config("config.json")
  ws = session.spreadsheet_by_key("1FM8cyfajHu1q68Kh2JWnL3xi1ThQ7pypfdQ1rWhQuwQ").worksheets[0]
  database = perform

def go_through_each_element_of_hash(hash, ws, nd)
  z = 3
  hash.each { |x,y|
    ws[z, 1+nd] = x
    ws[z, 2+nd] = y
    z += 1
  }
  ws.save
end

def performing(database, ws)
  nd = 0
  database.each {|dep_name, city_names_mails|
    ws[1, nd+1] = dep_name
    go_through_each_element_of_hash(city_names_mails, ws, nd)
    nd += 3
  }
end

performing(database, ws)

