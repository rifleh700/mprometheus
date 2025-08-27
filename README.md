# mprometheus
MTA:SA metrics system + prometheus exporter

![screenshot](https://i.imgur.com/todhdRn.png)

## Quick start
1. Download Prometheus [(link)](https://prometheus.io/download/) and unpack ZIP
2. Go to unpacked folder and configure `prometheus.yml`:
   - find `scrape_configs` block
   - add `metrics_path` property
   - put your server's `host:HTTP-port` to `targets` property

```yaml
scrape_configs:
  - job_name: "prometheus"

    metrics_path: "/mprometheus/metrics"

    static_configs:
      - targets: ["localhost:22005"]
        labels:
          app: "prometheus"

    # U also can use MTA user login and password for simple auth.
    # This account must have ACL right <right name="resource.mprometheus.http" access="true"></right>
    # We'll add this right by default for all
    #basic_auth:
    #  username: 1337
    #  password: 1337
```
3. Add ACL right to `Default` acl (or use simple HTTP auth instead with specific account)
```xml
<acl name="Default">
    <right name="resource.mprometheus.http" access="true"></right>
```
(reload ACL with `reloadacl` command in server console or restart the server)

4. Download and start `mprometheus` resource
5. Check this url in your browser http://localhost:22005/mprometheus/metrics (u must see not blank page) 
6. Run `prometheus.exe`
7. Check this url in your browser http://localhost:9090/
    - type `server_info` query and press `execute`
    - u must see result likes `server_info{app="prometheus", instance="localhost:22005", job="prometheus", min_client_version="1.6.0-9.23324.0", platform="Windows", version="1.6.0-9.23324.0"}`
8. Download Grafana [(link)](https://grafana.com/grafana/download?edition=oss) and install it (or unpack archive)
9. Run Grafana or start `bin/grafana-server.exe`
10. Open http://localhost:3000 in your browser and login (`admin`:`admin` by default)
11. Press button `Add your first data source`
    - click `Prometheus`
    - type name `mta_prometheus`
    - type url http://localhost:9090
    - scroll down and press `save & test`
12. Go home and press `Create your first dashboard`
    - `Import dashboard` (discard)
    - `Upload dashboard JSON file`
    - find file `MTA_Server_Grafana.json` in `mprometheus` resource [(or just download it separately)](https://raw.githubusercontent.com/rifleh700/mprometheus/refs/heads/main/MTA_Server_Grafana.json) and choose it

## Exported server-side function
- `boolean registerCounter(string name [, string description])`
- `boolean registerGauge(string name [, string description])`
- `boolean registerSummary(string name [, string description])`
- `boolean addCounterValue(string name, float value [, table labels])`
- `boolean setCounterValue(string name, float value [, table labels])`
- `boolean setGaugeValue(string name, float value [, table labels])`
- `boolean addSummaryValue(string name, float value [, table labels])`