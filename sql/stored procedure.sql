CREATE OR ALTER PROCEDURE find_pois
    @json_input NVARCHAR(MAX) -- JSON input parameter
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @country_code VARCHAR(10),
            @region VARCHAR(50),
            @city VARCHAR(100),
            @latitude DECIMAL(10, 7),
            @longitude DECIMAL(10, 7),
            @radius DECIMAL(10, 2),
            @polygon_wkt NVARCHAR(MAX),
            @category VARCHAR(100),
            @poi_name VARCHAR(255);

    -- Parse JSON input
    SELECT 
        @country_code = JSON_VALUE(@json_input, '$.country_code'),
        @region = JSON_VALUE(@json_input, '$.region'),
        @city = JSON_VALUE(@json_input, '$.city'),
        @latitude = TRY_CAST(JSON_VALUE(@json_input, '$.latitude') AS DECIMAL(10, 7)),
        @longitude = TRY_CAST(JSON_VALUE(@json_input, '$.longitude') AS DECIMAL(10, 7)),
        @radius = TRY_CAST(JSON_VALUE(@json_input, '$.radius') AS DECIMAL(10, 2)),
        @polygon_wkt = JSON_VALUE(@json_input, '$.polygon_wkt'),
        @category = JSON_VALUE(@json_input, '$.category'),
        @poi_name = JSON_VALUE(@json_input, '$.poi_name');

    BEGIN TRY
        -- Validate inputs
        IF @country_code IS NOT NULL AND LEN(@country_code) <> 2
            THROW 50000, 'Invalid country code format. It should be a 2-character ISO code.', 1;

        IF @region IS NOT NULL AND LEN(@region) > 50
            THROW 50001, 'Region code is too long. It should be less than 50 characters.', 1;

        IF @city IS NOT NULL AND LEN(@city) > 100
            THROW 50002, 'City name is too long. It should be less than 100 characters.', 1;

        IF @latitude IS NOT NULL AND (@latitude < -90 OR @latitude > 90)
            THROW 50003, 'Invalid latitude. It should be between -90 and 90.', 1;

        IF @longitude IS NOT NULL AND (@longitude < -180 OR @longitude > 180)
            THROW 50004, 'Invalid longitude. It should be between -180 and 180.', 1;

        IF @radius IS NOT NULL AND @radius <= 0
            THROW 50005, 'Radius must be a positive number.', 1;

        IF @polygon_wkt IS NOT NULL AND @polygon_wkt NOT LIKE 'POLYGON%'
            THROW 50006, 'Invalid WKT format. It should start with "POLYGON".', 1;

        DECLARE @location_point GEOGRAPHY = NULL;
        DECLARE @polygon GEOMETRY = NULL;

        IF @latitude IS NOT NULL AND @longitude IS NOT NULL
            SET @location_point = GEOGRAPHY::Point(@latitude, @longitude, 4326);

        IF @polygon_wkt IS NOT NULL
            BEGIN
                BEGIN TRY
                    SET @polygon = GEOMETRY::STGeomFromText(@polygon_wkt, 4326);
                END TRY
                BEGIN CATCH
                    THROW 50007, 'Invalid WKT polygon format.', 1;
                END CATCH;
            END

        -- Select POIs based on the validated inputs
        SELECT
            p.id            as 'Id',
            p.parent_id     as 'Parent ID',
            l.country_code  as 'Country code',
            l.region        as 'Region Code',
            l.city          as 'City Name',
            CONCAT(CAST(l.latitude AS VARCHAR), ', ', CAST(l.longitude AS VARCHAR)) AS 'Location coordinates (latitude, longitude)',
            c.top_category  as 'Category',
            c.sub_category  as 'Sub category',
            l.polygon_wkt   as 'WKT Polygon',
            l.location_name as 'Location Name',
            l.postal_code   as 'Postal code',
            o.hours         as 'Operation Hours'

        FROM
            pois p
        JOIN
            locations l ON p.location_id = l.id
        JOIN
            categories c ON p.category_id = c.id
        LEFT JOIN
            operation_hours o ON p.operation_hours_id = o.id
        WHERE
            (@country_code IS NULL OR l.country_code = @country_code)
            AND (@region IS NULL OR l.region = @region)
            AND (@city IS NULL OR l.city = @city)
            AND (@polygon IS NULL OR @polygon.STIntersects(GEOMETRY::STGeomFromText(l.polygon_wkt, 4326)) = 1)
            AND (@radius IS NULL OR @location_point.STDistance(GEOGRAPHY::Point(l.latitude, l.longitude, 4326)) <= @radius)
            AND (@category IS NULL OR c.top_category = @category)
            AND (@poi_name IS NULL OR l.location_name LIKE '%' + @poi_name + '%');

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
