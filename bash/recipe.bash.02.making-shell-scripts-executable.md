# Making a Shell Script Executable

## Problem

You want to run your script as `./simple.sh` instead of typing `bash simple.sh` every time.

## Solution

Add a hashbang as the first line of `simple.sh`:

```sh
#!/bin/bash
echo "Hello, World!"
```

Then make the file executable:

```
chmod u+x simple.sh
```

Now you can run it directly:

```
./simple.sh
```

## Discussion

When you run `./simple.sh`, your terminal needs to know which program should interpret the file. The hashbang `#!/bin/bash` on the very first line answers that question — it tells the operating system to hand this file to Bash.

`chmod u+x` gives your user account permission to execute the file. Linux tracks three types of permissions for every file — read, write, and execute — and by default new files don't have execute permission set. `u+x` means "add execute for the user who owns this file." Without it, the OS will refuse to run the script even if the hashbang is correct.