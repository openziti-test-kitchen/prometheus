FROM golang
ENV GO111MODULE=on
#ENV APP_USER=appuser
#ENV APP_GROUP=appgroup
#ENV APP_HOME=/app
#ARG GROUP_ID=1000
#ARG USER_ID=1000
#RUN groupadd --gid $GROUP_ID $APP_GROUP && useradd -m -l --uid $USER_ID --gid $GROUP_ID $APP_USER
#RUN mkdir -p $APP_HOME
#RUN chown -R $APP_USER:$APP_GROUP $APP_HOME
#RUN chmod -R 0777 $APP_HOME
#USER $APP_USER
ARG ARCH="amd64"
ARG OS="linux"
WORKDIR /prometheus
ADD . /prometheus
RUN mkdir -p /etc/prometheus
RUN go mod download
COPY documentation/examples/prometheus.yml  /etc/prometheus/prometheus.yml
RUN go build -o prometheus ./cmd/prometheus/main.go
RUN ln -s /usr/share/prometheus/console_libraries /usr/share/prometheus/consoles/ /etc/prometheus/ && \
    chown -R nobody:nogroup /etc/prometheus /prometheus
USER nobody
EXPOSE     9090 	
VOLUME     [ "/prometheus" ]
ENTRYPOINT [ "./prometheus" ]
CMD        [ "--config.file=/etc/prometheus/prometheus.yml", \
             "--storage.tsdb.path=/prometheus", \
             "--web.console.libraries=/usr/share/prometheus/console_libraries", \
             "--web.console.templates=/usr/share/prometheus/consoles" ]
