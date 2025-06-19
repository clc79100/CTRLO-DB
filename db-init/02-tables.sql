DROP DATABASE IF EXISTS ModaStore;
CREATE DATABASE ModaStore
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE ModaStore;

CREATE TABLE Category(
    category_id INT NOT NULL AUTO_INCREMENT,
    category_name VARCHAR(30),
    category_is_active BOOLEAN DEFAULT TRUE,
    PRIMARY KEY(category_id)
);

CREATE TABLE Provider(
    provider_id INT NOT NULL AUTO_INCREMENT,
    provider_name VARCHAR(30) NOT NULL,
    provider_mail VARCHAR(30),
    provider_phone VARCHAR(10),
    provider_is_active BOOLEAN DEFAULT TRUE,
    PRIMARY KEY(provider_id)
);

CREATE TABLE Customer(
    customer_id INT NOT NULL AUTO_INCREMENT,
    customer_name VARCHAR(30),
    customer_is_active BOOLEAN DEFAULT TRUE,
    PRIMARY KEY(customer_id)
);

CREATE TABLE User(
    user_id INT NOT NULL AUTO_INCREMENT,
    user_mail VARCHAR(50) NOT NULL,
    user_password VARCHAR(10) NOT NULL,
    user_role VARCHAR(30) NOT NULL,
    user_is_active BOOLEAN DEFAULT TRUE,
    PRIMARY KEY(user_id)
);

CREATE TABLE Product(
    product_id INT NOT NULL AUTO_INCREMENT,
    product_code INT NOT NULL,
    product_name VARCHAR(30) NOT NULL,
    product_size VARCHAR(30) NOT NULL,
    product_color VARCHAR(30) NOT NULL,
    product_price DECIMAL(7, 2) NOT NULL,
    product_stock INT NOT NULL,
    provider_id INT NOT NULL,
    category_id INT NOT NULL,
    product_is_active BOOLEAN DEFAULT TRUE,
    PRIMARY KEY(product_id),
    CONSTRAINT fk_category_id FOREIGN KEY(category_id) REFERENCES Category(category_id),
    CONSTRAINT fk_provider_id FOREIGN KEY(provider_id) REFERENCES Provider(provider_id)
);

CREATE TABLE Sale(
    sale_id INT NOT NULL AUTO_INCREMENT,
    sale_invoice_num INT NOT NULL UNIQUE,
    sale_date DATE NOT NULL,
    customer_id INT NOT NULL,
    sale_is_active BOOLEAN DEFAULT TRUE,
    PRIMARY KEY(sale_id),
    CONSTRAINT fk_customer_id FOREIGN KEY(customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE Products_Sold(
    products_sold_id INT NOT NULL AUTO_INCREMENT,
    sale_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity_sold INT NOT NULL,
    PRIMARY KEY(products_sold_id),
    CONSTRAINT fk_sale_id FOREIGN KEY(sale_id) REFERENCES Sale(sale_id),
    CONSTRAINT fk_product_id FOREIGN KEY(product_id) REFERENCES Product(product_id)
);