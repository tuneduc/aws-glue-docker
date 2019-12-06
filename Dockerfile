from zenika/alpine-maven:3

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV SPARK_URL https://aws-glue-etl-artifacts.s3.amazonaws.com/glue-1.0/spark-2.4.3-bin-hadoop2.8.tgz
ENV SPARK_HOME /opt/spark-2.4.3-bin-spark-2.4.3-bin-hadoop2.8
ENV PYTHON_VERSION 3.6.9
ENV PYENV_ROOT /opt/.pyenv
ENV GLUE_HOME /opt/aws-glue-libs
ENV PATH $SPARK_HOME/bin:$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH
ENV PYTHONPATH /opt/aws-glue-libs/:$SPARK_HOME/python/:$SPARK_HOME/python/lib/py4j-0.10.7-src.zip

RUN apk add --update curl git bash openssl openssl-dev bzip2-dev build-base \
                     zlib-dev readline-dev sqlite-dev libc6-compat && \
    rm -f /var/cache/apk/*

WORKDIR /opt

RUN git clone --depth 1 https://github.com/pyenv/pyenv.git $PYENV_ROOT && \
    rm -rfv $PYENV_ROOT/.git && \
    pyenv install $PYTHON_VERSION && pyenv global $PYTHON_VERSION && pyenv rehash

RUN wget $SPARK_URL && tar -xzf *.tgz && rm *.tgz

RUN git clone https://github.com/awslabs/aws-glue-libs $GLUE_HOME && \
    # Checking out current head of Glue 1.0 branch
    cd $GLUE_HOME && git checkout 4f6ac89

RUN mvn -f $GLUE_HOME/pom.xml -DoutputDirectory=$GLUE_HOME/jars dependency:copy-dependencies

# Bodge (https://github.com/awslabs/aws-glue-libs/issues/25)
RUN rm $GLUE_HOME/jars/netty-* $GLUE_HOME/jars/javax.servlet-3.* && \
    echo -n "spark.driver.extraClassPath $GLUE_HOME/jars/*" > $SPARK_HOME/conf/spark-defaults.conf

WORKDIR /root
