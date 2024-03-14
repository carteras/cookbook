# grep

Searches for patterns in files, displaying lines that match a specified pattern. It's powerful for searching through large volumes of text in a directory hierarchy.

## Examples

- Search for a pattern within a file:

  `grep "<pattern>" <file>`

- Case-insensitive search for a pattern:

  `grep -i "<pattern>" <file>`

- Search for a pattern recursively in all files under a specific directory:

  `grep -r "<pattern>" <path/to/directory>`

- Count the number of lines that match a pattern in a file:

  `grep -c "<pattern>" <file>`

- Display line numbers with the lines matching the pattern:

  `grep -n "<pattern>" <file>`

- Use extended regular expressions (ERE) in the search:

  `grep -E "<pattern>" <file>`

- Invert the search to display lines that do not match the pattern:

  `grep -v "<pattern>" <file>`

## Notes

- `<pattern>` can be a simple string or a complex expression if `-E` is used.

- Quotes are recommended around the pattern to avoid shell interpretation of special characters.

- `-r` or `--recursive` option searches within all files under each directory, recursively.

- `grep` can be combined with other commands using pipes (`|`) for powerful text processing and filtering workflows.

cat <file> | grep "<pattern>"`

  This uses `cat` to display the content of `<file>`, which is then piped into `grep` to filter lines matching `<pattern>`.

- Piping allows you to efficiently filter the output of any command, making `grep` a versatile tool for text processing in combination with other command-line utilities.