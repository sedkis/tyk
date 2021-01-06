## Injecting Key Meta Data into a GraphQL request

So you have meta data about the user that you want to inject into the GraphQL request, say, as a query/mutation argument.

This guide walks you through how to do that using JavaScript, here's how it would look:

The request going into Tyk:

```
{"query":"query {\n  listEvents{\n    items {\n      id\n      name\n      when\n    }\n  }\n}"}
```

The request Tyk sends to the Upstream:

```
{"query":"query o($a: String){listEvents(customerId: $a){\n    items {\n      id\n      name\n      when\n    }\n  }\n}","variables":{}}
```


### Add this to your API definition:

```
"pre": [
        {
          "name": "graphQLInjectPreMiddlewarea",
          "path": "./middleware/graphql-inject-middleware.js.js",
          "require_session": true,
          "raw_body_only": false
        }
      ]
```

The plugin MUST execute as a "pre" plugin, as it has to modify the request before it gets to the GraphQL engine.


## Modifying the plugin

Check out the custom code in [graphql-inject-middleware.js](./graphql-inject-middleware.js).  This code does the following:
1.  Takes the Authorization token out of the Header
2.  Takes the API ID from context variables
3.  Looks up the token in Redis
4.  Rewrites the graphQL request to include custom meta data from the token as the request

Modify it to your purposes

## Deploy the Plugin

Deploy the plugin so that Tyk can execute the code, then sit back and make an API request, check the Gateway logs for output


