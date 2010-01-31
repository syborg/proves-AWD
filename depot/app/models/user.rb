class User < ActiveRecord::Base

  validates_presence_of :name
  validates_uniqueness_of :name
  
  attr_accessor :password_confirmation
  
  validates_confirmation_of :password
  
  validate  :password_non_blank

  attr_reader :password
  #def password
  #  @password
  #end
  
  #en comptes d'attr_writer fem algo mes potent
  def password=(pwd)
    @password=pwd
    return if pwd.blank?
    create_new_salt
    #self.hashed_password=User.encrypted_password(self.password, self.salt)
    #alternativament ...
    self.hashed_password=self.class.encrypted_password(self.password, self.salt)
  end
  
  def self.authenticate(name, password)
    #user=self.find_by_name(name)
    #alternativament: ens podem estalviar el self. perque els metodes no
    #enganxats a un xxxx. s'envien sempre a self, que en aquest cas es la classe
    user=find_by_name(name)
    if user
      expected_password=encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        user = nil
      end
    end
    user
  end

  #callback despres de delete. 
  #Aqui s'evita esborrar el darrer usuari (i en aquest cas administrador que pot modificar dades) generant una exception (raise) que fa que es faci un rollback de la transaccio automàticament
  def after_destroy 
    if User.count.zero?
      raise "Can't delete last user"
    end   
  end

  private
  
  def password_non_blank
    errors.add(:password, "Missing password") if hashed_password.blank?
  end
  
  def self.encrypted_password(password, salt)
    string_to_hash = password + "wibble" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end
  
  def create_new_salt
    #els metodes sense estar enganxats a xxx. s'envien sempre a self. En aquest cas
    #pero, al ser un metode'=' Ruby ho confondria amb una assignacio a una variable local
    #pel que s'explicita que es tracta d'un metode'
    self.salt=self.object_id.to_s + rand.to_s
  end
  
end
