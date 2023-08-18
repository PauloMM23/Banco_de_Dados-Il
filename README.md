# Banco_de_Dados-Il
Repositório da disciplina Banco de Dados ll


Aula 18-08
/* Nome do produto, nome do fornecedor, nome da categoria, preço e estoque
*/

select dbo.Products.ProductName, dbo.Suppliers.CompanyName, dbo.Categories.CategoryName, dbo.Products.UnitPrice, dbo.Products.UnitsInStock
from dbo.Products
inner join dbo.Suppliers
on (dbo.products.SupplierID = dbo.Suppliers.SupplierID)
inner join dbo.Categories
on (dbo.Products.CategoryID = dbo.Categories.CategoryID)

/* Ocultar produtos com estoque zerado e descontinuados
*/

select dbo.Products.ProductName, dbo.Suppliers.CompanyName, dbo.Categories.CategoryName, dbo.Products.UnitPrice, dbo.Products.UnitsInStock, dbo.Products.Discontinued
from dbo.Products
inner join dbo.Suppliers
on (dbo.products.SupplierID = dbo.Suppliers.SupplierID)
inner join dbo.Categories
on (dbo.Products.CategoryID = dbo.Categories.CategoryID)
where dbo.Products.UnitsInStock > 0 and dbo.Products.Discontinued = 0

/* Listar produtos com estoque zerado ou descontinuados 
*/

select dbo.Products.ProductName, dbo.Suppliers.CompanyName, dbo.Categories.CategoryName, dbo.Products.UnitPrice, dbo.Products.UnitsInStock, dbo.Products.Discontinued
from dbo.Products
inner join dbo.Suppliers
on (dbo.products.SupplierID = dbo.Suppliers.SupplierID)
inner join dbo.Categories
on (dbo.Products.CategoryID = dbo.Categories.CategoryID)
where dbo.Products.UnitsInStock = 0 and dbo.Products.Discontinued = 1

/*Nome do vendedor e a quantidade de vendas que ele possui
*/
