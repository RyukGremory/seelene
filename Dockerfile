FROM python:slim-bullseye AS downloader
RUN apt update && apt install -y wget unzip
RUN wget -O /tmp/ic_basic.zip https://download.oracle.com/otn_software/linux/instantclient/1916000/instantclient-basic-linux.x64-19.16.0.0.0dbru.zip
RUN wget -O /tmp/ic_sqlplus.zip https://download.oracle.com/otn_software/linux/instantclient/1916000/instantclient-sqlplus-linux.x64-19.16.0.0.0dbru.zip
RUN wget -O /tmp/ic_tools.zip https://download.oracle.com/otn_software/linux/instantclient/1916000/instantclient-tools-linux.x64-19.16.0.0.0dbru.zip
RUN unzip -o "/tmp/*.zip"


FROM python:slim-bullseye AS seelene
RUN apt update && apt install -y libaio1
ENV ORACLE_HOME="/opt/oracle/"
ENV PATH="$PATH:${ORACLE_HOME}"
ENV LD_LIBRARY_PATH="${ORACLE_HOME}"
ENV TNS_ADMIN="${ORACLE_HOME}network/admin"
RUN mkdir ${ORACLE_HOME}
RUN mkdir /app
COPY requirements.txt /app/
RUN pip install -r /app/requirements.txt
COPY --from=downloader /instantclient_19_16/ ${ORACLE_HOME}
COPY ./tnsnames.ora ${TNS_ADMIN}