## Compile 

```
$ docker run --rm -v `pwd`:/plugin-source tykio/tyk-plugin-compiler:v3.1.2 go-auth-plugin.so
```

Then put generated "go-auth-plugin.so" onto the Gateway's file system.

Api definition:

```
driver: goplugin
pre: [{
    "name": "MyPluginAuthCheck",
    "path": "./middleware/go-auth-plugin.so"
}]
```