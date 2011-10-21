require 'couchrest_model'
require 'multi_json'

MultiJson.engine = :yajl

COUCH_SERVER  = CouchRest.new "http://admin:password@localhost:5984"
COUCH_DB = COUCH_SERVER.database!("couchdb_training")


require 'article'
