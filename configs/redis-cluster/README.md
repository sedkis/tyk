In order to use Redis in Cluster mode, add the following bits to your respective config files:

### pump.conf

```
"analytics_storage_config": {
    "type": "redis",
    "enable_cluster": true,
    "addrs": [
        "redis-cluster.default.svc.cluster.local:6379"
     ],
    ...
}
```

### tyk_analytics.conf
```
"enable_cluster": true,
"redis_addrs": [
    "redis-cluster.default.svc.cluster.local:6379"
],
```

### tyk.conf

```
"storage": {
    "enable_cluster": true,
    "addrs": [
        "redis-cluster.default.svc.cluster.local:6379"
    ],
    ...
}
```