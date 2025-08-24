# Problem: How can you build a menu that keeps displaying options until the user chooses "quit"?

*Category:* `bash.iteration.while.menu`

We want to present the user with a simple menu inside a `while` loop. The menu should repeat after each choice, and only exit when the user selects `"quit"`.

## Solution

```bash
#!/bin/bash

choice=""

while [ "$choice" != "quit" ]
do
  echo "Menu:"
  echo "1) Show date"
  echo "2) Show current directory"
  echo "3) Show logged-in users"
  echo "Type 'quit' to exit"
  read -p "Enter your choice: " choice

  case $choice in
    1) date ;;
    2) pwd ;;
    3) who ;;
    quit) echo "Exiting..." ;;
    *) echo "Invalid choice, try again." ;;
  esac
done
```

This loop runs until the variable `choice` equals `"quit"`. Inside, a menu is displayed and the user is prompted for input. A `case` statement handles different options. If the user enters `"quit"`, the condition fails and the loop ends.

## Discussion

* **Why students should care about this?**
  Menus are one of the most practical applications of loops. They show how iteration can create interactive, user-driven scripts, which are far more useful than static ones.

* **Where else this kind of logic might be used?**
  Menu loops appear in system administration scripts, installers, configuration tools, and teaching exercises. Any script where the user repeatedly chooses actions until done benefits from this pattern.

## Challenge

Write a script that:

1. Displays a menu with three file-related options: list files, create a new file, delete a file.
2. Keeps looping until the user types `"quit"`.

