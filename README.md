## CommonCrawlMap: A visual representation of the Internet
### Jose L Garcia
### January, 2020

* This project is aimed to show a world map with the general location of websites using http communications, compared to the websites using https.

* It also aggregates the data to show market share of internet servers across countries.

* The data pipeline uses Spark to parse the files stored in the Common Crawl repository and extract infomation such as Domain, IP Address, Webserver. These IP Addresses are stored into PostgreSQL and later joined with the Geolite database.

* The results are presented in a choroplet showing general locations of webpages among other data.

 ![image](img/pipeline-spark-pgsql.png)
