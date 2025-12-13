# Base Image
FROM apache/spark:3.5.3

USER root

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    tini \
    && rm -rf /var/lib/apt/lists/*

COPY config/spark/jars /opt/spark/jars/
COPY config/spark/spark-defaults.conf /opt/spark/conf/spark-defaults.conf

COPY requirements.txt /opt/spark/requirements.txt
RUN pip3 install -r /opt/spark/requirements.txt jupyterlab notebook

RUN mkdir -p /workspace

EXPOSE 8080 8888

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["bash"]