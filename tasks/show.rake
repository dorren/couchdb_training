def show(query, models, attrs)
  puts "\n#{query}\n#{'-'*80}\n"
  models.each do |model|
    line = attrs.collect{|x| model.send(x)}.join(" -- ")
    puts line
  end
end

def show_reduced(query, resp)
  puts "\n#{query}\n#{'-'*80}\n"
  resp['rows'].each do |row|
    puts row.inspect
  end
end

  desc "by title"
  task '01-title' do
    query = %(Article.by_title)
    arr = Article.by_title :limit => 10
    # arr = Article.by_title :limit => 10, :skip => 3
    # arr = Article.by_title :limit => 10, :descending => true
    show query, arr, %w(title)
  end

  desc "by category"
  task '02-cat' do
    query = %(Article.by_category :key => 'business')
    arr = Article.by_category :key => 'business'
    show query, arr, %w(category title)
  end
  
  desc "by cat title"
  task '02-cat-title' do
    query = %(Article.by_category_and_title :startkey => ['business'], :endkey => ['business', {}])
    arr = Article.by_category_and_title :startkey => ['business'], :endkey => ['business', {}]
    show query, arr, %w(category title)
  end
  
  desc "by cat, title desc"
  task '03-cat-title-desc' do
    query = %(Article.by_category_and_title :startkey => ['business', {}], :endkey => ['business'], :descending => true )
    arr = Article.by_category_and_title :startkey => ['business', {}], :endkey => ['business'], :descending => true
    show query, arr, %w(category title)
  end

  
  desc "by cat, published_at desc"
  task '04-cat-date' do
    query = %(Article.by_category_and_published_at :startkey => ['business', {}], :endkey => ['business'], :descending => true )
    arr = Article.by_category_and_published_at :startkey => ['business', {}], :endkey => ['business'], :descending => true
    show query, arr, %w(category published_at title)
  end

  desc "by cat, ratings"
  task '04-cat-ratings' do
    query = %(Article.by_cat_and_ratings :startkey => ['business', {}], :endkey => ['business'], :descending => true )
    arr = Article.by_cat_and_ratings :startkey => ['business', {}], :endkey => ['business'], :descending => true
    show query, arr, %w(category ratings title)
  end

  desc "by cat, ratings"
  task '04-cat-ratings-min-3' do
    query = %(Article.by_cat_and_ratings :startkey => ['business', {}], :endkey => ['business', 3], :descending => true )
    arr = Article.by_cat_and_ratings :startkey => ['business', {}], :endkey => ['business', 3], :descending => true
    show query, arr, %w(category ratings title)
  end

  desc "by cat count"
  task '05-cat-count' do
    query = %(Article.by_mcategory :reduce => true, :group => true)
    resp = Article.by_mcategory :reduce => true, :group => true
    show_reduced query, resp
  end

  desc "by author"
  task '06-author' do
    query = %(Article.by_author :key => 'Dorren')
    arr = Article.by_author :key => 'Dorren'
    show query, arr, %w(authors_str category title)
  end

  desc "by author count"
  task '06-author-count' do
    query = %(Article.by_author :reduce => true, :group => true)
    resp = Article.by_author :reduce => true, :group => true
    show_reduced query, resp
  end
