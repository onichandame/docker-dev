#FROM alpine:3
FROM hayd/alpine-deno:1.1.3 AS deno

FROM frolvlad/alpine-glibc:alpine-3.12
COPY --from=deno /bin/deno /bin/deno

COPY ./files /files
ADD run.sh /run.sh
RUN sh /run.sh
RUN rm /run.sh
RUN rm -rf /files
ENV ENV /root/.bashrc

WORKDIR /

ENTRYPOINT ["ash"]
