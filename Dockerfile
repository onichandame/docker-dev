FROM alpine:3
# FROM onichandame/epics:dev-3.15.8

COPY ./files /files
ADD run.sh /run.sh
RUN bash /run.sh
RUN rm /run.sh
RUN rm -rf /files

WORKDIR /

ENTRYPOINT ["tail", "-f", "/dev/null"]
