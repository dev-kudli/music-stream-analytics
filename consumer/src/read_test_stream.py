import os

from pyspark.sql import SparkSession
from pyspark.sql.functions import from_json, col, month, hour, dayofmonth, col, year, current_timestamp

from schema import schema

spark = SparkSession.builder.appName("read_test_straeam").getOrCreate()

print('output', os.getenv('KAFKA_TOPICS'))

# Reduce logging
spark.sparkContext.setLogLevel("WARN")

read_stream = (spark.readStream
                .format("kafka")
                .option("kafka.bootstrap.servers", os.getenv("KAFKA_BOOTSTRAP_SERVERS"))
                .option("failOnDataLoss", False)
                .option("startingOffsets", "earliest")
                .option("subscribe", os.getenv("KAFKA_TOPICS"))
                .load())

stream = (read_stream
            .selectExpr("CAST(value AS STRING)")
            .select(
                from_json(col("value"), schema["auth_events"]).alias("data")
            )
            .select("data.*")
            )

stream = stream.withColumn("spark_timestamp", current_timestamp())
# stream = stream.withColumn("zip_int", stream["zip"].cast(IntegerType()))

# Add month, day, hour to split the data into separate directories
stream = (stream
            .withColumn("year", year(col("spark_timestamp")))
            .withColumn("month", month(col("spark_timestamp")))
            .withColumn("day", dayofmonth(col("spark_timestamp")))
            .withColumn("hour", hour(col("spark_timestamp"))+1)
            )

write_stream = (stream
                .writeStream
                .format(os.getenv("OUTPUT_FORMAT"))
                .queryName("auth_events_query")
                .partitionBy("year", "month", "day", "hour")
                .option("path", "/src/output/")
                .option("checkpointLocation", os.getenv("CHECKPOINT_LOCATION"))
                .trigger(processingTime=os.getenv("PROCESSING_TIME"))
                .outputMode(os.getenv("OUTPUT_MODE"))
                .start())

write_stream.awaitTermination()

# spark-submit --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.3.0 /src/streaming/read_test_stream.py

# write_console = (stream
#     .writeStream \
#     .format("console") \
#     .outputMode("append") \
#     .start() \
#     .awaitTermination())