require 'mongo_mapper'

class SfProperty 
  include MongoMapper::Document

  key  :entity,   Integer
  key  :item,     Integer
  key  :type,     String
  key  :property, Hash
  timestamps!

  ensure_index [[:entity, 1], [:type, 1]]
  ensure_index [[:item, 1],   [:type, 1]]

end
