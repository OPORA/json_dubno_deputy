require 'open-uri'
require_relative './people'
require 'json'




class ScrapeMp
  def parser
    #DataMapper.auto_upgrade!
    json = File.open('./deputies.json')
    file = open(json).read
    mps_hash = JSON.parse(file)
    mps_hash.map do |mp|
      scrape_mp(mp)
    end
    # create_mer()
  end
  def create_mer
    #TODO create mer Sadovoy
    # names = %w{Садовий Андрій Іванович}
    # People.first_or_create(
    #     first_name: names[1],
    #     middle_name: names[2],
    #     last_name: names[0],
    #     full_name: names.join(' '),
    #     deputy_id: 1111,
    #     okrug: nil,
    #     photo_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/40/AndriiSadovyi.JPG/255px-AndriiSadovyi.JPG",
    #     faction: "Самопоміч",
    #     end_date:  nil,
    #     created_at: "9999-12-31",
    #     updated_at: "9999-12-31"
    # )
  end
  def scrape_mp(mp)
    if mp["endDate"] == "20.10.2020"
      date_end = nil
    else
      date_end = Date.parse(mp["endDate"],'%d.%m.%Y')
    end

    people = People.first(
        deputy_id: mp["id"],
        first_name: mp["firstName"],
        middle_name: mp["fathersName"],
        last_name: mp["lastName"],
        full_name: mp["lastName"] + " " +  mp["firstName"] + " " + mp["fathersName"],
        start_date: mp["startDate"],
        okrug: nil,
        photo_url: mp["photoLink"],
        faction: mp["faction"]
    )

    unless people.nil?
     people.update(end_date:  date_end,  updated_at: Time.now)
     else
       People.create(
           first_name: mp["firstName"],
           middle_name: mp["fathersName"],
           last_name: mp["lastName"],
           full_name: mp["lastName"] + " " +  mp["firstName"] + " " + mp["fathersName"],
           deputy_id: mp["id"],
           okrug: nil,
           photo_url: mp["photoLink"],
           faction: mp["faction"],
           start_date: mp["startDate"],
           end_date:  date_end,
           created_at: Time.now,
           updated_at: Time.now
       )
    end
  end
end
unless ENV['RACK_ENV']
  ScrapeMp.new
end


