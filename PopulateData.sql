use `Pizzeria`;
INSERT INTO topping (ToppingName, ToppingPrice, ToppingCost, ToppingInventoryCur, ToppingInventoryMin, ToppingAmountS, ToppingAmountM, ToppingAmountL, ToppingAmountXL)
VALUES 
('Pepperoni', 1.25, 0.2, 100, 50, 2, 2.75, 3.5, 4.5),
('Sausage', 1.25, 0.15, 100, 50, 2.5, 3, 3.5, 4.25),
('Ham', 1.5, 0.15, 78, 25, 2, 2.5, 3.25, 4),
('Chicken', 1.75, 0.25, 56, 25, 1.5, 2, 2.25, 3),
('Green Pepper', 0.5, 0.02, 79, 25, 1, 1.5, 2, 2.5),
('Onion', 0.5, 0.02, 85, 25, 1, 1.5, 2, 2.75),
('Roma Tomato', 0.75, 0.03, 86, 10, 2, 3, 3.5, 4.5),
('Mushrooms', 0.75, 0.1, 52, 50, 1.5, 2, 2.5, 3),
('Black Olives', 0.6, 0.1, 39, 25, 0.75, 1, 1.5, 2),
('Pineapple', 1, 0.25, 15, 0, 1, 1.25, 1.75, 2),
('Jalapenos', 0.5, 0.05, 64, 0, 0.5, 0.75, 1.25, 1.75),
('Banana Peppers', 0.5, 0.05, 36, 0, 0.6, 1, 1.3, 1.75),
('Regular Cheese', 0.5, 0.12, 250, 50, 2, 3.5, 5, 7),
('Four Cheese Blend', 1, 0.15, 150, 25, 2, 3.5, 5, 7),
('Feta Cheese', 1.5, 0.18, 75, 0, 1.75, 3, 4, 5.5),
('Goat Cheese', 1.5, 0.2, 54, 0, 1.6, 2.75, 4, 5.5),
('Bacon', 1.5, 0.25, 89, 0, 1, 1.5, 2, 3);

INSERT INTO discount (DiscountDollarAmount, DiscountPercentAmount, DiscountName)
VALUES 
(NULL, 15.00, 'Employee'),
(1.00, NULL, 'Lunch Special Medium'),
(2.00, NULL, 'Lunch Special Large'),
(1.50, NULL, 'Specialty Pizza'),
(NULL, 10.00, 'Happy Hour'),
(NULL, 20.00, 'Gameday Special');

INSERT INTO base_pizza (BasePizzaCrustType, BasePizzaSize, BasePizzaPrice, BasePizzaCost)
VALUES 
('Thin', 'Small', 3.00, 0.5),
('Original', 'Small', 3.00, 0.75),
('Pan', 'Small', 3.50, 1),
('Gluten-Free', 'Small', 4.00, 2),
('Thin', 'Medium', 5.00, 1),
('Original', 'Medium', 5.00, 1.5),
('Pan', 'Medium', 6.00, 2.25),
('Gluten-Free', 'Medium', 6.25, 3),
('Thin', 'Large', 8.00, 1.25),
('Original', 'Large', 8.00, 2),
('Pan', 'Large', 9.00, 3),
('Gluten-Free', 'Large', 9.50, 4),
('Thin', 'XLarge', 10.00, 2),
('Original', 'XLarge', 10.00, 3),
('Pan', 'XLarge', 11.50, 4.5),
('Gluten-Free', 'XLarge', 12.50, 6);

