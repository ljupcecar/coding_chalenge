import pandas as pd
import os

# Define the base paths using relative paths
base_dir = os.path.abspath(os.path.dirname(__file__))
csv_dir = os.path.join(base_dir, '..', 'csv')
output_dir = os.path.join(base_dir)

# Read the original CSV file
csv_file_path = os.path.join(csv_dir, 'phoenix.csv')
df = pd.read_csv(csv_file_path)

# Create the Locations Table
locations_df = df[['id', 'location_name', 'postal_code', 'latitude', 'longitude', 'city', 'region', 'country_code']].drop_duplicates()

# Create the Categories Table
categories_df = df[['top_category', 'sub_category', 'category_tags']].drop_duplicates().reset_index(drop=True)
categories_df['category_id'] = categories_df.index + 1  # Create a unique ID for each category

# Create the Brands Table
brands_df = df[['brand_id', 'brand']].drop_duplicates().reset_index(drop=True)

# Create the Operation Hours Table
operation_hours_df = df[['id', 'operation_hours']].drop_duplicates()

# Create the Geometry Table
geometry_df = df[['id', 'geometry_type', 'polygon_wkt']].drop_duplicates()

# Create the Primary Locations Table
primary_locations_df = df[['id', 'parent_id', 'brand_id', 'top_category']].copy()
primary_locations_df = primary_locations_df.merge(categories_df[['top_category', 'category_id']], on='top_category', how='left')

# Save to CSV files in the output directory
locations_df.to_csv(os.path.join(output_dir, 'locations.csv'), index=False)
categories_df.to_csv(os.path.join(output_dir, 'categories.csv'), index=False)
brands_df.to_csv(os.path.join(output_dir, 'brands.csv'), index=False)
operation_hours_df.to_csv(os.path.join(output_dir, 'operation_hours.csv'), index=False)
geometry_df.to_csv(os.path.join(output_dir, 'geometry.csv'), index=False)
primary_locations_df.to_csv(os.path.join(output_dir, 'primary_locations.csv'), index=False)

print("Normalization completed and CSV files saved.")
