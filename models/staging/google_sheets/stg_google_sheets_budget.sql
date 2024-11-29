SELECT 
       CAST(quantity AS INT) AS quantity,
       CONVERT_TIMEZONE('UTC', month) AS date_budget
       month(month) as month,
       year(month) as year,
       cast(product_id as varchar(36)) as product_id,
       CONVERT_TIMEZONE('UTC', _FIVETRAN_SYNCED) AS _FIVETRAN_SYNCED_UTC
from ALUMNO27_DEV_BRONZE_DB.GOOGLE_SHEETS.BUDGET
limit 10