-- ORDER 1
        SET @discount_dollar_amount = (SELECT DiscountDollarAmount FROM discount WHERE DiscountName = 'Lunch Special Large');

    INSERT INTO commission (CommissionType, CommissionTime, CommissionPrice, CommissionCost) 
    VALUES ('Dine-in', '2024-03-05 12:03:00', (20.75 - @discount_dollar_amount), 3.68);

    SET @commission_id = LAST_INSERT_ID();
    
    INSERT INTO dinein_commission (CommissionID, DineInTableNum) 
    VALUES (@commission_id, 21);

    INSERT INTO pizza (BasePizzaID, CommissionID, PizzaPrice, PizzaCost, PizzaState) 
    VALUES (
        (SELECT BasePizzaID FROM base_pizza WHERE BasePizzaSize = 'Large' AND BasePizzaCrustType = 'Thin'),
        @commission_id,
        (20.75 - @discount_dollar_amount),
        3.68,
        'Completed'
    );

    SET @pizza_id = LAST_INSERT_ID();

    INSERT INTO pizza_topping (PizzaID, ToppingID, PizzaToppingExtra) 
    VALUES 
        (@pizza_id, (SELECT ToppingID FROM topping WHERE ToppingName = 'Regular Cheese'), 1),
        (@pizza_id, (SELECT ToppingID FROM topping WHERE ToppingName = 'Pepperoni'), 0),
        (@pizza_id, (SELECT ToppingID FROM topping WHERE ToppingName = 'Sausage'), 0);

    INSERT INTO pizza_discount (PizzaID, DiscountID) 
    VALUES (
        @pizza_id,
        (SELECT DiscountID FROM discount WHERE DiscountName = 'Lunch Special Large')
    );
    
-- ORDER 2
    SET @lunch_special_discount_amount = (SELECT DiscountDollarAmount FROM discount WHERE DiscountName = 'Lunch Special Medium');
    set @specialty_discount_amount = (SELECT DiscountDollarAmount FROM discount WHERE DiscountName = 'Specialty Pizza');
    
    INSERT INTO commission (CommissionType, CommissionTime, CommissionPrice, CommissionCost) 
    VALUES ('Dine-in', '2024-04-03 12:05:00', (12.85 - @lunch_special_discount_amount - @specialty_discount_amount) + 6.93, 3.23 + 1.40);

    SET @commission_id = LAST_INSERT_ID();

    INSERT INTO dinein_commission (CommissionID, DineInTableNum) 
    VALUES (@commission_id, 4);

    INSERT INTO pizza (BasePizzaID, CommissionID, PizzaPrice, PizzaCost, PizzaState) 
    VALUES (
        (SELECT BasePizzaID FROM base_pizza WHERE BasePizzaSize = 'Medium' AND BasePizzaCrustType = 'Pan'),
        @commission_id,
        (12.85 - @lunch_special_discount_amount - @specialty_discount_amount),
        3.23,
        'Completed'
    );

    SET @pan_pizza_id = LAST_INSERT_ID();

    INSERT INTO pizza_topping (PizzaID, ToppingID, PizzaToppingExtra) 
    VALUES 
        (@pan_pizza_id, (SELECT ToppingID FROM topping WHERE ToppingName = 'Feta Cheese'), 0),
        (@pan_pizza_id, (SELECT ToppingID FROM topping WHERE ToppingName = 'Black Olives'), 0),
        (@pan_pizza_id, (SELECT ToppingID FROM topping WHERE ToppingName = 'Roma Tomato'), 0),
        (@pan_pizza_id, (SELECT ToppingID FROM topping WHERE ToppingName = 'Mushrooms'), 0),
        (@pan_pizza_id, (SELECT ToppingID FROM topping WHERE ToppingName = 'Banana Peppers'), 0);

    INSERT INTO pizza_discount (PizzaID, DiscountID) 
    VALUES (
        @pan_pizza_id,
        (SELECT DiscountID FROM discount WHERE DiscountName = 'Lunch Special Medium')
    ),(
        @pan_pizza_id,
        (SELECT DiscountID FROM discount WHERE DiscountName = 'Specialty Pizza')
    );

    INSERT INTO pizza (BasePizzaID, CommissionID, PizzaPrice, PizzaCost, PizzaState) 
    VALUES (
        (SELECT BasePizzaID FROM base_pizza WHERE BasePizzaSize = 'Small' AND BasePizzaCrustType = 'Original'),
        @commission_id,
        6.93,
        1.40,
        'Completed'
    );

    SET @original_pizza_id = LAST_INSERT_ID();

    INSERT INTO pizza_topping (PizzaID, ToppingID, PizzaToppingExtra) 
    VALUES 
        (@original_pizza_id, (SELECT ToppingID FROM topping WHERE ToppingName = 'Regular Cheese'), 0),
        (@original_pizza_id, (SELECT ToppingID FROM topping WHERE ToppingName = 'Chicken'), 0),
        (@original_pizza_id, (SELECT ToppingID FROM topping WHERE ToppingName = 'Banana Peppers'), 0);

