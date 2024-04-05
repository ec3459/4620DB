use `Pizzeria`;

DROP VIEW ToppingPopularity;
CREATE VIEW ToppingPopularity AS
SELECT topping.ToppingName AS Topping, 
       COALESCE(COUNT(pizza_topping.ToppingID), 0) + COALESCE(SUM(pizza_topping.PizzaToppingExtra), 0) AS ToppingCount
FROM topping
LEFT JOIN pizza_topping ON topping.ToppingID = pizza_topping.ToppingID
GROUP BY topping.ToppingName
ORDER BY ToppingCount DESC;
SELECT * FROM ToppingPopularity;

DROP VIEW ProfitByPizza;
CREATE VIEW ProfitByPizza AS 
SELECT base_pizza.BasePizzaSize AS Size, 
       base_pizza.BasePizzaCrustType AS Crust, 
       SUM(pizza.PizzaPrice - pizza.PizzaCost) AS Profit, 
       DATE_FORMAT(commission.CommissionTime, '%m/%Y') AS "Order Month"
FROM pizza
JOIN base_pizza ON pizza.BasePizzaID = base_pizza.BasePizzaID
JOIN commission ON pizza.CommissionID = commission.CommissionID
GROUP BY Size, Crust
ORDER BY Profit ASC;
SELECT * FROM ProfitByPizza;

DROP VIEW ProfitByOrder;
CREATE VIEW ProfitByOrder AS
SELECT 
    CommissionType AS customerType, 
    DATE_FORMAT(commission.CommissionTime, '%m/%Y') AS `Order Month`,
    SUM(CommissionPrice) AS TotalOrderPrice, 
    SUM(CommissionCost) AS TotalOrderCost, 
    SUM(CommissionPrice - CommissionCost) AS Profit
FROM commission
GROUP BY customerType WITH ROLLUP
ORDER BY TotalOrderPrice ASC;
SELECT * FROM ProfitByOrder;
