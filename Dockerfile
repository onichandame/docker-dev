FROM centos:8

COPY ./files /files
ADD run.sh /run.sh
RUN bash /run.sh
RUN rm /run.sh
RUN rm -rf /files

WORKDIR /
