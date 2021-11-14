https://www.zupzup.org/go-elasticsearch-prometheus-exporter/index.html

### Init and build
docker run --rm --name es-to-prom -ti -v ${PWD}:/d -w /d golang:1.17.3-alpine3.14 sh
go mod init elastic-to-prometheus
go mod tidy

go get -d -v ./...
go build -v

### Run
docker run --rm --name es-to-prom -p 8092:8092 -ti -v ${PWD}:/d -w /d golang:1.17.3-alpine3.14 /d/elastic-to-prometheus

curl localhost:8092/metrics
