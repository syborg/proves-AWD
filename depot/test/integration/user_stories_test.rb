require 'test_helper'

class UserStoriesTest < ActionController::IntegrationTest
  fixtures :products

  # Una sessio d'usuari qualsevol
  test "buying a product" do
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:ruby_book)
    
    #L'usuari va a la pagina index'
    get "store/index"
    assert_response :success
    assert_template "index"
    
    #Selecciona un producte introduint-lo al carret
    xml_http_request :put, "/store/add_to_cart", :id => ruby_book.id
    assert_response :success
    
    cart = session[:cart]
    assert_equal 1, cart.items.size
    assert_equal ruby_book, cart.items[0].product

    #Aleshores inicia la compra (checkout)
    post "store/checkout"
    assert_response :success
    assert_template "checkout"
    
    #Omple les dades de compra
    post_via_redirect "/store/save_order", 
                      :order=> { :name => "Marcel Massana",
                                 :address => "Green Suspire, 3",
                                 :email => "xaxaupua@gmail.com",
                                 :pay_type => "check" }
    assert_response :success
    assert_template "index"
    assert_equal 0, session[:cart].items.size
    
    #Comprovem si s'ha creat la comanda a la BBDD
    orders=Order.find(:all)
    assert_equal 1, orders.size
    
    order=orders[0]
    assert_equal "Marcel Massana", order.name
    assert_equal "Green Suspire, 3", order.address
    assert_equal "xaxaupua@gmail.com", order.email    
    assert_equal "check", order.pay_type
    
    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product
        
  end
end
