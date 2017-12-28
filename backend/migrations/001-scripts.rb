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
        `default_input` LONGBLOB,
        `extensions` TEXT,
        `code` LONGTEXT,
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
        `queue_item_id` VARCHAR(255),
        `http_endpoint` VARCHAR(255),
        `http_method` VARCHAR(255),
        `input` LONGBLOB,
        `extensions` TEXT,
        `code` LONGTEXT,
        `output` LONGBLOB,
        `error` TEXT,
        `run_at` DATETIME NOT NULL,
        UNIQUE KEY `id` (`id`),
        INDEX `id_index` (`id`),
        INDEX `trigger_id_index` (`trigger_id`),
        INDEX `script_id_index` (`script_id`),
        INDEX `queue_index` (`queue_name`, `queue_item_id`),
        INDEX `http_endpoint_method_index` (`http_endpoint`, `http_method`),
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
        `http_endpoint` VARCHAR(255),
        `http_method` VARCHAR(255),
        `http_content_type` VARCHAR(255),
        `created_at` DATETIME NOT NULL,
        UNIQUE KEY `id` (`id`),
        INDEX `id_index` (`id`),
        INDEX `type_index` (`type`),
        INDEX `active_index` (`active`),
        INDEX `queue_name_index` (`queue_name`),
        INDEX `http_endpoint_method_index` (`http_endpoint`, `http_method`),
        INDEX `created_at_index` (`created_at`)
      )"
      db.query(sql)
      sql = "CREATE TABLE `queue_items` (
        `auto_id` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
        `id` VARCHAR(255) NOT NULL,
        `queue_name` VARCHAR(255) NOT NULL,
        `state` VARCHAR(255) NOT NULL,
        `item` LONGBLOB NOT NULL,
        `summary` MEDIUMTEXT NOT NULL,
        `image_id` VARCHAR(255),
        `created_at` DATETIME NOT NULL,
        INDEX `id_index` (`id`),
        INDEX `queue_name_index` (`queue_name`),
        INDEX `queue_name_state_index` (`queue_name`, `state`),
        INDEX `queue_name_created_at_index` (`queue_name`, `created_at`)
      )"
      db.query(sql)
      sql = "CREATE TABLE `data_items` (
        `auto_id` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
        `key` VARCHAR(255) NOT NULL,
        `item` LONGBLOB NOT NULL,
        `summary` MEDIUMTEXT NOT NULL,
        `image_id` VARCHAR(255),
        `created_at` DATETIME NOT NULL,
        INDEX `key_index` (`key`),
        UNIQUE KEY `key` (`key`),
        INDEX `created_at_index` (`created_at`)
      )"
      db.query(sql)
      sql = "CREATE TABLE `tags` (
        `auto_id` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
        `id` VARCHAR(255) NOT NULL,
        `data_item_key` VARCHAR(255),
        `image_id` VARCHAR(255),
        `name` VARCHAR(255) NOT NULL,
        `created_at` DATETIME NOT NULL,
        INDEX `id_index` (`id`),
        INDEX `name_index` (`name`),
        INDEX `data_item_key_index` (`data_item_key`),
        INDEX `name_data_item_key_index` (`name`,`data_item_key`),
        INDEX `image_id_index` (`image_id`),
        INDEX `name_image_id_index` (`name`,`image_id`),
        INDEX `created_at_index` (`created_at`)
      )"
      db.query(sql)
      sql = "CREATE TABLE `dictionary_items` (
        `auto_id` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
        `id` VARCHAR(255) NOT NULL,
        `name` VARCHAR(255) NOT NULL,
        `key` VARCHAR(255) NOT NULL,
        `value` TEXT NOT NULL,
        `summary` MEDIUMTEXT,
        `image_id` VARCHAR(255),
        `created_at` DATETIME NOT NULL,
        INDEX `id_index` (`id`),
        INDEX `name_index` (`name`),
        INDEX `name_key_index` (`name`,`key`),
        UNIQUE KEY `name_key` (`name`,`key`),
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
        `full_image_id` VARCHAR(255),
        `x_resolution` INT NOT NULL,
        `y_resolution` INT NOT NULL,
        `created_at` DATETIME NOT NULL,
        INDEX `id_index` (`id`),
        INDEX `full_image_id_index` (`full_image_id`),
        INDEX `resolution_index` (`x_resolution`, `y_resolution`),
        INDEX `created_at_index` (`created_at`)
      )"
      db.query(sql)
       sql = "CREATE TABLE `document_values` (
        `auto_id` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
        `document_id` VARCHAR(255) NOT NULL,
        `key` VARCHAR(255) NOT NULL,
        `value` LONGBLOB NOT NULL,
        `summary` MEDIUMTEXT NOT NULL,
        `image_id` VARCHAR(255),
        `created_at` DATETIME NOT NULL,
        INDEX `document_id_index` (`document_id`),
        INDEX `doc_id_key_index` (`document_id`,`key`),
        INDEX `created_at_index` (`created_at`)
      )"
      db.query(sql)
    end
  end
end
