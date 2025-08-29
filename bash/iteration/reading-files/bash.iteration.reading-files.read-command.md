# problem: use `read` to capture one line of input

`bash.iteration.reading-files.read-command`

Problem text: You want to grab a single line of text (from the keyboard or a file) and store it in a variable to use later in your script.

## Solution

```bash
echo "Type your name:"
IFS= read -r name
echo "Hello, $name"
```

Technical discussion:

* `read` reads **one line** from standard input into variables.
* `-r` stops backslashes from acting as escapes (so `\` stays `\`).
* Setting `IFS=` (empty) preserves leading/trailing spaces.
* If you give multiple variables (e.g., `read a b`), Bash splits the line using IFS; with one variable, the whole line goes into it.

## Discussion

* Decision processing: Choose `read -r` when you want to keep text exactly as typed.
* Where else used: Reading config values, asking the user for input, grabbing the first line of a file.
* Why care: Many scripts need a safe, predictable way to capture exactly one line.

## practice question

1. Create a script that prompts: `Enter your favorite quote:` then uses `read -r` to store it in `quote` and prints `You said: <quote>`.
2. Create a file `firstline.txt` with several lines. Write a script that reads **only the first line** from that file into a variable using `read -r` and prints it. (Hint: redirect the file into `read` or use a subshell.)