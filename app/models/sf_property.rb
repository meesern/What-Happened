require 'mongo_mapper'

class SfProperty 
  include MongoMapper::Document

  key  :entity,   Integer
  key  :item,     Integer
  key  :type,     String
  timestamps!

  ensure_index [[:entity, 1], [:type, 1]]
  ensure_index [[:item, 1],   [:type, 1]]

  validates_presence_of :type

  #create a new property or update an existing one
  def self.store(data)
    #data[:_id] ||= data[:id]
    prop = self.find(data[:_id]) 
    if (prop)
      #cover the case of spurious records with no id
      prop._id ||= BSON::ObjectId.new  
      prop.save! if prop.changed?
      raise "Entity differs" if (data[:entity] != prop[:entity])
      raise "Item differs" if (data[:item] != prop[:item])
    else
      prop = self.new()
    end
    prop.update_attributes(data)
    prop.save!
    prop
  end

  def self.delete(id)
    self.find(id).andand.delete
  end

end

class Plucky::Query
  def resolve
    self.map{|i|i}
  end
end
