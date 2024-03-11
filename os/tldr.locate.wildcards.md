# Using Wildcards with locate


The locate command in Linux is used for finding files by name quickly. Wildcards (*, ?) can enhance search flexibility by matching patterns.

**Asterisk (*)** - Matches any number of characters, including none.
**Question mark (?)** - Matches exactly one character.

## Examples

Find all .txt files:

```
locate *.txt
```

Find a file with a specific prefix

```
locate report*
```


Find a file with a specific pattern (e.g., any single character between report and .txt):

locate report?.txt

```
locate report?.txt
```

## Tips 

Case Sensitivity: By default, locate is case-sensitive. Use -i for case-insensitive searches.

```
locate -i *report*
```

Updating Database: locate relies on a database updated by updatedb. If you can't find a recent file, update the database:

```
sudo updatedb
```


Using Quotes: When using special characters in your search pattern (especially in shells where * and ? might be interpreted differently), it's a good idea to enclose the pattern in quotes.

```
locate "*.txt"
```
