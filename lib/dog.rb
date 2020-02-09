class Dog
attr_accessor :name, :breed, :id

def initialize(id:nil, name:, breed:)
  @name = name
  @breed = breed
  @id = id
end

def self.create_table
  DB[:conn].execute("CREATE TABLE IF NOT EXISTS dogs (id INTEGER PRIMARY KEY, name TEXT, breed TEXT)")
end

def self.drop_table
  DB[:conn].execute("DROP TABLE dogs")
end

def save #for inserting data
  if self.id
    self.update
    self
  else
   sql = <<-SQL
    INSERT INTO dogs (name, breed)
    VALUES (?, ?)
   SQL
   DB[:conn].execute(sql, self.name, self.breed)
   @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
   self
  end
end

def update
  sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?"
  DB[:conn].execute(sql, self.name, self.breed, self.id)
end

def self.new_from_db(row)
  self.new(id: row[0], name: row[1], breed: row[2])
end

def self.find_by_name(name)

end

def self.create(id:nil, name:, breed:)
  dog = self.new(id:id, name:name, breed:breed)
  dog.save
  dog
end

def self.find_by_id
  sql = <<-SQL
    SELECT * FROM dogs
    WHERE id = ?
    LIMIT 1
  SQL
  DB[:conn].execute(sql, self.id)[0]
end

end
