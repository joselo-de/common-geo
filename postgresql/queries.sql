-- basic queries

-- top 10 non-secure
select webserver, https, count(webserver) from crawled_domains where https=True group by 1,2 order by 3 desc limit 10;
 webserver            | https |  count  
----------------------+-------+----------
 microsoft-iis/7.5    | f     | 17236023
 apache               | f     | 13749130
 nginx                | f     | 11514732
 cloudflare           | f     |  8208497
 microsoft-iis/8.5    | f     |  5886983
 microsoft-iis/6.0    | f     |  1867185
 nginx/1.4.6 (ubuntu) | f     |   990030
 apache/2             | f     |   924569
 microsoft-iis/10.0   | f     |   793310
 litespeed            | f     |   761886
(10 rows)


-- top 10 secure
select webserver, https, count(webserver) from crawled_domains where https=False group by 1,2 order by 3 desc limit 10;
            webserver            | https |  count  
---------------------------------+-------+---------
 apache                          | t     | 7840619
 nginx                           | t     | 5160653
 cloudflare                      | t     | 5022717
 microsoft-iis/8.5               | t     | 3333459
 microsoft-iis/10.0              | t     |  974893
 apache/2.4.7 (ubuntu)           | t     |  610450
 microsoft-iis/7.5               | t     |  595025
 litespeed                       | t     |  529835
 amazons3                        | t     |  494542
 webfronts clustering web server | t     |  485530
(10 rows)


-- secure domains, by page volume 
select domain, count(domain) from crawled_domains where https=True group by 1 order by 2 desc limit 20; 
          domain          | count 
--------------------------+-------
 patents.google.com       | 65069
 docs.microsoft.com       | 63966
 bloomberg.com            | 53156
 po.st                    | 51902
 mobile.baidu.com         | 40796
 soundcloud.com           | 38109
 m.v.qq.com               | 30910
 developers.weixin.qq.com | 30691
 windy.com                | 30395
 skyrock.com              | 28840
 lbs-to-kg.appspot.com    | 27315
 biblehub.com             | 26874
 aljazeera.com            | 22356
 twitch.tv                | 21241
 bustle.com               | 21122
 api.parliament.uk        | 20759
 kiki.huh.harvard.edu     | 20093
 thesimsresource.com      | 19209
 exblog.jp                | 18847
 grubhub.com              | 18791
(20 rows)


select domain, count(domain) from crawled_domains where https=False group by 1 order by 2 desc limit 20;
           domain           | count 
----------------------------+-------
 s3-us-west-1.amazonaws.com | 47829
 stats.washingtonpost.com   | 25412
 xinhuanet.com              | 24427
 cisbp.ccbr.utoronto.ca     | 23240
 mini.opera.com             | 21428
 link.law.upenn.edu         | 21127
 teamzeroabsolu.free.fr     | 18860
 john.bonobo.free.fr        | 18563
 nucleus.com.ru             | 18520
 decouvrirlemonde.free.fr   | 18487
 money.finance.sina.com.cn  | 18455
 ent.sina.com.cn            | 18000
 thepeerage.com             | 17938
 lemercuredegaillon.free.fr | 17852
 data.auto.sina.com.cn      | 17827
 onlineraceresults.com      | 17742
 dtcgalerie.free.fr         | 17466
 cokefan.free.fr            | 17410
 e-darake.sakura.ne.jp      | 17366
 supfam.mrc-lmb.cam.ac.uk   | 17310
(20 rows)


-- are there more S3 buckets in our data? How only West Coast made it to the top?   
select domain, count(domain) from crawled_domains where domain like 's3%amazon%' group by 1 order by 2 desc;
                                          domain                                           | count 
-------------------------------------------------------------------------------------------+-------
 s3-us-west-1.amazonaws.com                                                                | 50133
 s3.amazonaws.com                                                                          | 24358
 s3.ap-northeast-2.amazonaws.com                                                           |  2897
 s3.ca-central-1.amazonaws.com                                                             |  1612
 s3-us-west-2.amazonaws.com                                                                |   915
 s3-eu-central-1.amazonaws.com                                                             |   460
 s3-eu-west-1.amazonaws.com                                                                |   294
 s3.eu-west-3.amazonaws.com                                                                |   212
 s3.us-east-2.amazonaws.com                                                                |   212
 s3-us-east-2.amazonaws.com                                                                |   116
 s3-ap-northeast-1.amazonaws.com                                                           |    21
 s3.eu-central-1.amazonaws.com                                                             |     9
 s3.ap-south-1.amazonaws.com                                                               |     9
 s3-ap-southeast-2.amazonaws.com                                                           |     8
 s3.ap-southeast-1.amazonaws.com                                                           |     7
 s3.dualstack.us-west-1.amazonaws.com                                                      |     5
 s3-service-broker-live-e0de1db2-92c6-4eaa-bea1-b061bb5127bf.s3.eu-central-1.amazonaws.com |     1
 s3.ap-northeast-1.amazonaws.com                                                           |     1
(18 rows)

-- No. All the S3 zones are represented, but somehow only us-west is exploiting the fact that you can siet up an S3 bucket as a webserver for static content

