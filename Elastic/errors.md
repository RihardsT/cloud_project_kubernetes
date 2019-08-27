# Kibana
```
Unable find saved objects
Bad request
```
This popped up after deleting .kibana index.  
In my case this required two restarts of Kibana.  
One to make Kibana recreate/migrate the index - this still didn't get Kibana up.  
Second restart got Kibana up and loaded the restored index.  
Issue somewhat related to https://github.com/elastic/kibana/issues/26845



```
"error":{"root_cause":[{"type":"illegal_argument_exception","reason":"Invalid interval specified, must be non-null and non-empty"}]
```
On Elastic Stack version 7.3.1.
Error when opening default `[Metricbeat System] Overview ECS` dashboard after setup.
Issue with `Hosts histogram by CPU usage [Metricbeat System] ECS` visualization
Fix:
Open `Hosts histogram by CPU usage [Metricbeat System] ECS` visualization,
Change `Minimum interval` to Minute
Save

Same with `Disk used`, `Disk usage`, `Disk IO`, `Packetloss` visualizations,
which have Interval set to `auto`.
Change those to 1m and be done with it for now.
