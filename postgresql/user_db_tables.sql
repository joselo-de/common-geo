-- sql scripts to create database and tables
-- psql (PostgreSQL) 10.10 (Ubuntu 10.10-0ubuntu0.18.04.1)
--########################################################

-- First, create the db user
CREATE USER developer WITH
LOGIN
SUPERUSER
CREATEDB
CREATEROLE
INHERIT
NOREPLICATION
PASSWORD '#######';


-- create database with default options
CREATE DATABASE common_geolite
OWNER =  developer
ENCODING = 'UTF8'
TEMPLATE = template0
LC_COLLATE = 'C'
LC_CTYPE = 'C'
TABLESPACE = pg_default
CONNECTION LIMIT = -1;


-- connect to the recently created database with the command "\c"
-- then create the tables
\c common_geolite;

CREATE TABLE IF NOT EXISTS city_locations
(
  geoname_id NUMERIC NOT NULL,
  locale_code CHAR(5),
  continent_code CHAR(5),
  continent_name CHAR(15),
  country_iso_code CHAR(5),
  country_name CHAR(50),
  subdivision_1_iso_code CHAR(5),
  subdivision_1_name CHAR(40),
  subdivision_2_iso_code CHAR(5),
  subdivision_2_name CHAR(40),
  city_name CHAR(100),
  metro_code CHAR(5),
  time_zone CHAR(50),
  is_in_european_union NUMERIC,
  CONSTRAINT geoname_pkey PRIMARY KEY (geoname_id)
);


CREATE TABLE IF NOT EXISTS network_blocks
(
  network CHAR(25),
  geoname_id NUMERIC REFERENCES city_locations(geoname_id),
  registered_country_geoname_id NUMERIC,
  represented_country_geoname_id NUMERIC,
  is_anonymous_proxy BOOLEAN,
  is_satellite_provider BOOLEAN,
  postal_code CHAR(10),
  latitude NUMERIC,
  longitude NUMERIC,
  accuracy_radius NUMERIC,
  center_point CHAR(25)
);


-- use the COPY command to populate the tables
COPY city_locations (geoname_id,locale_code,continent_code,continent_name,country_iso_code,country_name,subdivision_1_iso_code,subdivision_1_name,subdivision_2_iso_code,subdivision_2_name,city_name,metro_code,time_zone,is_in_european_union) FROM 'geolite2.ipv4_city_locations' DELIMITER ',' CSV HEADER;

COPY network_blocks (network,geoname_id,registered_country_geoname_id,represented_country_geoname_id,is_anonymous_proxy,is_satellite_provider,postal_code,latitude,longitude,accuracy_radius,center_point) FROM 'geolite2.ipv4_city_blocks' DELIMITER ',' CSV HEADER;


-- query for Insight's zipcode
-- select nb.network,cl.country_iso_code,cl.city_name from network_blocks nb join city_locations cl on nb.geoname_id = cl.geoname_id where nb.postal_code='10016';

-- network             | country_iso_code |               city_name   
---------------------------+------------------+----------------------------
-- 2.56.114.0/23       | US               | Nueva York 
-- 5.182.118.0/23      | US               | Nueva York    
-- 45.90.198.0/23      | US               | Nueva York  
-- 45.91.10.0/23       | US               | Nueva York   
-- 169.47.26.128/25    | US               | Nueva York 
-- 185.168.97.0/24     | IT               | 
-- 31.12.71.0/24       | US               | Nueva York   
-- 88.147.29.128/25    | IT               | 
-- 217.57.156.0/23     | IT               | 
-- 24.193.0.0/21       | US               | Nueva York 


CREATE TABLE IF NOT EXISTS crawled_domains
(
  website_id BIGSERIAL PRIMARY KEY,
  ip CHAR(20),
  domain VARCHAR(100),
  webserver VARCHAR(250),
  https BOOLEAN,
  full_url VARCHAR(2083)
);
