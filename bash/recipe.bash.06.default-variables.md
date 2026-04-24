# Setting a Default Variable

## Problem

Your script breaks if the user runs it without passing an argument.

## Solution

Update `variables.sh` to fall back to a default value if none is provided:

```sh
#!/bin/bash
NAME=${1:-"World"}

echo "Hello, $NAME!"
echo "Welcome back, $NAME."
echo "Goodbye, $NAME!"
```

Run it with an argument:

```
./variables.sh Alice
```

Or without:

```
./variables.sh
```

## Discussion

`${1:-"World"}` means "use `$1` if it was provided, otherwise use `World`." The script now handles both cases without any extra logic. A user who knows what they're doing can pass a name in — a user who doesn't will still get sensible output.

Good scripts don't assume the user will do everything right.