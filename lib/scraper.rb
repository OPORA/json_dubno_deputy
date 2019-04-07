require 'open-uri'
require_relative './people'
require 'csv'




class ScrapeMp
  def parser
    #DataMapper.auto_upgrade!
    #
     csv_file = open('https://ckan.dubno-adm.rv.ua/dataset/7eb66fa9-33de-4d73-b5a7-df6846823f98/resource/49c25673-4422-4bd6-92e4-b458a0e40818/download/depytatu_2018.csv')
     csvmp = CSV.read(csv_file)
     csvmp.shift
     csvmp.each do |mp|
       p mp
       scrape_mp(mp)
     end

    create_mer()
     create_mps_1
     create_mps_2
     create_mps_3
     create_mps_4
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
  def create_mps_1
    names = %w{Іванова Марія Петрівна}
    People.first_or_create(
        first_name: names[1],
        middle_name: names[2],
        last_name: names[0],
        full_name: names.join(' '),
        deputy_id: 35,
        okrug: 22,
        photo_url: "https://upload.wikimedia.org/wikipedia/en/e/ee/Unknown-person.gif",
        faction: "Українське об'єднання патріотів - УКРОП",
        start_date: "2015-10-20",
        end_date:  nil,
        created_at: "9999-12-31",
        updated_at: "9999-12-31"
    )
  end
  def create_mps_2
    names = %w{Момотюк Юрій Володимирович}
    People.first_or_create(
        first_name: names[1],
        middle_name: names[2],
        last_name: names[0],
        full_name: names.join(' '),
        deputy_id: 36,
        okrug: nil,
        photo_url: "https://upload.wikimedia.org/wikipedia/en/e/ee/Unknown-person.gif",
        faction: "Українське об'єднання патріотів - УКРОП",
        start_date: "2015-10-20",
        end_date:  nil,
        created_at: "9999-12-31",
        updated_at: "9999-12-31"
    )
  end
  def create_mps_3
    names = %w{Опалак Вадим Олександрович}
    People.first_or_create(
        first_name: names[1],
        middle_name: names[2],
        last_name: names[0],
        full_name: names.join(' '),
        deputy_id: 37,
        okrug: 21,
        photo_url: "https://upload.wikimedia.org/wikipedia/en/e/ee/Unknown-person.gif",
        faction: "Українське об'єднання патріотів - УКРОП",
        start_date: "2015-10-20",
        end_date:  nil,
        created_at: "9999-12-31",
        updated_at: "9999-12-31"
    )
  end
  def create_mps_4
    names = %w{Тимрук Віктор Станіславович}
    People.first_or_create(
        first_name: names[1],
        middle_name: names[2],
        last_name: names[0],
        full_name: names.join(' '),
        deputy_id: 38,
        okrug: 29,
        photo_url: "https://upload.wikimedia.org/wikipedia/en/e/ee/Unknown-person.gif",
        faction: "Українське об'єднання патріотів - УКРОП",
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
      people.update(end_date:  nil,  updated_at: Time.now)
     else
        People.create(
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
     end
  end
end
unless ENV['RACK_ENV']
  ScrapeMp.new
end


