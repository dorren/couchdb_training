require 'rake'
require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'
require 'yaml'
require 'couchdb_training'

# fetch cnn content and return as array of hash
def get_cnn
  articles = []

  urls = {'politics' => 'http://rss.cnn.com/rss/cnn_allpolitics.rss',
          'tech' => 'http://rss.cnn.com/rss/cnn_tech.rss',
          'business' => 'http://rss.cnn.com/rss/money_latest.rss',
          'travel' => 'http://rss.cnn.com/rss/cnn_travel.rss',
          'entertainment' => 'http://rss.cnn.com/rss/cnn_showbiz.rss',
          'health' => 'http://rss.cnn.com/rss/cnn_health.rss',
          'sports' => 'http://rss.cnn.com/rss/si_topstories.rss'
          }

  authors = %w(Dorren Serkan Chad Randall Matt Decarlo Rachel Depa)
  urls.each do |cat, url|
    content = open(url).read
    rss = RSS::Parser.parse(content, false)

    rss.items.each do |item|
      article = {:id => item.title.downcase.gsub(/\W+/, '-'),
                 :title => item.title, 
                 :content => item.description,
                 :category => cat,
                 :published_at => item.pubDate,
                 :ratings => rand(5) + 1,
                 :authors => []}

      article[:authors] << authors[rand(authors.size)]

      2.times do |i|
        num = rand(50)
        article[:authors] << authors[num] if num < authors.size
      end

      articles << article
    end
  end  

  articles
end

def write_yaml(content)
  path = File.join(File.dirname(__FILE__), 'fixtures.yml')
  f = File.open(path, 'w')
  f.write content
  f.close
end

namespace :fixtures do
  desc "download from cnn"
  task :download do
    write_yaml(get_cnn.to_yaml)
  end

  desc "setup fixture db"
  task :setup => :download do
    COUCH_DB.recreate!

    path = File.join(File.dirname(__FILE__), 'fixtures.yml')
    arr = YAML::load_file(path)

    arr.each do |attr|
      model = Article.new(attr)
      if !Article.find(attr[:id])
        model.save!
      end
    end
  end
end
