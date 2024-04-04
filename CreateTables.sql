CREATE TABLE IF NOT EXISTS commission(
CommissionID INT PRIMARY KEY AUTO_INCREMENT,
CommissionType VARCHAR(30) NOT NULL,
CommissionTime DATETIME NOT NULL,
CommissionPrice DECIMAL(7,2) NOT NULL,
CommissionCost DECIMAL(7,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS customer(
CustomerID INT PRIMARY KEY AUTO_INCREMENT,
CustomerName VARCHAR(200) NOT NULL,
CustomerPhone VARCHAR(200) NOT NULL,
CustomerState VARCHAR(2) NOT NULL,
CustomerCity VARCHAR(100) NOT NULL,
CustomerStreet VARCHAR(100) NOT NULL,
CustomerZipcode VARCHAR(10) NOT NULL
);

CREATE TABLE IF NOT EXISTS delivery_commission (
    CommissionID INT,
    CustomerID INT NOT NULL,
    PRIMARY KEY (CommissionID),
    FOREIGN KEY (CommissionID) REFERENCES commission(CommissionID),
    FOREIGN KEY (CustomerID) REFERENCES customer(CustomerID)
);

CREATE TABLE IF NOT EXISTS pickup_commission (
    CommissionID INT,
    CustomerID INT NOT NULL,
    PRIMARY KEY (CommissionID),
    FOREIGN KEY (CommissionID) REFERENCES commission(CommissionID),
    FOREIGN KEY (CustomerID) REFERENCES customer(CustomerID)
);

CREATE TABLE IF NOT EXISTS dinein_commission(
	CommissionID INT PRIMARY KEY,
    DineInTableNum INT NOT NULL,
    FOREIGN KEY (CommissionID) REFERENCES commission(CommissionID)
);

CREATE TABLE IF NOT EXISTS discount(
	DiscountID INT PRIMARY KEY AUTO_INCREMENT,
    DiscountDollarAmount DECIMAL(7,2),
    DiscountPercentAmount DECIMAL (5,2),
    DiscountName VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS commission_discount (
    CommissionID INT,
    DiscountID INT,
    PRIMARY KEY (CommissionID,DiscountID),
    FOREIGN KEY (CommissionID) REFERENCES commission(CommissionID),
    FOREIGN KEY (DiscountID) REFERENCES discount(DiscountID)
);

CREATE TABLE IF NOT EXISTS base_pizza (
	BasePizzaID INT PRIMARY KEY AUTO_INCREMENT,
    BasePizzaCrustType VARCHAR(20) NOT NULL,
    BasePizzaSize VARCHAR(20) NOT NULL,
    BasePizzaPrice DECIMAL(7,2) NOT NULL,
    BasePizzaCost DECIMAL(7,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS pizza(
	PizzaID INT PRIMARY KEY AUTO_INCREMENT,
    BasePizzaID INT NOT NULL,
	CommissionID INT NOT NULL,
    PizzaPrice DECIMAL(7,2) NOT NULL,
    PizzaCost DECIMAL(7,2) NOT NULL,
    PizzaState VARCHAR(30) NOT NULL,
    FOREIGN KEY (BasePizzaID) REFERENCES base_pizza(BasePizzaID),
    FOREIGN KEY (CommissionID) REFERENCES commission(CommissionID)
);
CREATE TABLE IF NOT EXISTS pizza_discount(
	PizzaID INT,
    DiscountID INT,
    PRIMARY KEY(PizzaID, DiscountID),
    FOREIGN KEY (PizzaID) REFERENCES pizza(PizzaID),
	FOREIGN KEY (DiscountID) REFERENCES discount(DiscountID)
);

CREATE TABLE IF NOT EXISTS topping(
	ToppingID INT PRIMARY KEY AUTO_INCREMENT,
    ToppingName VARCHAR(30) NOT NULL,
    ToppingPrice DECIMAL(3,2) NOT NULL,
    ToppingCost Decimal(3,2) NOT NULL,
    ToppingAmountS INT NOT NULL,
    ToppingAmountM INT NOT NULL,
    ToppingAmountL INT NOT NULL,
    ToppingAmountXL INT NOT NULL,
    ToppingInventoryMin INT NOT NULL,
    ToppingInventoryCur INT NOT NULL
);

CREATE TABLE IF NOT EXISTS pizza_topping(
	PizzaID INT,
    ToppingID INT,
    PizzaTopingExtra BOOLEAN NOT NULL,
    PRIMARY KEY(PizzaID, ToppingID),
    FOREIGN KEY (PizzaID) REFERENCES pizza(PizzaID),
    FOREIGN KEY (ToppingID) REFERENCES topping(ToppingID)
);