-- Order 3
    INSERT INTO customer (CustomerName, CustomerPhone)
    VALUES ('Andrew Wilkes-Krier', '864-254-5861');

    SET @customer_id = (SELECT CustomerID FROM customer WHERE CustomerPhone = '864-254-5861');

    INSERT INTO commission (CommissionType, CommissionTime, CommissionPrice, CommissionCost)
    VALUES ('Pickup', '2024-03-03 21:30:00', 14.88 * 6, 3.30 * 6);

    SET @commission_id = LAST_INSERT_ID();

    INSERT INTO pickup_commission (CommissionID, CustomerID)
    VALUES (@commission_id, @customer_id);

    INSERT INTO pizza (BasePizzaID, CommissionID, PizzaPrice, PizzaCost, PizzaState)
    VALUES (
        (SELECT BasePizzaID FROM base_pizza WHERE BasePizzaSize = 'Large' AND BasePizzaCrustType = 'Original'),
        @commission_id,
        14.88,
        3.30,
        'Completed'
    );

    SET @pizza_id_1 = LAST_INSERT_ID();

    INSERT INTO pizza_topping (PizzaID, ToppingID, PizzaToppingExtra)
    VALUES 
        (@pizza_id_1, (SELECT ToppingID FROM topping WHERE ToppingName = 'Regular Cheese'), 0),
        (@pizza_id_1, (SELECT ToppingID FROM topping WHERE ToppingName = 'Pepperoni'), 0);

    INSERT INTO pizza (BasePizzaID, CommissionID, PizzaPrice, PizzaCost, PizzaState)
    VALUES (
        (SELECT BasePizzaID FROM base_pizza WHERE BasePizzaSize = 'Large' AND BasePizzaCrustType = 'Original'),
        @commission_id,
        14.88,
        3.30,
        'Completed'
    );

    SET @pizza_id_2 = LAST_INSERT_ID();

    INSERT INTO pizza_topping (PizzaID, ToppingID, PizzaToppingExtra)
    VALUES 
        (@pizza_id_2, (SELECT ToppingID FROM topping WHERE ToppingName = 'Regular Cheese'), 0),
        (@pizza_id_2, (SELECT ToppingID FROM topping WHERE ToppingName = 'Pepperoni'), 0);

    INSERT INTO pizza (BasePizzaID, CommissionID, PizzaPrice, PizzaCost, PizzaState)
    VALUES (
        (SELECT BasePizzaID FROM base_pizza WHERE BasePizzaSize = 'Large' AND BasePizzaCrustType = 'Original'),
        @commission_id,
        14.88,
        3.30,
        'Completed'
    );

    SET @pizza_id_3 = LAST_INSERT_ID();

    INSERT INTO pizza_topping (PizzaID, ToppingID, PizzaToppingExtra)
    VALUES 
        (@pizza_id_3, (SELECT ToppingID FROM topping WHERE ToppingName = 'Regular Cheese'), 0),
        (@pizza_id_3, (SELECT ToppingID FROM topping WHERE ToppingName = 'Pepperoni'), 0);

    INSERT INTO pizza (BasePizzaID, CommissionID, PizzaPrice, PizzaCost, PizzaState)
    VALUES (
        (SELECT BasePizzaID FROM base_pizza WHERE BasePizzaSize = 'Large' AND BasePizzaCrustType = 'Original'),
        @commission_id,
        14.88,
        3.30,
        'Completed'
    );

    SET @pizza_id_4 = LAST_INSERT_ID();

    INSERT INTO pizza_topping (PizzaID, ToppingID, PizzaToppingExtra)
    VALUES 
        (@pizza_id_4, (SELECT ToppingID FROM topping WHERE ToppingName = 'Regular Cheese'), 0),
        (@pizza_id_4, (SELECT ToppingID FROM topping WHERE ToppingName = 'Pepperoni'), 0);

    INSERT INTO pizza (BasePizzaID, CommissionID, PizzaPrice, PizzaCost, PizzaState)
    VALUES (
        (SELECT BasePizzaID FROM base_pizza WHERE BasePizzaSize = 'Large' AND BasePizzaCrustType = 'Original'),
        @commission_id,
        14.88,
        3.30,
        'Completed'
    );

    SET @pizza_id_5 = LAST_INSERT_ID();

    INSERT INTO pizza_topping (PizzaID, ToppingID, PizzaToppingExtra)
    VALUES 
        (@pizza_id_5, (SELECT ToppingID FROM topping WHERE ToppingName = 'Regular Cheese'), 0),
        (@pizza_id_5, (SELECT ToppingID FROM topping WHERE ToppingName = 'Pepperoni'), 0);

    INSERT INTO pizza (BasePizzaID, CommissionID, PizzaPrice, PizzaCost, PizzaState)
    VALUES (
        (SELECT BasePizzaID FROM base_pizza WHERE BasePizzaSize = 'Large' AND BasePizzaCrustType = 'Original'),
        @commission_id,
        14.88,
        3.30,
        'Completed'
    );

    SET @pizza_id_6 = LAST_INSERT_ID();

    INSERT INTO pizza_topping (PizzaID, ToppingID, PizzaToppingExtra)
    VALUES 
        (@pizza_id_6, (SELECT ToppingID FROM topping WHERE ToppingName = 'Regular Cheese'), 0),
        (@pizza_id_6, (SELECT ToppingID FROM topping WHERE ToppingName = 'Pepperoni'), 0);

