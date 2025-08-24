# Problem: How can you use a `while` loop to print numbers from 1 to 10?

We want to repeatedly print numbers in order from 1 up to 10 using a `while` loop. This introduces the core structure of iteration in bash.

## Solution

```bash
#!/bin/bash

counter=1

while [ $counter -le 10 ]
do
  echo $counter
  counter=$((counter + 1))
done
```

The loop starts with a variable `counter` set to 1. The `while` loop runs as long as the condition `[ $counter -le 10 ]` is true. Inside the loop, the script prints the current value of `counter`, then increments it by 1 using arithmetic expansion. Once `counter` becomes 11, the condition fails and the loop stops.

## Discussion

* **Why students should care about this?**
  This is one of the simplest but most important control flow patterns in bash. Learning to count with a loop demonstrates how iteration works: initialize a variable, test a condition, execute a body of code, then update the variable.

* **Where else this kind of logic might be used?**
  Counting is a foundation for many other problems: iterating over lists of items, stepping through files, generating ranges of numbers, or repeating commands a fixed number of times. This pattern reappears in nearly every scripting scenario where order and repetition matter.

## Challenge

Write a script that:

1. Prints numbers from 1 to 20, but only the even ones.
2. Then counts backward from 20 down to 1 (odd and even).


