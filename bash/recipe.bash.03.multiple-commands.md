# Running Multiple Commands in a Shell Script

## Problem

You need to run several commands in sequence without typing them one by one.

## Solution

Add each command on its own line in `simple.sh`:

```sh
#!/bin/bash
echo "who am I?"
whoami
echo "who else am I?"
sudo whoami
echo "what groups am I in?"
groups
echo "where am I?"
pwd
echo "what's in here?"
ls -la
echo "Updating package list..."
sudo dnf update -y
echo "Done!"
```

Run it:

```
./simple.sh
```

## Discussion

Bash executes each line in order, from top to bottom, waiting for each command to finish before moving to the next. This is what makes scripts so useful for multi-step tasks — you write the sequence once and it runs exactly the same way every time.

If any command in the script requires `sudo`, Bash will pause and wait for your password before continuing. Everything after it will still run in order once you authenticate.