-- Order 4
        SET @gameday_discount_percent = (SELECT DiscountPercentAmount FROM discount WHERE DiscountName = 'Gameday Special') / 100;

    SET @customer_id = (SELECT CustomerID FROM customer WHERE CustomerPhone = '864-254-5861');
    UPDATE customer 
    SET CustomerState = 'SC', 
        CustomerCity = 'Anderson', 
        CustomerStreet = '115 Party Blvd', 
        CustomerZipcode = '29621'
    WHERE CustomerID = @customer_id;

    INSERT INTO commission (CommissionType, CommissionTime, CommissionPrice, CommissionCost)
    VALUES ('Delivery', '2024-04-20 19:11:00', (27.94 + 31.50 + 26.75) - ((27.94 + 31.50 + 26.75) * @gameday_discount_percent) - @specialty_discount_amount, 9.19 + 6.25 + 8.18);

    SET @commission_id = LAST_INSERT_ID();

    INSERT INTO delivery_commission (CommissionID, CustomerID)
    VALUES (@commission_id, @customer_id);
    
    INSERT INTO pizza (BasePizzaID, CommissionID, PizzaPrice, PizzaCost, PizzaState)
    VALUES (
        (SELECT BasePizzaID FROM base_pizza WHERE BasePizzaSize = 'XLarge' AND BasePizzaCrustType = 'Original'),
        @commission_id,
        27.94  - (27.94 * @gameday_discount_percent),
        9.19,
        'Completed'
    );

    SET @pizza_id_1 = LAST_INSERT_ID();
    
    INSERT INTO pizza (BasePizzaID, CommissionID, PizzaPrice, PizzaCost, PizzaState)
    VALUES (
        (SELECT BasePizzaID FROM base_pizza WHERE BasePizzaSize = 'XLarge' AND BasePizzaCrustType = 'Original'),
        @commission_id,
        31.50 - (31.50 * @gameday_discount_percent) - @specialty_discount_amount,
        6.25,
        'Completed'
    );

    SET @pizza_id_2 = LAST_INSERT_ID();

    INSERT INTO pizza (BasePizzaID, CommissionID, PizzaPrice, PizzaCost, PizzaState)
    VALUES (
        (SELECT BasePizzaID FROM base_pizza WHERE BasePizzaSize = 'XLarge' AND BasePizzaCrustType = 'Original'),
        @commission_id,
        26.75 - (26.75 * @gameday_discount_percent),
        8.18,
        'Completed'
    );

    SET @pizza_id_3 = LAST_INSERT_ID();

    INSERT INTO pizza_topping (PizzaID, ToppingID, PizzaToppingExtra)
    VALUES 
        (@pizza_id_1, (SELECT ToppingID FROM topping WHERE ToppingName = 'Four Cheese Blend'), 0),
        (@pizza_id_1, (SELECT ToppingID FROM topping WHERE ToppingName = 'Pepperoni'), 0),
        (@pizza_id_1, (SELECT ToppingID FROM topping WHERE ToppingName = 'Sausage'), 0);

    INSERT INTO pizza_topping (PizzaID, ToppingID, PizzaToppingExtra)
    VALUES 
        (@pizza_id_2, (SELECT ToppingID FROM topping WHERE ToppingName = 'Four Cheese Blend'), 0),
        (@pizza_id_2, (SELECT ToppingID FROM topping WHERE ToppingName = 'Ham'), 1),
        (@pizza_id_2, (SELECT ToppingID FROM topping WHERE ToppingName = 'Pineapple'), 1);

    INSERT INTO pizza_topping (PizzaID, ToppingID, PizzaToppingExtra)
    VALUES 
        (@pizza_id_3, (SELECT ToppingID FROM topping WHERE ToppingName = 'Four Cheese Blend'), 0),
        (@pizza_id_3, (SELECT ToppingID FROM topping WHERE ToppingName = 'Chicken'), 0),
        (@pizza_id_3, (SELECT ToppingID FROM topping WHERE ToppingName = 'Bacon'), 0);

    INSERT INTO commission_discount (CommissionID, DiscountID)
    VALUES (@commission_id, (SELECT DiscountID FROM discount WHERE DiscountName = 'Gameday Special'));

    INSERT INTO pizza_discount (PizzaID, DiscountID)
    VALUES (@pizza_id_2, (SELECT DiscountID FROM discount WHERE DiscountName = 'Specialty Pizza'));

