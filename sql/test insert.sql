INSERT INTO locations (id, parent_id, country_code, region, city, latitude, longitude, postal_code, location_name, polygon_wkt)
VALUES 
('23n-222@5zb-xdd-2p9', NULL, 'US', 'AZ', 'Phoenix', 33.503145, -112.14341, '85019', 'Grand Stop No 1', 'POLYGON ((-112.14368581999997 33.50345166000005, -112.14361815399997 33.503393430000074, -112.14356011499996 33.503439472000025, -112.14347254799998 33.50336411600006, -112.14352644199994 33.503321363000055, -112.14349061799999 33.503290535000076, -112.14336210399995 33.503392484000074, -112.14329443799994 33.50333425500003, -112.14342709899995 33.503229017000024, -112.14335943399999 33.503170787000045, -112.14316873399997 33.503322067000056, -112.14306922699996 33.50323643400003, -112.14336771199999 33.50299964900006, -112.14391699699996 33.50347233700006, -112.14376360799997 33.50359401900005, -112.14364021799997 33.50348783600003, -112.14368581999997 33.50345166000005))'),
('224-222@5zb-xcz-n89', NULL, 'US', 'AZ', 'Phoenix', 33.470846, -112.114161, '85009', 'Window World', 'POLYGON ((-112.11399637399995 33.47098191200007, -112.11399578299995 33.470713268000054, -112.11432587499996 33.47070969400005, -112.11432567799994 33.47097834600004, -112.11399637399995 33.47098191200007))'),
('222-223@5zb-xb5-5pv', NULL, 'US', 'AZ', 'Phoenix', 33.508629, -112.110162, '85015', 'Bill Luke CJDR', 'POLYGON ((-112.11037341399998 33.50876814500003, -112.10996713399999 33.50877664800004, -112.10996630999995 33.50874979500003, -112.10989318099996 33.50875132500005, -112.10988288899995 33.508415668000055, -112.11042730099996 33.50840427300005, -112.11043780099999 33.50874664400004, -112.11037279599998 33.50874800500003, -112.11037341399998 33.50876814500003))');

INSERT INTO categories (top_category, sub_category)
VALUES 
('Grocery Stores', 'Convenience Stores'),
('Building Material and Supplies Dealers', 'Home Centers'),
('Automotive Repair and Maintenance', 'Body Shops');

-- For '23n-222@5zb-xdd-2p9'
INSERT INTO pois (id, parent_id, location_id, category_id, operation_hours_id)
VALUES (
    '23n-222@5zb-xdd-2p9', 
    NULL, 
    '23n-222@5zb-xdd-2p9', 
    (SELECT id FROM categories WHERE top_category = 'Grocery Stores' AND sub_category = 'Convenience Stores'), 
    NULL
);

-- For '224-222@5zb-xcz-n89'
INSERT INTO pois (id, parent_id, location_id, category_id, operation_hours_id)
VALUES (
    '224-222@5zb-xcz-n89', 
    NULL, 
    '224-222@5zb-xcz-n89', 
    (SELECT id FROM categories WHERE top_category = 'Building Material and Supplies Dealers' AND sub_category = 'Home Centers'), 
    (SELECT id FROM operation_hours WHERE poi_id = '224-222@5zb-xcz-n89')
);

-- For '222-223@5zb-xb5-5pv'
INSERT INTO pois (id, parent_id, location_id, category_id, operation_hours_id)
VALUES (
    '222-223@5zb-xb5-5pv', 
    NULL, 
    '222-223@5zb-xb5-5pv', 
    (SELECT id FROM categories WHERE top_category = 'Automotive Repair and Maintenance' AND sub_category = 'Body Shops'), 
    (SELECT id FROM operation_hours WHERE poi_id = '222-223@5zb-xb5-5pv')
);

INSERT INTO operation_hours (poi_id, hours)
VALUES 
('224-222@5zb-xcz-n89', '{ "Mon": [["8:00", "17:00"]], "Tue": [["8:00", "17:00"]], "Wed": [["8:00", "17:00"]], "Thu": [["8:00", "17:00"]], "Fri": [["8:00", "17:00"]], "Sat": [["9:00", "15:00"]], "Sun": [] }'),
('222-223@5zb-xb5-5pv', '{ "Mon": [["8:00", "21:00"]], "Tue": [["8:00", "21:00"]], "Wed": [["8:00", "21:00"]], "Thu": [["8:00", "21:00"]], "Fri": [["8:00", "21:00"]], "Sat": [["9:00", "18:00"]], "Sun": [["10:00", "17:00"]] }');
