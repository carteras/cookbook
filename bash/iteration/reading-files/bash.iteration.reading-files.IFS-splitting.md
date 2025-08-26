
# problem: control how lines are split using IFS

`bash.iteration.reading-files.IFS-splitting`

Problem text: You want to split each line of a file into separate pieces, like breaking a CSV file into fields by commas.

## Solution

```bash
FILE="scores.csv"

while IFS=, read -r name score; do
    echo "$name scored $score"
done < "$FILE"
```

Technical discussion:

* `IFS=,` sets the **Internal Field Separator** to a comma just for this `read`.
* `read -r name score` splits the line into two variables: before and after the comma.
* By changing `IFS`, you control how Bash breaks up input lines.
* Useful for parsing CSVs, colon-separated files (like `/etc/passwd`), or other structured text.

## Discussion

* Decision processing: Choosing the right `IFS` lets you decide how to break text into parts.
* Where else used: Splitting paths (`:`), CSV data (`,`), or custom logs with delimiters.
* Why care: Being able to parse structured files makes Bash scripts more powerful and practical.

## practice question

1. Create a file `grades.csv` with entries like `Alice,95` and `Bob,88`. Write a script that prints `<name> has grade <score>` using `IFS=,`.
2. Create a file `users.txt` with entries like `user1:x:1000:1000:User One:/home/user1:/bin/bash`. Write a script that uses `IFS=:` with `read` to capture the username and shell, then prints `<username> uses <shell>`.
