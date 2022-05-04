-- TRIGGER
DELIMITER //
CREATE TRIGGER adding_medicine
BEFORE INSERT ON Medicine FOR EACH ROW
BEGIN
IF NEW.Quantity < 0 THEN SET NEW.Quantity = 0;
END IF;
IF NEW.Price < 1 THEN SET NEW.Price = 1;
END IF;
END //
DELIMITER ;

INSERT INTO Medicine
VALUES (10004, 'Abacavir', 0, '2021-03-01', '2023-03-01', -1, 'Johnson & Johnson');

SELECT *
FROM Medicine;


DELIMITER //
CREATE TRIGGER adding_room
BEFORE INSERT ON Room FOR EACH ROW
BEGIN
IF NEW.Room_type = '' THEN SET NEW.Room_type = 'recovery';
END IF;
END //
DELIMITER ;