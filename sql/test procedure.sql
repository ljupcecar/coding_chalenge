--1. Find POIs in Phoenix, AZ
--This query will find all POIs located in Phoenix, AZ, regardless of category or specific location.

EXEC dbo.find_pois 
    @country_code = 'US', 
    @region = 'AZ', 
    @city = 'Phoenix';

-- 2. Find POIs within a 500-meter radius of a specific point
-- This query will find all POIs within a 500-meter radius of the coordinates (33.470846, -112.114161).

EXEC dbo.find_pois 
    @country_code = 'US', 
    @region = 'AZ', 
    @city = 'Phoenix', 
    @latitude = 33.470846, 
    @longitude = -112.114161, 
    @radius = 500;

-- 3. Find POIs by Category "Grocery Stores"
-- This query will find all POIs categorized under "Grocery Stores".

EXEC dbo.find_pois 
    @country_code = 'US', 
    @region = 'AZ', 
    @city = 'Phoenix', 
    @category = 'Grocery Stores';

-- 4. Find a specific POI by name
-- This query will find a POI by the exact name "Grand Stop No 1".

EXEC dbo.find_pois 
    @country_code = 'US', 
    @region = 'AZ', 
    @city = 'Phoenix', 
    @poi_name = 'Grand Stop No 1';

-- 5. Find POIs within a custom WKT polygon
-- This query will find all POIs within a custom WKT polygon. For this example, assume we have a polygon that surrounds the area in Phoenix:

EXEC dbo.find_pois 
    @country_code = 'US', 
    @region = 'AZ', 
    @city = 'Phoenix', 
    @polygon_wkt = 'POLYGON ((-112.145 33.504, -112.145 33.502, -112.142 33.502, -112.142 33.504, -112.145 33.504))';

-- 6. Find POIs by specific category and within a radius
-- This query will find all POIs within a 1000-meter radius of the coordinates (33.508629, -112.110162) that are categorized as "Automotive Repair and Maintenance".


EXEC dbo.find_pois 
    @country_code = 'US', 
    @region = 'AZ', 
    @city = 'Phoenix', 
    @latitude = 33.508629, 
    @longitude = -112.110162, 
    @radius = 1000, 
    @category = 'Automotive Repair and Maintenance';

-- 7. Find POIs by sub-category "Home Centers"
-- This query will find all POIs categorized under "Building Material and Supplies Dealers" and sub-categorized as "Home Centers".

EXEC dbo.find_pois 
    @country_code = 'US', 
    @region = 'AZ', 
    @city = 'Phoenix', 
    @category = 'Building Material and Supplies Dealers';

-- 8. Find POIs by operation hours
-- Although the dbo.find_pois function as designed doesn't directly filter by operation hours, you can identify POIs that have operation hours defined and then refine further by filtering in the application logic or by additional stored procedure logic.


EXEC dbo.find_pois 
    @country_code = 'US', 
    @region = 'AZ', 
    @city = 'Phoenix';


-- Here are several test cases where executing the extended dbo.find_pois procedure should throw errors 
-- based on the input validation checks:

-- 1. Invalid Country Code
-- Description: The country code should be a 2-character ISO code. If it’s longer or shorter, an error should be thrown.
-- Expected Error: Invalid country code format. It should be a 2-character ISO code.

EXEC dbo.find_pois 
    @country_code = 'USA',  -- Invalid (3 characters instead of 2)
    @region = 'AZ', 
    @city = 'Phoenix';

-- 2. Region Code Too Long
-- Description: The region code should not exceed 50 characters. If it does, an error should be thrown.
-- Expected Error: Region code is too long. It should be less than 50 characters.

EXEC dbo.find_pois 
    @country_code = 'US', 
    @region = REPLICATE('A', 51),  -- Invalid (51 characters)
    @city = 'Phoenix';

-- 3. City Name Too Long
-- Description: The city name should not exceed 100 characters. If it does, an error should be thrown.
-- Expected Error: City name is too long. It should be less than 100 characters.

EXEC dbo.find_pois 
    @country_code = 'US', 
    @region = 'AZ', 
    @city = REPLICATE('Phoenix', 200);  -- Invalid (200 characters)

-- 4. Invalid Latitude
-- Description: The latitude must be between -90 and 90. If it’s outside this range, an error should be thrown.
-- Expected Error: Invalid latitude. It should be between -90 and 90.

EXEC dbo.find_pois 
    @country_code = 'US', 
    @region = 'AZ', 
    @city = 'Phoenix', 
    @latitude = 95.0,  -- Invalid (latitude > 90)
    @longitude = -112.114161;

-- 5. Invalid Longitude
-- Description: The longitude must be between -180 and 180. If it’s outside this range, an error should be thrown.
-- Expected Error: Invalid longitude. It should be between -180 and 180.

EXEC dbo.find_pois 
    @country_code = 'US', 
    @region = 'AZ', 
    @city = 'Phoenix', 
    @latitude = 33.470846, 
    @longitude = -185.0;  -- Invalid (longitude < -180)

-- 6. Invalid Radius
-- Description: The radius must be a positive number. If it’s zero or negative, an error should be thrown.
-- Expected Error: Radius must be a positive number.

EXEC dbo.find_pois 
    @country_code = 'US', 
    @region = 'AZ', 
    @city = 'Phoenix', 
    @latitude = 33.470846, 
    @longitude = -112.114161, 
    @radius = -100.0;  -- Invalid (negative radius)

-- 7. Invalid WKT Polygon Format
-- Description: The WKT polygon must start with "POLYGON". If it doesn’t, an error should be thrown.
-- Expected Error: Invalid WKT format. It should start with "POLYGON".

EXEC dbo.find_pois 
    @country_code = 'US', 
    @region = 'AZ', 
    @city = 'Phoenix', 
    @polygon_wkt = 'LINESTRING (30 10, 10 30, 40 40)';  -- Invalid (not a polygon)

-- 8. Invalid WKT Polygon Syntax
-- Description: The WKT polygon must be a valid polygon syntax. If it’s malformed, an error should be thrown.
-- Expected Error: Invalid WKT polygon format.

EXEC dbo.find_pois 
    @country_code = 'US', 
    @region = 'AZ', 
    @city = 'Phoenix', 
    @polygon_wkt = 'POLYGON ((30 10, 10 30, 40 40)';  -- Invalid (missing closing parenthesis)

-- 9. Combination of Multiple Invalid Inputs
-- Description: This case tests multiple invalid inputs at once.
-- Expected Error: The first encountered error will be thrown (in this case, it should be Invalid country code format. It should be a 2-character ISO code.).

EXEC dbo.find_pois 
    @country_code = 'USA',  -- Invalid (3 characters instead of 2)
    @region = REPLICATE('A', 51),  -- Invalid (51 characters)
    @city = REPLICATE('Phoenix', 200),  -- Invalid (200 characters)
    @latitude = 95.0,  -- Invalid (latitude > 90)
    @longitude = -185.0,  -- Invalid (longitude < -180)
    @radius = -100.0,  -- Invalid (negative radius)
    @polygon_wkt = 'LINESTRING (30 10, 10 30, 40 40)';  -- Invalid (not a polygon)

-- Explanation:
-- Each test case checks a specific validation rule in the dbo.find_pois stored procedure.
-- The procedure should throw the corresponding custom error message for each invalid input.
-- By running these test cases, it is can ensured that the procedure correctly handles input validation and error reporting.