/* Nome do produto, nome do fornecedor, nome da categoria, preço e estoque */
SELECT p.ProductName,  s.CompanyName, c.CategoryName, p.UnitPrice, p.UnitsInStock 
FROM Products AS p
INNER JOIN Suppliers AS s ON (p.SupplierID = s.SupplierID) 
INNER JOIN Categories AS c ON (p.CategoryID = c.CategoryID)

/* Ocultar produtos com estoque zerado e descontinuados */
SELECT p.ProductName, s.CompanyName, c.CategoryName, p.UnitPrice, p.UnitsInStock, p.Discontinued 
FROM Products AS p 
INNER JOIN Suppliers AS s ON (p.SupplierID = s.SupplierID) 
INNER JOIN Categories AS c ON (p.CategoryID = c.CategoryID) 
WHERE p.UnitsInStock > 0 AND p.Discontinued = 0

/* Listar produtos com estoque zerado ou descontinuados */
SELECT p.ProductName, s.CompanyName, c.CategoryName, p.UnitPrice, p.UnitsInStock, p.Discontinued 
FROM Products AS p
INNER JOIN Suppliers AS s ON (p.SupplierID = s.SupplierID) 
INNER JOIN Categories AS c ON (p.CategoryID = c.CategoryID) 
WHERE p.UnitsInStock = 0 AND p.Discontinued = 1

/* Nome do vendedor e a quantidade de vendas que ele possui */
SELECT Employees.EmployeeID AS "Nome (ID)", COUNT(*) AS "Qtd. Vendas"
FROM Employees
INNER JOIN Orders
ON Employees.EmployeeID = Orders.EmployeeID
GROUP BY Employees.EmployeeID, Orders.EmployeeID
ORDER BY "Qtd. Vendas" DESC

/* Nome do vendedor e quantidade de territórios aos quais ele está vinculado */ 
SELECT Employees.EmployeeID AS "Nome (ID)", COUNT(*) AS "Qtd. Territórios"
FROM Employees
INNER JOIN EmployeeTerritories
ON Employees.EmployeeID = EmployeeTerritories.EmployeeID
GROUP BY Employees.EmployeeID, EmployeeTerritories.EmployeeID

/* Vendas ordenadas por valor total, do maior ao menor */
SELECT Orders.OrderID, Orders.CustomerID, Orders.EmployeeID, ([Order Details].UnitPrice-[Order Details].Discount) * [Order Details].Quantity AS "Valor total venda"
FROM Orders
INNER JOIN [Order Details]
ON orders.OrderID = [Order Details].OrderID

/* Vendas em que o produto foi vendido mais barato do que o valor de compra */
SELECT [Order Details].ProductID, ([Order Details].UnitPrice - [Order Details].Discount) AS "Preço de venda", Products.UnitPrice AS "Preço de compra", ([Order Details].UnitPrice - [Order Details].Discount) - Products.UnitPrice AS "Diferença"
FROM [Order Details]
INNER JOIN Products 
ON [Order Details].ProductID = Products.ProductID
WHERE ([Order Details].UnitPrice - [Order Details].Discount) < Products.UnitPrice
ORDER BY "Diferença" ASC