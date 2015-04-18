module Mongoid
  DATABASES = {}

  def default_database
    # Mongoid.default_session.options[:database]
    # da forma acima quando da override retorna a base de dados
    Mongoid.sessions["default"]["database"]
  end

  def current_database
    DATABASES[Thread.current.object_id] || default_database
  end

  def set_current_database(database)
    DATABASES[Thread.current.object_id] = database
  end

  def destroy_current_database
    DATABASES.delete(Thread.current.object_id)
  end
end