require './app/lib/config.rb'
require './app/database/database.rb'
require './app/database/dbseed.rb'
Dir['./migrations/*.rb'].each { |file| require file }

# Runs code in migrations/ directory to alter database schema
class DBMigrate
  def self.get_migrations_from_db(create_if_empty = false)
    sql = 'SELECT * FROM `migrations`'
    begin
      results = nil
      DB.use do |db|
        results = db.query(sql)
        return results.to_a
      end
    rescue Mysql2::Error => e
      raise e if !e.message.include? "doesn't exist"
      raise Exception, "Migrations table doesn't exist and create_if_empty was false" if !create_if_empty
      sql = 'CREATE TABLE `migrations` (name VARCHAR(255), date_run DATETIME)'
      DB.use do |db|
        db.query(sql)
      end
      return []
    end
  end

  def self.migrations_from_filesystem
    migrations = []
    Dir['./migrations/*.rb'].each do |file|
      filename = File.basename file, '.rb'
      number = filename.split('-')[0].to_i
      classname = filename.split('-')[1].split('_').map{ |p| p.capitalize }.join()
      migrations.push(name: filename, number: number, classname: classname)
    end
    return migrations.sort_by { |m| m[:number] }
  end

  def self.migrate(create_if_empty = false)
    db_migrations = self.get_migrations_from_db(create_if_empty)
    self.migrations_from_filesystem.each do |migration|
      next if db_migrations.find { |m| m[:name] == migration[:name] }
      migration_class = Object.const_get("DBMigrations::#{migration[:classname]}")
      puts "Migrating #{migration[:name]}"
      migration_class.up
      statement = nil
      DB.use do |db|
        statement = db.prepare('INSERT INTO `migrations` (name, date_run) VALUES (?, ?)')
        statement.execute(migration[:name], DateTime.now)
      end
    end
    puts 'Finished migrations'
  end

  def self.drop
    if ENV['APP_ENV'] != 'test' && ENV['APP_ENV'] != 'development'
      msg = 'Can only drop a development or test database'
      $stderr.puts msg
      raise Exception, msg
    end
    config = Config.get[:database]
    statement = nil
    result = nil
    DB.use do |db|
      statement = db.prepare('SELECT table_name FROM information_schema.tables WHERE table_schema=?')
      result = statement.execute(config[:database])
    end
    tables = result.to_a.map { |r| r[:table_name] }
    tables.each do |table|
      sql = "DROP TABLE #{table}"
      puts "Dropping table #{table}"
      DB.use do |db|
        db.query(sql)
      end
    end
    puts 'DB dropped'
  end

  def self.refresh
    self.drop
    self.migrate(true)
    DBSeed.seed
  end
end