-- Order 5
    INSERT INTO customer (CustomerName, CustomerPhone)
    VALUES ('Matt Engers', '864-474-9953')
    ON DUPLICATE KEY UPDATE CustomerPhone = '864-474-9953';

    SET @customer_id = (SELECT CustomerID FROM customer WHERE CustomerPhone = '864-474-9953');

    INSERT INTO commission (CommissionType, CommissionTime, CommissionPrice, CommissionCost)
    VALUES ('Pickup', '2024-03-02 17:30:00', 27.45 - @specialty_discount_amount, 7.88);

    SET @commission_id = LAST_INSERT_ID();

    INSERT INTO pickup_commission (CommissionID, CustomerID)
    VALUES (@commission_id, @customer_id);

    INSERT INTO pizza (BasePizzaID, CommissionID, PizzaPrice, PizzaCost, PizzaState)
    VALUES (
        (SELECT BasePizzaID FROM base_pizza WHERE BasePizzaSize = 'XLarge' AND BasePizzaCrustType = 'Gluten-Free'),
        @commission_id,
        27.45 - @specialty_discount_amount,
        7.88,
        'Completed'
    );

    SET @pizza_id = LAST_INSERT_ID();

    INSERT INTO pizza_topping (PizzaID, ToppingID, PizzaToppingExtra)
    VALUES 
        (@pizza_id, (SELECT ToppingID FROM topping WHERE ToppingName = 'Green Pepper'), 0),
        (@pizza_id, (SELECT ToppingID FROM topping WHERE ToppingName = 'Onion'), 0),
        (@pizza_id, (SELECT ToppingID FROM topping WHERE ToppingName = 'Roma Tomato'), 0),
        (@pizza_id, (SELECT ToppingID FROM topping WHERE ToppingName = 'Mushrooms'), 0),
        (@pizza_id, (SELECT ToppingID FROM topping WHERE ToppingName = 'Black Olives'), 0),
        (@pizza_id, (SELECT ToppingID FROM topping WHERE ToppingName = 'Goat Cheese'), 0);

    INSERT INTO pizza_discount (PizzaID, DiscountID)
    VALUES (@pizza_id, (SELECT DiscountID FROM discount WHERE DiscountName = 'Specialty Pizza'));

