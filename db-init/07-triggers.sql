USE ModaStore;

DELIMITER //
CREATE TRIGGER trg_Update_Stock_After_Sale_Created
AFTER INSERT ON Products_Sold
FOR EACH ROW
BEGIN
    UPDATE Product
    SET product_stock = product_stock - NEW.quantity_sold
    WHERE product_id = NEW.product_id;
END//


DELIMITER //
CREATE TRIGGER trg_Restock_After_Sale_Deleted
AFTER DELETE ON Products_Sold
FOR EACH ROW
BEGIN
    UPDATE Product
    SET product_stock = product_stock + OLD.quantity_sold
    WHERE product_id = OLD.product_id;
END//
DELIMITER ;
