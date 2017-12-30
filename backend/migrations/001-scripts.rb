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
        `category` VARCHAR(255),
        `description` VARCHAR(255),
        `default_input` LONGTEXT,
        `extensions` TEXT,
        `code` LONGTEXT,
        `active` BOOLEAN NOT NULL,
        `every` INTEGER,
        `queue_name` VARCHAR(255),
        `http_endpoint` VARCHAR(255),
        `http_method` VARCHAR(255),
        `http_request_accept` VARCHAR(255),
        `http_response_content_type` VARCHAR(255),
        `created_at` DATETIME NOT NULL,
        UNIQUE KEY `id` (`id`),
        INDEX `id_index` (`id`),
        UNIQUE KEY `name` (`name`),
        INDEX `name_index` (`name`),
        INDEX `every_index` (`every`),
        INDEX `queue_name_index` (`queue_name`),
        INDEX `active_index` (`active`),
        INDEX `created_at_index` (`created_at`)
      )"
      db.query(sql)
      sql = "CREATE TABLE `script_runs` (
        `auto_id` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
        `id` VARCHAR(255) NOT NULL,
        `script_id` VARCHAR(255),
        `input` LONGBLOB,
        `extensions` TEXT,
        `code` LONGTEXT,
        `output` LONGBLOB,
        `error` TEXT,
        `run_at` DATETIME NOT NULL,
        UNIQUE KEY `id` (`id`),
        INDEX `id_index` (`id`),
        INDEX `script_id_index` (`script_id`),
        INDEX `run_at_index` (`run_at`)
      )"
      db.query(sql)
      sql = "CREATE TABLE `queue_items` (
        `auto_id` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
        `id` VARCHAR(255) NOT NULL,
        `queue_name` VARCHAR(255) NOT NULL,
        `state` VARCHAR(255) NOT NULL,
        `item` LONGBLOB NOT NULL,
        `summary` VARCHAR(2048) NOT NULL,
        `image_id` VARCHAR(255),
        `locked_at` DATETIME NOT NULL,
        `created_at` DATETIME NOT NULL,
        INDEX `id_index` (`id`),
        INDEX `queue_name_index` (`queue_name`),
        INDEX `summary_index` (`summary`),
        INDEX `image_id_index` (`image_id`),
        INDEX `state_index` (`state`),
        INDEX `queue_name_state_index` (`queue_name`, `state`),
        INDEX `queue_name_created_at_index` (`queue_name`, `created_at`),
        INDEX `queue_name_locked_at_index` (`queue_name`, `locked_at`),
        INDEX `created_at_index` (`created_at`),
        INDEX `locked_at_index` (`locked_at`)
      )"
      db.query(sql)
      sql = "CREATE TABLE `data_items` (
        `auto_id` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
        `key` VARCHAR(255) NOT NULL,
        `item` LONGBLOB NOT NULL,
        `summary` VARCHAR(2048) NOT NULL,
        `image_id` VARCHAR(255),
        `created_at` DATETIME NOT NULL,
        INDEX `key_index` (`key`),
        UNIQUE KEY `key` (`key`),
        INDEX `summary_index` (`summary`),
        INDEX `image_id_index` (`image_id`),
        INDEX `created_at_index` (`created_at`)
      )"
      db.query(sql)
      sql = "CREATE TABLE `tags` (
        `auto_id` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
        `id` VARCHAR(255) NOT NULL,
        `name` VARCHAR(255) NOT NULL,
        `data_item_key` VARCHAR(255),
        `created_at` DATETIME NOT NULL,
        INDEX `id_index` (`id`),
        INDEX `data_item_key_index` (`data_item_key`),
        INDEX `name_index` (`name`),
        INDEX `created_at_index` (`created_at`)
      )"
      db.query(sql)
      sql = "CREATE TABLE `dictionary_items` (
        `auto_id` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
        `id` VARCHAR(255) NOT NULL,
        `name` VARCHAR(255) NOT NULL,
        `key` VARCHAR(255) NOT NULL,
        `value` LONGBLOB NOT NULL,
        `summary` VARCHAR(2048),
        `image_id` VARCHAR(255),
        `created_at` DATETIME NOT NULL,
        INDEX `id_index` (`id`),
        INDEX `name_index` (`name`),
        INDEX `name_key_index` (`name`,`key`),
        UNIQUE KEY `name_key` (`name`,`key`),
        INDEX `summary_index` (`summary`),
        INDEX `image_id_index` (`image_id`),
        INDEX `created_at_index` (`created_at`)
      )"
      db.query(sql)
      sql = "CREATE TABLE `set_items` (
        `auto_id` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
        `id` VARCHAR(255) NOT NULL,
        `name` VARCHAR(255) NOT NULL,
        `value` VARCHAR(255) NOT NULL,
        `created_at` DATETIME NOT NULL,
        INDEX `id_index` (`id`),
        INDEX `name_index` (`name`),
        INDEX `name_value_index` (`name`,`value`),
        UNIQUE KEY `name_value` (`name`,`value`),
        INDEX `created_at_index` (`created_at`)
      )"
      db.query(sql)
      sql = "CREATE TABLE `images` (
        `auto_id` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
        `id` VARCHAR(255) NOT NULL,
        `data` LONGBLOB NOT NULL,
        `summary` VARCHAR(255) NOT NULL,
        `full_image_id` VARCHAR(255),
        `x_resolution` INT NOT NULL,
        `y_resolution` INT NOT NULL,
        `created_at` DATETIME NOT NULL,
        INDEX `id_index` (`id`),
        INDEX `full_image_id_index` (`full_image_id`),
        INDEX `summary_index` (`summary`),
        INDEX `resolution_index` (`x_resolution`, `y_resolution`),
        INDEX `created_at_index` (`created_at`)
      )"
      db.query(sql)
       sql = "CREATE TABLE `document_values` (
        `auto_id` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
        `document_id` VARCHAR(255) NOT NULL,
        `key` VARCHAR(255) NOT NULL,
        `value` LONGBLOB NOT NULL,
        `summary` VARCHAR(2048) NOT NULL,
        `image_id` VARCHAR(255),
        `created_at` DATETIME NOT NULL,
        INDEX `document_id_index` (`document_id`),
        INDEX `doc_id_key_index` (`document_id`,`key`),
        INDEX `summary_index` (`summary`),
        INDEX `image_id_index` (`image_id`),
        INDEX `created_at_index` (`created_at`)
      )"
      db.query(sql)
    end
  end
end
