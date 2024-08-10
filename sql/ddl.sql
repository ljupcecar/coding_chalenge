-- Create the 'locations' table
CREATE TABLE locations (
    id VARCHAR(50) PRIMARY KEY,  -- Primary Key
    parent_id VARCHAR(50) NULL,
    country_code VARCHAR(10) NOT NULL,
    region VARCHAR(50) NOT NULL,
    city VARCHAR(100) NOT NULL,
    latitude DECIMAL(10, 7) NOT NULL,
    longitude DECIMAL(10, 7) NOT NULL,
    postal_code VARCHAR(10) NOT NULL,
    location_name VARCHAR(255) NOT NULL,
    polygon_wkt NVARCHAR(MAX) NULL
);

-- Create indexes for 'locations' table
CREATE INDEX idx_locations_country_code ON locations(country_code);
CREATE INDEX idx_locations_region ON locations(region);
CREATE INDEX idx_locations_city ON locations(city);
CREATE INDEX idx_locations_lat_long ON locations(latitude, longitude);

-- Create the 'categories' table
CREATE TABLE categories (
    id INT IDENTITY(1,1) PRIMARY KEY,  -- Primary Key
    top_category VARCHAR(100) NOT NULL,
    sub_category VARCHAR(100) NULL
);

-- Create indexes for 'categories' table
CREATE INDEX idx_categories_top_category ON categories(top_category);

-- Create the 'operation_hours' table
CREATE TABLE operation_hours (
    id INT IDENTITY(1,1) PRIMARY KEY,  -- Primary Key
    poi_id VARCHAR(50) NOT NULL,       -- Foreign Key
    hours NVARCHAR(MAX) NULL
);

-- Create the 'pois' table
CREATE TABLE pois (
    id VARCHAR(50) PRIMARY KEY,  -- Primary Key
    parent_id VARCHAR(50) NULL,
    location_id VARCHAR(50) NOT NULL,  -- Foreign Key
    category_id INT NOT NULL,          -- Foreign Key
    operation_hours_id INT NULL        -- Foreign Key
);

-- Add foreign key constraints to 'pois' table
ALTER TABLE pois
ADD CONSTRAINT FK_pois_location_id FOREIGN KEY (location_id) 
REFERENCES locations(id);

ALTER TABLE pois
ADD CONSTRAINT FK_pois_category_id FOREIGN KEY (category_id) 
REFERENCES categories(id);

ALTER TABLE pois
ADD CONSTRAINT FK_pois_operation_hours_id FOREIGN KEY (operation_hours_id) 
REFERENCES operation_hours(id);

-- Add foreign key constraint to 'operation_hours' table0
ALTER TABLE operation_hours
ADD CONSTRAINT FK_operation_hours_poi_id FOREIGN KEY (poi_id) 
REFERENCES pois(id);

-- Create indexes for 'pois' table
CREATE INDEX idx_pois_location_id ON pois(location_id);
CREATE INDEX idx_pois_category_id ON pois(category_id);
CREATE INDEX idx_pois_operation_hours_id ON pois(operation_hours_id);
CREATE INDEX idx_pois_parent_id ON pois(parent_id);
