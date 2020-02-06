spark-submit \
  spark_s3.py \
  --master local[*] \
  --deploy-mode cluster \
  --supervise \
  --executor-memory 8G \
  --total-executor-cores 4 \
