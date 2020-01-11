class Project

  attr_accessor :name, :id

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id).to_i
  end

  def self.all()
    returned_projects = DB.exec("SELECT * FROM projects;")
    projects = []
    returned_projects.each() do |project|
      name = project.fetch("name")
      id = project.fetch("id").to_i
      year = project.fetch("year").to_i
      genre = project.fetch("genre")
      volunteer = project.fetch("volunteer")
      status = project.fetch("status")
      cost = project.fetch("cost").to_f
      projects.push(Project.new({:name => name, :id => id, :year => year, :genre => genre, :volunteer => volunteer, :status => status, :cost => cost}))
    end
    projects
  end

  def self.random
    returned_projects = DB.exec("SELECT * FROM projects ORDER BY RANDOM() LIMIT 1;")
    projects = []
    returned_projects.each() do |project|
      name = project.fetch("name")
      id = project.fetch("id").to_i
      projects.push(Project.new({:name => name, :id => id, :year => year, :genre => genre, :volunteer => volunteer, :status => status, :cost => cost}))
    end
    projects
  end

  def save
    result = DB.exec("INSERT INTO projects (name, , genre, volunteer, status) VALUES ('#{@name}', '#{@year}', '#{@genre}', '#{@volunteer}', '#{@status}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def ==(project_to_compare)
    if project_to_compare != nil
      self.name() == project_to_compare.name()
    else
      false
    end
  end

  def self.clear
    DB.exec("DELETE FROM projects *;")
  end

  def self.find(id)
    project = DB.exec("SELECT * FROM projects WHERE id = #{id};").first
    if project
      name = project.fetch("name")
      id = project.fetch("id").to_i
      Project.new({:name => name, :id => id, :year => year, :genre => genre, :volunteer => volunteer, :status => status, :cost => cost})
    else
      nil
    end
  end

  def self.search_name(name)
    projects = self.all
    projects.select { |project| /#{name}/i.match? project.name }
  end

  def update(name)
    @name = name
    DB.exec("UPDATE projects SET name = '#{@name}' WHERE id = #{id};")
  end

  def delete()
    DB.exec("DELETE FROM projects WHERE id = #{@id};")
    DB.exec("DELETE FROM songs WHERE project_id = #{@id};")
  end

  def volunteer
    Volunteer.find_by_project(self.id)
  end

end
