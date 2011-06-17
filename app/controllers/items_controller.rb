class ItemsController < ApplicationController

  hobo_model_controller

  auto_actions :all

  # Get current item tree for api
  def apiindex
    #TODO authentication
    tree = Item.tree
    doc = Hpricot(tree.to_xml)
    #Patch up the xml to look better
    doc.root.name = "items"
    doc.search('//record').each{|node| node.name = 'item'}
    doc.search('//[@type]').each{|node| node.remove_attribute 'type'}
    render :text => doc.to_html
  end
end
