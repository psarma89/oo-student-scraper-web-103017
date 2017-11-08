require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = Nokogiri::HTML(open(index_url))
    students = html.css(".student-card")
    students.collect do |student|
      {
        :name => student.css(".student-name").text,
        :location => student.css(".student-location").text,
        :profile_url => student.css("a").attribute("href").value
      }
    end
    # binding.pry
  end

  def self.scrape_profile_page(profile_url)
    html = Nokogiri::HTML(open(profile_url))
    # html.css(".social-icon-container a").attribute("href").value
    profile_hash = {
      # :twitter=> "",
      # :linkedin=> "",
      # :github=> "",
      # :blog=> "",
      :profile_quote=> html.css(".profile-quote").text,
      :bio=> html.css(".description-holder p").text
    }

    html.css(".social-icon-container a").each do |social|
      social_url = social.attribute("href").value
      if social_url.include?("twitter")
        profile_hash[:twitter] = social_url
      elsif social_url.include?("linkedin")
        profile_hash[:linkedin] = social_url
      elsif social_url.include?("github")
        profile_hash[:github] = social_url
      else
        profile_hash[:blog] = social_url
      end
    end

    profile_hash
  end

end
