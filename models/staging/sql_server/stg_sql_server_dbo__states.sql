{{
  config(
    materialized='table'
  )
}}

SELECT 
    ADDRESS_ID, -- No viene nulo ya de bronce
    ZIPCODE,
    TRIM(COUNTRY) AS COUNTRY, -- Quitamos los espacios que no son necesarios
    TRIM(ADDRESS) AS ADDRESS,
    TRIM(STATE) AS STATE,
    COALESCE(_FIVETRAN_DELETED, false) AS IS_DELETED, 
    -- Pongo falso, para que en un futuro, si entran trues puede que el cliente quiera consultar todos
    -- Esto incluiria aquellos que han sido borrados (true) y los falsos, si quiere consultar los "no borrados" serían los false
    _FIVETRAN_SYNCED AS SYNC_DATE
FROM 
    {{ source('sql_server_dbo', 'addresses') }}
