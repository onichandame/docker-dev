#FROM alpine:3
FROM hayd/alpine-deno:1.1.3

COPY ./files /files
ADD run.sh /run.sh
RUN sh /run.sh
RUN rm /run.sh
RUN rm -rf /files
ENV ENV /root/.bashrc

WORKDIR /

ENTRYPOINT ["tail", "-f", "/dev/null"]
