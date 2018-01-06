class Dog
  attr_accessor :name,:breed,:id


  def initialize(name:, breed:, id: nil)
    @name = name
    @breed = breed
    @id = id
  end

  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS dogs(
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT
    )"
    DB[:conn].execute(sql)
  end
  def self.drop_table
    sql = "DROP table IF EXISTS dogs"
    DB[:conn].execute(sql)
  end
  def self.new_from_db(row)


    id = row[0]
    name = row[1]
    breed = row[2]
    new_dog = self.new(id:id,name:name,breed:breed)
    new_dog

  end

  def self.find_by_name(name)
    sql = "SELECT * FROM dogs WHERE name = ?"
    DB[:conn].execute(sql,name).map{|row| self.new_from_db(row)}

  end
  def update
    sql = "UPDATE dogs SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql,@name,@grade,@id)
  end

  def save
    if @id
      self.update
    else
      sql = "INSERT INTO dogs (name,breed) VALUES (?,?)"
      DB[:conn].execute(sql,@name,@breed)

      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
      self
    end
  end

  def self.create(hash)
    new_dog = self.new(hash)
    new_dog.save
  end

  def self.find_by_id(id)
    # binding.pry
    sql = "SELECT * FROM dogs WHERE id = ?"
    DB[:conn].execute(sql,id).map{|row| self.new_from_db(row)}[0]

  end


end
