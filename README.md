# How to use a File-proxy custom plugin in Lua for Apache APISIX

This repo includes a source code of a new custom plugin called **file-proxy** for APISIX using Lua. This plugin will be used to **expose the static files through API** and fetch a file from a specified URL.

## When using this plugin

Often, we want to **expose a static file** (Yaml, JSON, JavaScript, CSS, or image files) through API. Read the full tutorial to understand when and why to use this plugin.

https://api7.ai/blog/plugin-development-with-lua-and-chatgpt

## How to use this plugin

You can easily add the [file-proxy.lua](https://github.com/Boburmirzo/apisix-file-proxy-plugin-demo/blob/main/custom-plugins/file-proxy.lua) plugin ****implementation file to your APISIX project. In this repo, you can see a simple example of using it in APISIX project running on Docker.

It has a quite similar structure to the existing [Apisix docker example](https://github.com/apache/apisix-docker/tree/master/example) repo, only we removed unnecessary files to keep the demo simple. The project has 3 folders, [docker-compose.yml](https://github.com/Boburmirzo/apisix-file-proxy-plugin-demo/blob/main/docker-compose.yml), and sample [openapi.yaml](https://github.com/Boburmirzo/apisix-file-proxy-plugin-demo/blob/main/openapi.yaml) files.

- [docker-compose.yml](https://github.com/Boburmirzo/apisix-file-proxy-plugin-demo/blob/main/docker-compose.yml) defines two containers one for APISIX and another for etcd (which is configuration storage for APISIX).
- [custom-plugins](https://github.com/Boburmirzo/apisix-file-proxy-plugin-demo/tree/main/custom-plugins) folder has the implementation of the **file-proxy** plugin in Lua.
- [openapi.yaml](https://github.com/Boburmirzo/apisix-file-proxy-plugin-demo/blob/main/openapi.yaml) is just a sample OpenAPI specification `.yaml` file we expose. Basically, we want to place a file `openapi.yaml` to `http://localhost:9080/openapi.yaml` path.

### Prerequisites

- Before you start, it is good to have a basic understanding of APISIX. Familiarity with API gateway, and its key concepts such as [routes](https://docs.api7.ai/apisix/key-concepts/routes), [upstream](https://docs.api7.ai/apisix/key-concepts/upstreams), [Admin API](https://apisix.apache.org/docs/apisix/admin-api/), [plugins](https://docs.api7.ai/apisix/key-concepts/plugins), and HTTP protocol will also be beneficial.
- [Docker](https://docs.docker.com/get-docker/) is used to installing the containerized etcd and APISIX.
- [curl](https://curl.se/) is used to send requests to APISIX Admin API. You can also use tools such as [Postman](https://www.postman.com/) to interact with the API.

## How to use the plugin demo project

You can easily install the [apisix-file-proxy-plugin-demo](https://github.com/Boburmirzo/apisix-file-proxy-plugin-demo) project by running `docker compose up` from the project root folder after you fork/clone [the project](https://github.com/Boburmirzo/apisix-file-proxy-plugin-demo). 

### Create a route with the file-proxy plugin

To use and test our new file-proxy plugin we need to create a route in APISIX that uses the plugin: 

```bash
curl "http://127.0.0.1:9180/apisix/admin/routes/open-api-definition" -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' -X PUT -d '
{
   "name":"OpenAPI Definition",
   "desc":"Route for OpenAPI Definition file",
   "uri":"/openapi.yaml",
   "plugins":{
      "file-proxy":{
         "path":"/usr/local/apisix/conf/openapi.yaml"
      }
   }
}'
```

### Test the plugin

Then, you can send a cURL request to the route or open the link http://127.0.0.1:9080/openapi.yaml in your browser. The response should be the content of the file `openapi.yaml`at the specified URL.

```bash
curl -i http://127.0.0.1:9080/openapi.yaml
```

The plugin works as we expected. With this plugin configuration, you can now access any files using the specified route.

### About the author

- Follow me on Twitter: [@BoburUmurzokov](https://twitter.com/BoburUmurzokov)
- Visit my blog: [www.iambobur.com](https://www.iambobur.com/)
