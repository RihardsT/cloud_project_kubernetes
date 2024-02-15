package main

import (
	"context"
	"github.com/go-chi/chi"
	"github.com/go-chi/render"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	log "github.com/sirupsen/logrus"
	"github.com/olivere/elastic/v7"
	"io"
	"net/http"
	"reflect"
	"strconv"
	"time"
)

type MetricbeatStuff struct {
	Timestamp             string  `json:"@timestamp"`
	Env                   string  `json:"agent.hostname"`
	StatusCode            int     `json:"system.cpu.cores"`
	BackendProcessingTime float64 `json:"host.cpu.usage"`
}

func main() {
  ESHost := "https://elastic:changeme@esi.rudenspavasaris.id.lv"
	MetricbeatStuffIndex := "metricbeat*"
	UpdateInterval := 30 * time.Second

	ctx := context.Background()
	log.Info("Connecting to ElasticSearch..")
	var client *elastic.Client
	for {
		esClient, err := elastic.NewClient(elastic.SetURL(ESHost), elastic.SetSniff(false))
		if err != nil {
			log.Errorf("Could not connect to ElasticSearch: %v\n", err)
			time.Sleep(1 * time.Second)
			continue
		}
		client = esClient
		break
	}

	info, _, err := client.Ping(ESHost).Do(ctx)
	if err != nil {
		log.Fatalf("Could not ping ElasticSearch %v", err)
	}
	log.Infof("Connected to ElasticSerach with version %s\n", info.Version.Number)

	statusCodeCollector := prometheus.NewCounterVec(prometheus.CounterOpts{
		Name: "gateway_status_code",
		Help: "Status Code of Gateway",
	}, []string{"env", "statuscode", "type"})

	responseTimeCollector := prometheus.NewSummaryVec(prometheus.SummaryOpts{
		Name: "gateway_response_time",
		Help: "Response Time of Gateway",
	}, []string{"env"})

	if err := prometheus.Register(statusCodeCollector); err != nil {
		log.Fatal(err, "could not register status code 500 collector")
	}
	if err := prometheus.Register(responseTimeCollector); err != nil {
		log.Fatal(err, "could not register response time collector")
	}

	// fetch data
	fetchDataFromElasticSearch(
		ctx,
		UpdateInterval,
		MetricbeatStuffIndex,
		client,
		statusCodeCollector,
		responseTimeCollector,
	)

	r := chi.NewRouter()
	r.Use(render.SetContentType(render.ContentTypeJSON))
	r.Handle("/metrics", promhttp.Handler())

	log.Infof("Server started on localhost:8092")
	log.Fatal(http.ListenAndServe(":8092", r))
}

func fetchDataFromElasticSearch(
	ctx context.Context,
	UpdateInterval time.Duration,
	MetricbeatStuffIndex string,
	client *elastic.Client,
	statusCodeCollector *prometheus.CounterVec,
	responseTimeCollector *prometheus.SummaryVec,
) {
	ticker := time.NewTicker(UpdateInterval)
	go func() {
		for range ticker.C {
			now := time.Now()
			lastUpdate := now.Add(-UpdateInterval)

			rangeQuery := elastic.NewRangeQuery("@timestamp").
				Gte(lastUpdate).
				Lte(now)

			log.Info("Fetching from ElasticSearch...")
			scroll := client.Scroll(MetricbeatStuffIndex).
				Query(rangeQuery).
				Size(5000)

			scrollIdx := 0
			for {
				res, err := scroll.Do(ctx)
				if err == io.EOF {
					break
				}
				if err != nil {
					log.Errorf("Error while fetching from ElasticSearch: %v", err)
					break
				}
				scrollIdx++
				log.Infof("Query Executed, Hits: %d TookInMillis: %d ScrollIdx: %d", res.TotalHits(), res.TookInMillis, scrollIdx)
				var typ MetricbeatStuff
				for _, item := range res.Each(reflect.TypeOf(typ)) {
					if l, ok := item.(MetricbeatStuff); ok {
						handleLogResult(l, statusCodeCollector, responseTimeCollector)
						log.Infof("Env: %s Cores: %d CPU: %f", l.Env, l.StatusCode, l.BackendProcessingTime)
					}
				}
			}
		}
	}()
}

func handleLogResult(l MetricbeatStuff, statusCodeCollector *prometheus.CounterVec, responseTimeCollector *prometheus.SummaryVec) {
	trackStatusCodes(statusCodeCollector, l.StatusCode, l.Env)
	responseTimeCollector.WithLabelValues(l.Env).Observe(l.BackendProcessingTime)
}

func trackStatusCodes(statusCodeCollector *prometheus.CounterVec, statusCode int, env string) {
	statusCodeCollector.WithLabelValues(env, strconv.Itoa(statusCode), "500").Inc()
}
