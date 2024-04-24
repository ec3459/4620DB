use `Pizzeria`;
-- Evan Chapman

DROP VIEW IF EXISTS ToppingPopularity ;
CREATE VIEW ToppingPopularity AS
SELECT topping.ToppingName AS Topping, 
       COALESCE(COUNT(pizza_topping.ToppingID), 0) + COALESCE(SUM(pizza_topping.PizzaToppingExtra), 0) AS ToppingCount
FROM topping
LEFT JOIN pizza_topping ON topping.ToppingID = pizza_topping.ToppingID
GROUP BY topping.ToppingName
ORDER BY ToppingCount DESC;
SELECT * FROM ToppingPopularity;

DROP VIEW IF EXISTS ProfitByPizza;
CREATE VIEW ProfitByPizza AS 
SELECT base_pizza.BasePizzaSize AS Size, 
       base_pizza.BasePizzaCrustType AS Crust, 
       SUM(pizza.PizzaPrice - pizza.PizzaCost) AS Profit, 
       DATE_FORMAT(commission.CommissionTime, '%c/%Y') AS "Order Month"
FROM pizza
JOIN base_pizza ON pizza.BasePizzaID = base_pizza.BasePizzaID
JOIN commission ON pizza.CommissionID = commission.CommissionID
GROUP BY Size, Crust
ORDER BY Profit ASC;
SELECT * FROM ProfitByPizza;

DROP VIEW IF EXISTS ProfitByOrderType;
CREATE VIEW ProfitByOrderType AS
SELECT 
  CommissionType AS `OrderType`,
  DATE_FORMAT(commission.CommissionTime, '%c/%Y') AS `Order Month`,
  SUM(CommissionPrice) AS TotalOrderPrice, 
  SUM(CommissionCost) AS TotalOrderCost, 
  SUM(CommissionPrice - CommissionCost) AS Profit
FROM commission
GROUP BY OrderType

UNION ALL

SELECT 
  '' AS `OrderType`,
  'Grand Total' AS `Order Month`,
  SUM(CommissionPrice) AS TotalOrderPrice, 
  SUM(CommissionCost) AS TotalOrderCost, 
  SUM(CommissionPrice - CommissionCost) AS Profit
FROM commission;

SELECT * FROM ProfitByOrderType;
