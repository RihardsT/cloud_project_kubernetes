kubectl exec -it netdata-pub-TAB -- netdata-claim.sh -token=CVgwu8M2-ZCRJrZhSVK-aqRi-9L62_WpUNF7zkvR7ykAeZjgEhGwf6QHeHn7o5CnCk5et_EcnVH3ev2HW0nFcRRkywAh2qb2dfUTt0GB5GYAEAdiw4H7aJBVu9CgrrcO6cEF2v4 -rooms=54b3c884-7150-4e64-9513-5f384065e70d -url=https://app.netdata.cloud


helm repo add netdata https://netdata.github.io/helmchart/
helm install netdata netdata/netdata

helm delete netdata
