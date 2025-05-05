/*MySQL Script generated for E-commerce Platform*/
/*Database: ecommerce*/

/*Create the database*/

CREATE SCHEMA IF NOT EXISTS `ecommerce` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `ecommerce`;

/*Table: attribute_type*/

CREATE TABLE `attribute_type` (
  `attribute_type_id` INT NOT NULL AUTO_INCREMENT,
  `type_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`attribute_type_id`),
  UNIQUE INDEX `type_name_UNIQUE` (`type_name` ASC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table: attribute_category*/

CREATE TABLE `attribute_category` (
  `attribute_category_id` INT NOT NULL AUTO_INCREMENT,
  `category_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`attribute_category_id`),
  UNIQUE INDEX `category_name_UNIQUE` (`category_name` ASC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table: size_category*/

CREATE TABLE `size_category` (
  `size_category_id` INT NOT NULL AUTO_INCREMENT,
  `category_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`size_category_id`),
  UNIQUE INDEX `category_name_UNIQUE` (`category_name` ASC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table: size_option*/

CREATE TABLE `size_option` (
  `size_option_id` INT NOT NULL AUTO_INCREMENT,
  `size_category_id` INT NOT NULL,
  `size_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`size_option_id`),
  INDEX `fk_size_option_size_category_idx` (`size_category_id` ASC),
  UNIQUE INDEX `size_name_category_UNIQUE` (`size_name` ASC, `size_category_id` ASC),
  CONSTRAINT `fk_size_option_size_category`
    FOREIGN KEY (`size_category_id`)
    REFERENCES `size_category` (`size_category_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table: color*/

CREATE TABLE `color` (
  `color_id` INT NOT NULL AUTO_INCREMENT,
  `color_name` VARCHAR(50) NOT NULL,
  `hex_code` CHAR(7) NULL,
  PRIMARY KEY (`color_id`),
  UNIQUE INDEX `color_name_UNIQUE` (`color_name` ASC),
  UNIQUE INDEX `hex_code_UNIQUE` (`hex_code` ASC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table: product_category*/

CREATE TABLE `product_category` (
  `category_id` INT NOT NULL AUTO_INCREMENT,
  `category_name` VARCHAR(100) NOT NULL,
  `parent_category_id` INT NULL,
  PRIMARY KEY (`category_id`),
  UNIQUE INDEX `category_name_UNIQUE` (`category_name` ASC),
  INDEX `fk_product_category_parent_idx` (`parent_category_id` ASC),
  CONSTRAINT `fk_product_category_parent`
    FOREIGN KEY (`parent_category_id`)
    REFERENCES `product_category` (`category_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table: brand*/

CREATE TABLE `brand` (
  `brand_id` INT NOT NULL AUTO_INCREMENT,
  `brand_name` VARCHAR(100) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`brand_id`),
  UNIQUE INDEX `brand_name_UNIQUE` (`brand_name` ASC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table: product*/

CREATE TABLE `product` (
  `product_id` INT NOT NULL AUTO_INCREMENT,
  `category_id` INT NOT NULL,
  `brand_id` INT NOT NULL,
  `product_name` VARCHAR(100) NOT NULL,
  `base_price` DECIMAL(10,2) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`product_id`),
  INDEX `fk_product_category_idx` (`category_id` ASC),
  INDEX `fk_product_brand_idx` (`brand_id` ASC),
  UNIQUE INDEX `product_name_brand_UNIQUE` (`product_name` ASC, `brand_id` ASC),
  CONSTRAINT `fk_product_category`
    FOREIGN KEY (`category_id`)
    REFERENCES `product_category` (`category_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_product_brand`
    FOREIGN KEY (`brand_id`)
    REFERENCES `brand` (`brand_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table: product_item*/

CREATE TABLE `product_item` (
  `product_item_id` INT NOT NULL AUTO_INCREMENT,
  `product_id` INT NOT NULL,
  `sku` VARCHAR(50) NOT NULL,
  `price` DECIMAL(10,2) NOT NULL,
  `stock_quantity` INT NOT NULL,
  PRIMARY KEY (`product_item_id`),
  INDEX `fk_product_item_product_idx` (`product_id` ASC),
  UNIQUE INDEX `sku_UNIQUE` (`sku` ASC),
  CONSTRAINT `fk_product_item_product`
    FOREIGN KEY (`product_id`)
    REFERENCES `product` (`product_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table: product_image*/

CREATE TABLE `product_image` (
  `image_id` INT NOT NULL AUTO_INCREMENT,
  `product_item_id` INT NOT NULL,
  `image_url` VARCHAR(255) NOT NULL,
  `is_primary` TINYINT(1) DEFAULT 0,
  PRIMARY KEY (`image_id`),
  INDEX `fk_product_image_product_item_idx` (`product_item_id` ASC),
  UNIQUE INDEX `image_url_product_item_UNIQUE` (`image_url` ASC, `product_item_id` ASC),
  CONSTRAINT `fk_product_image_product_item`
    FOREIGN KEY (`product_item_id`)
    REFERENCES `product_item` (`product_item_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table: product_variation*/

CREATE TABLE `product_variation` (
  `variation_id` INT NOT NULL AUTO_INCREMENT,
  `product_item_id` INT NOT NULL,
  `color_id` INT NULL,
  `size_option_id` INT NULL,
  PRIMARY KEY (`variation_id`),
  INDEX `fk_product_variation_product_item_idx` (`product_item_id` ASC),
  INDEX `fk_product_variation_color_idx` (`color_id` ASC),
  INDEX `fk_product_variation_size_option_idx` (`size_option_id` ASC),
  CONSTRAINT `fk_product_variation_product_item`
    FOREIGN KEY (`product_item_id`)
    REFERENCES `product_item` (`product_item_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_product_variation_color`
    FOREIGN KEY (`color_id`)
    REFERENCES `color` (`color_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_product_variation_size_option`
    FOREIGN KEY (`size_option_id`)
    REFERENCES `size_option` (`size_option_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table: product_attribute*/

CREATE TABLE `product_attribute` (
  `attribute_id` INT NOT NULL AUTO_INCREMENT,
  `product_id` INT NOT NULL,
  `attribute_type_id` INT NOT NULL,
  `attribute_category_id` INT NOT NULL,
  `attribute_value` TEXT NOT NULL,
  PRIMARY KEY (`attribute_id`),
  INDEX `fk_product_attribute_product_idx` (`product_id` ASC),
  INDEX `fk_product_attribute_type_idx` (`attribute_type_id` ASC),
  INDEX `fk_product_attribute_category_idx` (`attribute_category_id` ASC),
  CONSTRAINT `fk_product_attribute_product`
    FOREIGN KEY (`product_id`)
    REFERENCES `product` (`product_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_product_attribute_type`
    FOREIGN KEY (`attribute_type_id`)
    REFERENCES `attribute_type` (`attribute_type_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_product_attribute_category`
    FOREIGN KEY (`attribute_category_id`)
    REFERENCES `attribute_category` (`attribute_category_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
