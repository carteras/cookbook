# Problem: How can you repeatedly ask the user for input until they type `"exit"`?

We want a loop that keeps prompting the user for text. The loop should only stop if the user types `"exit"`. This demonstrates using `while` with user input and condition checks.

## Solution

```bash
#!/bin/bash

input=""

while [ "$input" != "exit" ]
do
  read -p "Enter something (type 'exit' to quit): " input
  echo "You entered: $input"
done
```

Here, the variable `input` is initialized as an empty string. The loop runs as long as the condition `[ "$input" != "exit" ]` is true. Inside the loop, `read -p` prompts the user and stores their input. The script then echoes back what was typed. If the input equals `"exit"`, the condition fails and the loop ends.

## Discussion

* **Why students should care about this?**
  Loops that wait for user input are the backbone of interactive scripts. Understanding how to terminate a loop based on user input helps students write scripts that respond dynamically rather than running blindly.

* **Where else this kind of logic might be used?**
  This pattern shows up in menus, interactive tools, confirmation prompts, and scripts that continue until the user signals they’re finished. It’s also useful in automation, where a script might keep retrying until it receives the correct response.

## Challenge

Write a script that:

1. Asks the user for a password until they type `"secret"`.
2. After the correct password is entered, ask them what number to count up to and then down from.

