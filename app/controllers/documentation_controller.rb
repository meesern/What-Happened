class DocumentationController < ApplicationController

  def api
    File.open(RAILS_ROOT+"/app/views/documentation/api.txt") do |file|
      #@markup = Maruku.new(RedCloth.new(file.read).to_html).to_html
      #@markup = RedCloth.new(WikiCreole.creole_parse(file.read)).to_html
      @markup = WikiCreole.creole_parse(file.read)
      #@markup = RedCloth.new(file.read).to_html
      render :doc
    end
  end

end
