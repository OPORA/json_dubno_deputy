require 'open-uri'
require_relative './people'
require 'csv'




class ScrapeMp
  def parser
    #DataMapper.auto_upgrade!
     csv_file = open('https://ckan.dubno-adm.rv.ua/dataset/7eb66fa9-33de-4d73-b5a7-df6846823f98/resource/49c25673-4422-4bd6-92e4-b458a0e40818/download/depytatu_2017_0_0.csv')
     csvmp = CSV.read(csv_file)
     csvmp.shift
     csvmp.each do |mp|
       scrape_mp(mp)
     end
    #mps_hash = JSON.parse(file)
    #mps_hash.map do |mp|
      #scrape_mp(mp)
    #end
    create_mer()
  end
  def create_mer
    #TODO create mer Sadovoy
     names = %w{Антонюк Василь Михайлович}
     People.first_or_create(
         first_name: names[1],
         middle_name: names[2],
         last_name: names[0],
         full_name: names.join(' '),
         deputy_id: 1111,
         okrug: nil,
         photo_url: "http://www.dubno-adm.rv.ua/UserFiles/Mer_2018_01.jpg",
         faction: "Позафракційний",
         start_date: "2015-10-20",
         end_date:  nil,
         created_at: "9999-12-31",
         updated_at: "9999-12-31"
    )
  end
  def scrape_mp(mp)

     deputy_id = mp[0]
     full_name = mp[1].strip
     if full_name == "МосійчукРуслан Андрійович"
       last_name =  "Мосійчук"
       first_name = "Руслан"
       middle_name = "Андрійович"
     else
       full_names = full_name.split(' ')
       last_name = full_names[0]
       first_name = full_names[1]
       middle_name = full_names[2]
     end
     faction = mp.last.nil? ? "Позафракційний" : mp.last.gsub(/Фракція/, "").strip

     people = People.first(
         deputy_id: deputy_id,
         first_name: first_name,
         middle_name: middle_name,
         last_name: last_name,
         full_name: last_name + " " + first_name  + " " +  middle_name,
         start_date: "2015-10-20",
         okrug: nil,
         photo_url: "https://upload.wikimedia.org/wikipedia/en/e/ee/Unknown-person.gif",
         faction: faction
     )

     unless people.nil?
      people.update(end_date:  date_end,  updated_at: Time.now)
     else
        People.create(

        )
     end
  end
end
unless ENV['RACK_ENV']
  ScrapeMp.new
end


