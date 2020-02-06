import sys
import time
import boto3
from botocore.handlers import disable_signing
import gzip
from warcio.archiveiterator import ArchiveIterator
from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, StructField, LongType, StringType, BooleanType


def s3_ingest(spark):
  """ ingest WARC file from S3 bucket """

  schema_db = StructType([
    StructField('ip', StringType(), True),
    StructField('domain', StringType(), True),
    StructField('webserver', StringType(), True),
    StructField('https', BooleanType(), True),
    StructField('full_url', StringType(), True)
  ])

  s3 = boto3.resource('s3')
  s3.meta.client.meta.events.register('choose-signer.s3.*', disable_signing)
  bucket = 'commoncrawl'

  with open('warc.paths', 'r') as f:
    idx = 0
    keys = f.readlines()

    for key in keys:
      s3_obj = s3.Object(bucket, key.rstrip())
      idx += 1
      print('##########################')
      print('Proccessing WARC file: ', idx)
      print('##########################')

      # combine boto3 and gzip functionality to stream file
      with gzip.GzipFile(fileobj=s3_obj.get()['Body'], mode='rb') as stream:
        insert_values = []

        for record in ArchiveIterator(stream):
          if record.rec_type == 'response':
            if record.http_headers.get_header('Content-Type') == 'text/html':
              ip = record.rec_headers.get_header('WARC-IP-Address')
              domain, https = extract_domain(record.rec_headers.get_header('WARC-Target-URI'))
              webserver = record.http_headers.get_header('Server')
              full_url = record.rec_headers.get_header('WARC-Target-URI')

              if webserver:
                webserver_strip = webserver.strip().lower()
              else:
                webserver_strip = webserver

              insert_values.append([ip \
                                    , domain[:100] \
                                    , webserver_strip \
                                    , https \
                                    , full_url[:2083]])

      df = spark.createDataFrame(insert_values, schema=schema_db)

      df.write \
      .format('jdbc') \
      .option('url', 'jdbc:postgresql://{cluster_ip}:5432/{db_name}') \
      .option('dbtable', '{db_table}') \
      .option('user', '{user}') \
      .option('driver', 'org.postgresql.Driver') \
      .mode('append') \
      .save()


def extract_domain(url):
  """ remove lead and tail text from domain """

  # flag https websites for later analysis
  https = url.count('https') 
  url = url.replace('http://', '').replace('https://', '')
  if '/' in url:
    url = url.split('/')[0].replace('www.', '')
  else:
    url = url.replace('www.', '')
  return url, bool(https)


def main():
  spark = SparkSession \
    .builder \
    .master('spark://{cluster_master}') \
    .appName('pyspark-s3-to-db') \
    .getOrCreate()
  start_time = time.time()
  s3_ingest(spark)
  end_time = time.time()
  print('\n##########################')
  print(' Finished job in {0:.2f} hr.mins'.format((end_time - start_time)/3600))
  print('##########################\n')

if __name__ == '__main__':
  main()
