WITH tb_rfv AS (

SELECT 
        idCustomer,
        
        CAST(MIN(julianday('2024-06-04') - julianday(dtTransaction)) 
            AS INTEGER) + 1 AS recenciaDias,
        
        COUNT( DISTINCT DATE(dtTransaction)) AS frequenciaDias,

        SUM(CASE 
                WHEN pointsTransaction > 0 THEN pointsTransaction 
            END) AS valorPoints

FROM transactions

WHERE dtTransaction < '2024-06-04'
AND dtTransaction >= DATE('2024-06-04', '-21 days')

GROUP BY idCustomer

),

tb_idade AS (
    
    SELECT 

        t1.idCustomer,
        CAST(MAX(julianday('2024-06-04') - julianday(t2.dtTransaction)) 
            AS INTEGER) + 1 AS idadebaseDias 

    FROM tb_rfv as t1

    LEFT JOIN transactions as t2
    ON t1.idCustomer = t2.idCustomer

    GROUP BY t2.idCustomer

)

SELECT t1.*,
    t2.idadebaseDias,
    t3.flEmail

FROM tb_rfv AS t1

LEFT JOIN tb_idade as t2
ON t1.idCustomer = t2.idCustomer

LEFT JOIN customers as t3
ON t1.idCustomer = t3.idCustomer