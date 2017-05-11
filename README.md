# Connectionserver

- used :gen_tcp to process requests
- Erlang Term Storage - ETS for storing the pids and timer refs

**SETUP**

```
git clone https://github.com/radhika19/connection_server.git
cd connection_server
mix deps.get
mix phoenix.server
```

**API**

- port that listens to requests is `8080`

 **GET api/request?connId=19&timeout=60**
  returns the following response after timeout


    GET `http://127.0.0.1:8080/api/request?connId=19&timeout=6`

 response -

  ```json
  {
  "status": "ok"
  }
  ```

 **GET api/serverStatus**
  displays all the connections with their timeout time
  
    GET `http://127.0.0.1:8080/api/serverStatus`
    
    response - 
    ```json
      {
      "19": 4.18
      }
    ```

 **PUT api/kill**
  takes in connid in payload and kills the process if running

    PUT `http://127.0.0.1:8080/api/kill`
    body: `{"connId": 9}`

  response -
  
    ```json
      {
      "status": "killed"
    }
    ```
