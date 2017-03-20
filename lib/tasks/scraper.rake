namespace :scraper do
  desc "Fetch Ebay posts from 3taps"
  task scrape: :environment do
    require 'open-uri'
    require 'json'

    polling_url = 'http://polling.3taps.com/poll'

    # specify request params
    params = {
      'anchor' => Anchor.first.value,
      'location.zipcode' => 'USA-07450',
      retvals: "heading,body,price,location,external_url,timestamp,images,annotations"
    }

    #prepare api request
    uri = URI.parse(polling_url)
    uri.query = URI.encode_www_form(params)

    # get results
    result = JSON.parse(open(uri).read)

    # print results
    # puts JSON.pretty_generate result["postings"]

    # store in db
    result["postings"].each do |posting|

      # create new user
      @post = Post.new
      @post.heading = posting["heading"]
      @post.body = posting["heading"]
      @post.price = posting["annotations"]["price"]
      @post.city = Location.find_by(code: posting["location"]["city"]).try(:name)
      @post.external_url = posting["external_url"]
      @post.timestamp = posting["timestamp"]
      @post.listingtype = posting["annotations"]["listingtype"] if posting["annotations"]["listingtype"].present?
      @post.address = posting["annotations"]["address"] if posting["annotations"]["address"].present?
      @post.source_account = posting["annotations"]["source_account"] if posting["annotations"]["source_account"].present?
      # save user
      @post.save

      # grab images

      posting["images"].each do |image|
        @image = Image.new
        @image.url = image["full"]
        @image.post_id = @post.id
        @image.save
      end
    end
  end

  desc "Delete all posts"
  task destroy_all_posts: :environment do
    Post.destroy_all
  end

  desc "Get all neighborhoods"
  task scrape_neighborhoods: :environment do
    require 'open-uri'
    require 'json'

    location_url = 'http://reference.3taps.com/locations'

    # specify request params
    params = {
      level: "locality"
    }

    #prepare api request
    uri = URI.parse(location_url)
    uri.query = URI.encode_www_form(params)

    # get results
    result = JSON.parse(open(uri).read)

    result["locations"].each do |location|
      @location = Location.new
      @location.code = location["code"]
      @location.name = location["short_name"]
      @location.save
    end
  end
  desc "Remove old posts"
  task discard_old_data: :environment do
    Post.all.each do |post|
      if post.created_at < 6.hours.ago
        post.destroy
      end
    end
  end
end
