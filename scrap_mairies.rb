require "open-uri"
require "nokogiri"

def import_department_urls()
  urls = Hash.new
  doc = Nokogiri::HTML(open("http://annuaire-des-mairies.com/"))
  doc.css('area').each { |site|                               #Pour chaque departement on stocke le nom et l'URL
    if site["href"] != "#"
      dep_url = "http://annuaire-des-mairies.com/" + site["href"]
      dep_name = site["href"][0...-5]
      urls[dep_name] = dep_url
    end
  }
  return urls
end

def import_city_urls(url)
  names_urls = Hash.new
  doc = Nokogiri::HTML(open(url))
  doc.css('p a.lientxt').each { |link|                         #Idem pour chaque ville
    city_url = "http://annuaire-des-mairies.com" + link["href"][1..-1]
    city_name = link["href"][5..-6]
    names_urls[city_name] = city_url
  }
  return names_urls
end

def get_mail(url)
  mail = "Pas de mail"
  begin
    doc = Nokogiri::HTML(open(url))                             #Et on recupere les mails
    doc.css('tr/td/p/font').each { |txt|
      if /@/ =~ txt.text
        mail = txt.text
      end
    }
  rescue StandardError => error
  mail = "error: #{error.class}"
  end
  return mail
end

def perform()
  prc = 0 #pourcentage
  databuffer = Hash.new
  data_final = Hash.new
  dep_names_urls = import_department_urls()
  dep_names_urls.each { |dep_name, dep_url|
    databuffer.clear
    city_names_url = import_city_urls(dep_url)
    city_names_url.each { |city_name, city_url|
      city_mail = get_mail(city_url)
      databuffer[city_name] = city_mail
      puts "importing(#{prc}%) #{dep_name}:  " + city_mail
    }
    data_final[dep_name] = databuffer
    prc += 1
  }
  return data_final
end
