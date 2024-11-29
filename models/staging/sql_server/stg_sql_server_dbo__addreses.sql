{{ config(materialized='incremental') }}

 SELECT 
        cast(ADDRESS_ID as varchar(36)) as ADDRESS_ID, -- todos los uuiid son de 36 caracteres.
        CAST( ZIPCODE AS INT) AS ZIPCODE, -- consideramos que siempre es un valor numérico
        cast(COUNTRY as varchar(56)) as COUNTRY, -- no hay paises con más caracteres
        ADDRESS,
       -- replace(SPLIT(address, ' ')[0],'"','') AS numero_calle,
        STATE,
        CASE
        WHEN _FIVETRAN_DELETED is null then false
        else true
        END as _FIVETRAN_DELETED, -- cambiamos de null a false 
        CONVERT_TIMEZONE('UTC', _FIVETRAN_SYNCED) AS _FIVETRAN_SYNCED_UTC
    FROM {{ source('sql_server_dbo', 'addresses') }} 

--fivetran_deleted  borrar porque todo null