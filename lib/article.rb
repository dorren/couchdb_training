class Article < CouchRest::Model::Base
  use_database COUCH_DB

  property :title, String
  property :content, String
  property :published_at, Time
  property :authors, [String]
  property :category             # tech, business, politics, sports, etc.
  property :ratings, Integer      # 1-5, 5 is the highest

  property :tags,   [String]     # specific keywords, like iphone, lady gaga, etc
  property :images, [String]
  property :videos, [String]

  # array of hash
  #   [{'name' => 'fan1', 'comment' => 'I like it',     'created_at' => Time.now},
  #    {'name' => 'fan2', 'comment' => 'I like it too', 'created_at' => Time.now},
  #    ...
  #   ]
  property :comments, [Hash]  
  timestamps!

  view_by :title
  view_by :category, :title
  view_by :category, :published_at


  view_by :category

  view_by :mcategory, 
    :map => %(
      function(doc){
        if (doc['type'] == 'Article' && doc['category'] != null){
          emit(doc.category, null);
        }
      }
    ),
    :reduce => "_count"


  view_by :cat_and_ratings, 
    :map => %(
      function(doc){
        if (doc['type'] == 'Article'){
          emit([doc.category, doc.ratings], null);
        }
      }
    ),
    :reduce => "_count"


  view_by :author,
    :map => %(
      function(doc){
        if (doc['type'] == 'Article' && doc['authors'] != null){
          doc.authors.forEach(function(item){
            emit(item, null);
          });
        }
      }
    ),
    :reduce => "_count"

  def authors_str
    authors.join(",")
  end
end
