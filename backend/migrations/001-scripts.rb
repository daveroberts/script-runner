require './app/database/database.rb'

module DBMigrations
  # Adds scripts table to DB
  class Scripts
    def self.up
      db = DB.raw_connection
      sql = "CREATE TABLE `scripts` (
        `auto_id` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
        `id` VARCHAR(255) NOT NULL,
        `name` VARCHAR(255) NOT NULL,
        `description` VARCHAR(255),
        `code` TEXT,
        `active` BOOLEAN NOT NULL,
        `created_at` DATETIME NOT NULL,
        UNIQUE KEY `id` (`id`),
        INDEX `id_index` (`id`),
        UNIQUE KEY `name` (`name`),
        INDEX `name_index` (`name`),
        INDEX `active_index` (`active`),
        INDEX `created_at_index` (`created_at`)
      )"
      db.query(sql)
      sql = "CREATE TABLE `script_runs` (
        `auto_id` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
        `id` VARCHAR(255) NOT NULL,
        `script_id` VARCHAR(255),
        `trigger_id` VARCHAR(255),
        `queue_name` VARCHAR(255),
        `queue_item_key` VARCHAR(255),
        `input` TEXT,
        `code` TEXT,
        `output` TEXT,
        `error` TEXT,
        `run_at` DATETIME NOT NULL,
        UNIQUE KEY `id` (`id`),
        INDEX `id_index` (`id`),
        INDEX `trigger_id_index` (`trigger_id`),
        INDEX `script_id_index` (`script_id`),
        INDEX `queue_index` (`queue_name`, `queue_item_key`),
        INDEX `run_at_index` (`run_at`)
      )"
      db.query(sql)
      sql = "CREATE TABLE `triggers` (
        `auto_id` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
        `id` VARCHAR(255) NOT NULL,
        `script_id` VARCHAR(255) NOT NULL,
        `type` VARCHAR(255) NOT NULL,
        `active` BOOLEAN NOT NULL,
        `every` INTEGER,
        `queue_name` VARCHAR(255),
        `created_at` DATETIME NOT NULL,
        UNIQUE KEY `id` (`id`),
        INDEX `id_index` (`id`),
        INDEX `type_index` (`type`),
        INDEX `active_index` (`active`),
        INDEX `queue_name_index` (`queue_name`),
        INDEX `created_at_index` (`created_at`)
      )"
      db.query(sql)
      sql = "CREATE TABLE `queue_items` (
        `auto_id` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
        `id` VARCHAR(255) NOT NULL,
        `queue_name` VARCHAR(255) NOT NULL,
        `state` VARCHAR(255) NOT NULL,
        `item_key` VARCHAR(255) NOT NULL,
        `item` TEXT NOT NULL,
        `created_at` DATETIME NOT NULL,
        INDEX `id_index` (`id`),
        INDEX `queue_name_index` (`queue_name`),
        INDEX `item_key_index` (`item_key`, `queue_name`),
        UNIQUE KEY `item_key` (`item_key`, `queue_name`),
        INDEX `queue_name_state_index` (`queue_name`, `state`),
        INDEX `queue_name_created_at_index` (`queue_name`, `created_at`)
      )"
      db.query(sql)
    end
  end
end
