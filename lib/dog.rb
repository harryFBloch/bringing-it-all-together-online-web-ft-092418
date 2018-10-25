class Dog
attr_accessor :name, :breed, :id

  def initialize(name: nil, breed: nil, id:  nil)
    self.name = name 
    self.breed = breed
    self.id = id
  end
  
  def self.create_table
    DB[:conn].execute("CREATE TABLE dogs (id PRIMARY KEY, name TEXT, breed TEXT)")
  end
  
  def self.drop_table
    DB[:conn].execute("DROP TABLE dogs")
  end
  
  def save
    if self.id 
      
    else 
      DB[:conn].execute("INSERT INTO dogs (name, breed) VALUES (?,?)",self.name,self.breed)
      #binding.pry
      self.id = DB[:conn].execute("SELECT id FROM dogs WHERE name = ?",self.name)[0][0]
    end
    self
  end
  
  def self.create(hash)
    binding.pry
    dog = Dog.new()
    hash.each {|key, value|
      dog.send("#{key}=",value)
    }
    dog.save
  end
  
  def self.find_by_id(id)
    DB[:conn].results_as_hash = true
    info = DB[:conn].execute(
      "SELECT * FROM dogs WHERE id = ?",id).first
    #binding.pry
    dog = Dog.new(name: info["name"], breed: info["breed"], id: info["id"])
    dog.save
  end
  
  def self.find_or_create_by(hash)
    
    dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?",hash[:name], hash[:breed])
    #binding.pry
    if !dog.empty?
      #binding.pry
      self.find_by_id(dog.first["id"])
    else
      #binding.pry
      dog = Dog.create(hash)
    end
  end
  
end