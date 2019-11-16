FROM amancevice/superset
USER root
# Oracle instantclient
ADD oracle/instantclient-basic-linux.x64-11.2.0.4.0.zip /tmp/instantclient-basic-linux.x64-11.2.0.4.0.zip
ADD oracle/instantclient-sdk-linux.x64-11.2.0.4.0.zip /tmp/instantclient-sdk-linux.x64-11.2.0.4.0.zip
ADD oracle/instantclient-sqlplus-linux.x64-11.2.0.4.0.zip /tmp/instantclient-sqlplus-linux.x64-11.2.0.4.0.zip

RUN apt-get update -y && apt-get install -y unzip

RUN unzip /tmp/instantclient-basic-linux.x64-11.2.0.4.0.zip -d /usr/local/
RUN unzip /tmp/instantclient-sdk-linux.x64-11.2.0.4.0.zip -d /usr/local/
RUN unzip /tmp/instantclient-sqlplus-linux.x64-11.2.0.4.0.zip -d /usr/local/
RUN ln -s /usr/local/instantclient_11_2 /usr/local/instantclient
RUN ln -s /usr/local/instantclient/libclntsh.so.11.1 /usr/local/instantclient/libclntsh.so
RUN ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus

ENV TERM=vt100
ENV ORACLE_HOME="/usr/local/instantclient"
ENV LD_LIBRARY_PATH="/usr/local/instantclient"
RUN export PATH=$PATH:/usr/local/instantclient/bin

RUN echo '/usr/local/instantclient/' | tee -a /etc/ld.so.conf.d/oracle_instant_client.conf && ldconfig

RUN apt-get install libaio-dev libsasl2-dev libldap2-dev -y && apt-get clean -y

RUN pip install -i http://pypi.douban.com/simple/ --trusted-host=pypi.douban.com/simple  --no-cache-dir cx_Oracle 
