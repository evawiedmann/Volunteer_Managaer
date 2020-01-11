class Volunteer
  # attr_reader :id
  attr_accessor :name, :id, :project_id

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
    @project_id = attributes.fetch(:project_id)
  end

  def ==(volunteer_to_compare)
    if volunteer_to_compare != nil
      (self.name() == volunteer_to_compare.name()) && (self.id() == volunteer_to_compare.id())
    else
      false
    end
  end

  def self.all
    returned_volunteers = DB.exec("SELECT * FROM volunteers;")
    volunteers = []
    returned_volunteers.each() do |volunteer|
      name = volunteer.fetch("name")
      id = volunteer.fetch("id").to_i
      volunteers.push(Volunteer.new({:name => name, :id => id}))
    end
    volunteers
  end

  def save
    result = DB.exec("INSERT INTO volunteers (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def delete
    DB.exec("DELETE FROM projects_volunteers WHERE volunteer_id = #{@id};")
    DB.exec("DELETE FROM volunteers WHERE id = #{@id};")
  end

  def self.clear
    DB.exec("DELETE FROM volunteers *;")
  end

  def projects
    projects = []
    results = DB.exec("SELECT project_id FROM projects_volunteers WHERE volunteer_id = #{@id};")
    results.each() do |result|
      project_id = result.fetch("project_id").to_i()
      project = DB.exec("SELECT * FROM projects WHERE id = #{project_id};")
      name = project.first().fetch("name")
      year = project.first().fetch("year").to_i
      genre = project.first().fetch("genre")
      volunteer = project.first().fetch("volunteer")
      status = project.first().fetch("status")
      cost= project.first().fetch("cost").to_f
      projects.push(Project.new({:name => name, :id => project_id, :year => year, :genre => genre, :volunteer => volunteer, :status => status, :cost => cost}))
    end
    projects
  end
end
