# Spark Template

Spark local/dev template using Docker Compose. This repo provides a simple way to run Apache Spark locally, mount code and data, and customize Spark via config and additional jars.

## Features
- Dockerized Spark for consistent local/dev runs
- Configurable Spark via `config/spark/spark-defaults.conf`
- Drop-in extra jars in `config/spark/jars/`
- Source code mounted from `src/`
- Persistent data volume under `storage/`

## Quick Start
1. Build the image:
```bash
docker build -t spark-test .
```
2. Start the stack:
```bash
docker compose up --build -d
```
3. Check containers:
```bash
docker ps
```

You can access Spark UI in your browser: `http://localhost:8080` 

## Project Structure
- `docker-compose.yml`: Orchestrates Spark services and volumes.
- `Dockerfile`: Builds the Spark runtime image with dependencies.
- `requirements.txt`: Python dependencies installed into the image/container.
- `config/spark/spark-defaults.conf`: Spark configuration overrides.
- `config/spark/jars/`: Place extra connector jars (e.g., Postgres, Delta, S3).
- `src/`: Your Spark application code (jobs, utils, notebooks if mounted).
- `storage/`: Persistent local data volume mounted into containers.

## Configuration
Spark defaults can be customized in `config/spark/spark-defaults.conf`. 
Place any required jars (e.g., JDBC drivers, Delta Lake) into `config/spark/jars/`. They will be available to Spark at runtime per the image/compose setup.

## Jupyter Usage
- Jupyter Lab runs in the `jupyter` container and serves on `http://localhost:8888`.
- The local `notebooks/` directory is mounted to `/workspace` in the container.

## Spark Tests
```python
from pyspark.sql import SparkSession

spark = (
    SparkSession.builder
    .appName("spark-test")
    .master("spark://spark-master:7077")
    .getOrCreate()
)

data = spark.range(5)
data.show()
```

Delta example:
```python
data.write.format("delta").mode("overwrite").save("/data/delta_test")
spark.read.format("delta").load("/data/delta_test").show()
```