#  The While Loop

What is a while loop? A while loop in Python repeatedly executes a block of code as long as a given condition is true. It's used for iterating over a block of code when the number of iterations is not known before the loop starts.

## Basic while Loop


### Looping


Syntax and Operation: The while loop starts with the keyword while, followed by a condition. The code block under the loop executes repeatedly until the condition evaluates to False.


```python
while <condition>:
    # do something
```

Example: Looping until a counter reaches a certain number demonstrates a basic use case, incrementing the counter in each iteration.

```python
counter = 0
while counter < 5:
    print(counter)
    counter += 1
```

### Exiting the loop 

#### Changing the test condition

Changing the test condition stops the loop at the start of the next loop. 

```python
looping = True 
while looping: 
    # do something
    if <condition>:
        looping = False
```

#### Breaking

Using break: The break statement immediately terminates the loop, regardless of the loop's condition. It's typically used to exit a loop when an external condition is triggered.


```python
while True:
    response = input("Type 'exit' to quit: ")
    if response == 'exit':
        break

```

Practical Use: break is useful in infinite loops or when the condition for exiting the loop occurs within the loop body.

### Skipping Iterations


Using continue: The continue statement skips the current iteration and proceeds to the next iteration of the loop. It's used when certain conditions within the loop require skipping some code block execution.

```python
counter = 0
while counter < 5:
    counter += 1
    if counter == 3:
        continue
    print(counter)
```

Use Case: Ideal for conditions where only specific iterations require executing the full loop body, like skipping specific values.

### Combining with else

else Block Usage: An else block after a while loop executes once after the loop completes, but only if the loop did not terminate through a break statement.

```python
counter = 0
while counter < 5:
    print(counter)
    counter += 1
else:
    print("Loop completed!")
```

Functionality: This feature is useful for running code that should only execute if the loop completed normally, providing a clean separation of normal completion logic and loop processing logic.


## Practice Makes Perfect

Write a program that uses a while loop to print numbers from 1 to 10.

Modify the first program so that it only prints [even numbers](https://www.geeksforgeeks.org/python-program-to-check-if-a-number-is-odd-or-even/) under 20.

Write a program that asks the user to enter a positive number, then uses a while loop to print a countdown from that number to 1. ([want to make your code sleep for  a second](https://realpython.com/python-sleep/)?)

Write a program that continuously asks the user to enter a word until they type "stop", at which point the program should terminate.

Implement a simple guess-the-number game where the program holds a predefined number (e.g., 7) and the user has to guess it. The loop should break once the user guesses correctly.

Enhance the guess-the-number game by adding a feature where the loop also breaks if the user inputs "exit" or if their guess exceeds a certain length, indicating that they're typing words instead of numbers.


Write a program using a while loop that prints numbers from 1 to 50, but skips any number that is a multiple of 5.

Modify the program to print numbers from 1 to 50, but use continue to skip over prime numbers (a prime number is only divisible by 1 and itself, for this exercise you may hard-code checks for small primes).


Write a program that asks the user for a number 'n' and then uses a while loop to print numbers from 1 to 100, but skips every 'n'th number. For example, if the user enters 3, the program should skip 3, 6, 9, etc.


