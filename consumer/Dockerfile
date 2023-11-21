FROM docker.io/bitnami/spark:3.3

COPY . .

CMD ["spark-submit", "--packages", "org.apache.spark:spark-sql-kafka-0-10_2.12:3.3.0", "/src/read_test_stream.py"]