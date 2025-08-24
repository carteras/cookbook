# Problem: How can you keep trying to `ping` a host until it responds?

*Category:* `bash.iteration.while.retry`

We want to run a command repeatedly until it succeeds. In this case, we’ll use `ping` to check whether a host is reachable, retrying until it works.

## Solution

```bash
#!/bin/bash

host="google.com"

while ! ping -c 1 -W 1 "$host" > /dev/null 2>&1
do
  echo "Host $host is not reachable. Retrying..."
  sleep 2
done

echo "Host $host is now reachable!"
```

The loop condition uses `! ping -c 1 -W 1 "$host"`, which means "while the ping command fails."

* `-c 1` sends one packet.
* `-W 1` sets a one-second timeout.
* Output is redirected to `/dev/null` to suppress clutter.
  The script retries every 2 seconds until the host responds, then exits the loop.

## Discussion

* **Why students should care about this?**
  Retrying commands until success is a practical pattern for resilience. It demonstrates using exit statuses (`0` for success, non-zero for failure) as loop conditions.

* **Where else this kind of logic might be used?**
  Retrying a service until it starts, retrying a database connection, waiting for a network share to mount, or retrying downloads. This approach makes scripts more robust when dealing with unreliable or asynchronous resources.

## Challenge

Write a script that:

1. Tries to connect to a web server with `curl -s -o /dev/null http://example.com`.
2. Retries every 3 seconds until the command succeeds.
3. Once successful, prints `"Web server is up!"`.

