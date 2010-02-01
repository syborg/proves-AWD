class InfoController < ApplicationController
  def who_bought
    @product = Product.find(params[:id])
    @orders=@product.orders
    respond_to do |f|
      f.html
      f.xml { render :layout => false }
      f.atom {render :layout => false }
      f.json { render :layout => false, :json=>@product.to_json(:include=>:orders)}
    end
  end
  
  protected 
  
  def authorize
    
  end

end
