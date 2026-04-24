# Using Variables in a Shell Script

## Problem

Your script repeats the same value in multiple places. Changing it means finding and updating every occurrence.

## Solution

Create a new file called `variables.sh`:

```sh
#!/bin/bash
NAME="Alice"

echo "Hello, $NAME!"
echo "Welcome back, $NAME."
echo "Goodbye, $NAME!"
```

Make it executable and run it:

```
chmod u+x variables.sh
./variables.sh
```

## Discussion

A variable is just a named container for a value. You define it once at the top of the script and reference it anywhere with a `$` prefix. If the value needs to change, you update it in one place and every line that uses it picks up the change automatically.

This is the same reason scripts are better than typing commands by hand — write it once, use it everywhere.