# Handling Files with Hyphens (-) as the First Character

Files starting with a hyphen (-) can be mistaken by the shell and commands as options. To handle these, use ./ before the filename or the -- option to signify the end of command options.

## Using ./

Prefix the filename with ./ to indicate the current directory and avoid misinterpretation as an option.

```
cat ./-myfile.txt
rm ./-example.txt
```

## Using --

Place -- before the filename to signal the end of command options.


```
cat -- -myfile.txt
rm -- -example.txt
```