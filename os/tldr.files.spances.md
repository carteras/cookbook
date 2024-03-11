# Handling Files with Spaces in Filenames


To work with files that have spaces in their names, you must either quote the entire filename or escape the spaces with a backslash (\).


## Quoting

Use single (') or double quotes (") around the filename.


```
cat "my file.txt"
cp 'another file.txt' /destination/path/
```

## Escaping

Place a backslash before each space.


```
cat my\ file.txt
cp another\ file.txt /destination/path/
```

