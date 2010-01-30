module StoreHelper
  def hidden_div_if(condition, attributes ={}, &block)
    if condition
       attributes["style"]="display: none" 'afegeix un atribut nou als que ens arriben via parametre'
    end
    content_tag("div", attributes, &block)
  end
end