-- Order 6
    INSERT INTO customer (CustomerName, CustomerPhone, CustomerState, CustomerCity, CustomerStreet, CustomerZipcode)
    VALUES ('Frank Turner', '864-232-8944', 'SC', 'Anderson', '6745 Wessex St', '29621')
    ON DUPLICATE KEY UPDATE CustomerPhone = '864-232-8944';

    SET @customer_id = (SELECT CustomerID FROM customer WHERE CustomerPhone = '864-232-8944');

    INSERT INTO commission (CommissionType, CommissionTime, CommissionPrice, CommissionCost)
    VALUES ('Delivery', '2024-03-02 18:17:00', 20.81, 3.19);

    SET @commission_id = LAST_INSERT_ID();

    INSERT INTO delivery_commission (CommissionID, CustomerID)
    VALUES (@commission_id, @customer_id);

    INSERT INTO pizza (BasePizzaID, CommissionID, PizzaPrice, PizzaCost, PizzaState)
    VALUES (
        (SELECT BasePizzaID FROM base_pizza WHERE BasePizzaSize = 'Large' AND BasePizzaCrustType = 'Thin'),
        @commission_id,
        20.81,
        3.19,
        'Completed'
    );

    SET @pizza_id = LAST_INSERT_ID();

    INSERT INTO pizza_topping (PizzaID, ToppingID, PizzaToppingExtra)
    VALUES 
        (@pizza_id, (SELECT ToppingID FROM topping WHERE ToppingName = 'Chicken'), 0),
        (@pizza_id, (SELECT ToppingID FROM topping WHERE ToppingName = 'Green Pepper'), 0),
        (@pizza_id, (SELECT ToppingID FROM topping WHERE ToppingName = 'Onion'), 0),
        (@pizza_id, (SELECT ToppingID FROM topping WHERE ToppingName = 'Mushrooms'), 0),
        (@pizza_id, (SELECT ToppingID FROM topping WHERE ToppingName = 'Four Cheese Blend'), 1);
        
-- Order 7
        SET @employee_discount_percentage = (SELECT DiscountPercentAmount FROM discount WHERE DiscountName = 'Employee') / 100;
    INSERT INTO customer (CustomerName, CustomerPhone, CustomerState, CustomerCity, CustomerStreet, CustomerZipcode)
    VALUES ('Milo Auckerman', '864-878-5679', 'SC', 'Anderson', '8879 Suburban Home', '29621')
    ON DUPLICATE KEY UPDATE CustomerPhone = '864-878-5679';

    SET @customer_id = (SELECT CustomerID FROM customer WHERE CustomerPhone = '864-878-5679');

    INSERT INTO commission (CommissionType, CommissionTime, CommissionPrice, CommissionCost)
    VALUES ('Delivery', '2024-04-13 20:32:00', (13.00 + 19.25) - ((13.00 + 19.25) * @employee_discount_percentage), 2.00 + 3.25);

    SET @commission_id = LAST_INSERT_ID();

    INSERT INTO delivery_commission (CommissionID, CustomerID)
    VALUES (@commission_id, @customer_id);

    INSERT INTO pizza (BasePizzaID, CommissionID, PizzaPrice, PizzaCost, PizzaState)
    VALUES (
        (SELECT BasePizzaID FROM base_pizza WHERE BasePizzaSize = 'Large' AND BasePizzaCrustType = 'Thin'),
        @commission_id,
        13.00 - (13.00 * @employee_discount_percentage),
        2.00,
        'Completed'
    );

    SET @pizza_id_1 = LAST_INSERT_ID();

    INSERT INTO pizza (BasePizzaID, CommissionID, PizzaPrice, PizzaCost, PizzaState)
    VALUES (
        (SELECT BasePizzaID FROM base_pizza WHERE BasePizzaSize = 'Large' AND BasePizzaCrustType = 'Thin'),
        @commission_id,
        19.25 - (19.25 * @employee_discount_percentage),
        3.25,
        'Completed'
    );

    SET @pizza_id_2 = LAST_INSERT_ID();

    INSERT INTO pizza_topping (PizzaID, ToppingID, PizzaToppingExtra)
    VALUES 
        (@pizza_id_1, (SELECT ToppingID FROM topping WHERE ToppingName = 'Four Cheese Blend'), 1);

    INSERT INTO pizza_topping (PizzaID, ToppingID, PizzaToppingExtra)
    VALUES 
        (@pizza_id_2, (SELECT ToppingID FROM topping WHERE ToppingName = 'Regular Cheese'), 0),
        (@pizza_id_2, (SELECT ToppingID FROM topping WHERE ToppingName = 'Pepperoni'), 1);

    INSERT INTO commission_discount (CommissionID, DiscountID)
    VALUES (@commission_id, (SELECT DiscountID FROM discount WHERE DiscountName = 'Employee'));

