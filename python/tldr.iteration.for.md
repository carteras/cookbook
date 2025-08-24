# For Loops in Python

## Purpose

Iterate over a sequence (like a list, tuple, string) or other iterable objects.


## Basic Syntax

### Iterating Over a List

```python
for <variable> in <sequence>: <action>
```

- <variable> is the placeholder for each item in the sequence.
- <sequence> is the collection you want to iterate over.

### Iterating Over a String

Loops through each character in a string.


```python
for char in "Hello":
    print(char)
```

### Using range() for iterating over a set of numbers

* Generates a sequence of numbers.
* Useful for looping a specific number of times.

```python
for i in range(5):  # 0 to 4
    print(i)
```

### Accessing Index and Value with enumerate()

* enumerate() adds a counter to an iterable and returns it.
* Useful for getting the index along with the value of the item.


```python
for index, value in enumerate(["a", "b", "c"]):
    print(index, value)
```

### Nested Loops

* Using one loop inside another loop.
* Allows for iterating over items in a multi-dimensional array or list.

```python
top_passwords = "123456 123456789 12345 qwerty password"
for word in top_passwords.split(" "):
    counter = 0
    for letter in word:
        counter = counter + 1
    print(f"word is {} letters long!")
```

### Iterating Over a List

Loops through each item in a list.

```python
for item in [1, 2, 3]:
    print(item)
```

## Loop Control Statements

Control the flow of loops with break, continue, and else.


* break: Exit the loop.
* continue: Skip the rest of the code inside the loop for the current iteration.
* else: Executes a block of code once when the loop is finished.

### Break Example

* break exits the loop immediately.
* Stops the loop even if the for loop's sequence is not completely iterated over.

```python
for i in range(5):
    if i == 3:
        break  # Exit loop when i is 3
    print(i)
```

### Continue example

* continue skips the rest of the code inside the loop for the current iteration.
* Continues with the next item in the sequence.

```python
for i in range(5):
    if i == 3:
        continue  # Skip 3
    print(i)
```

### Else example

* The else block after a for loop executes after the loop completes normally.
* This means the loop did not encounter a break statement.

```python
for i in range(5):
    print(i)
else:
    print("Done")
```

## Practice makes perfect


### Question 1

Given a string `"John,Jane,Doe"`, split the string by commas and use a for loop to print each name on a separate line.

### Question 2

Given the string `"1,2,3,4,5"`, split the string by commas, and for each number as a string, print out the number multiplied by 2. Note: You'll need to convert the string to an integer to perform the multiplication.

### Question 3

Given a string of temperatures `"20,22,18,25,24"`, split the string by commas. Use a for loop to convert each temperature to Fahrenheit using the formula (Celsius * 9/5) + 32 and print each result. Make sure to [round the results to 2 decimal places](https://ioflood.com/blog/python-f-string/).

### Question 4


Given a string `"apple,banana,cherry"`, split the string and use a for loop with range() to print each fruit's index and name on the same line.


### Question 5

Start with a string representing a list of integers, `"1,2,3,4,5"`. Split the string, then use a loop to calculate the cumulative sum of these numbers as you iterate through them, printing the cumulative sum at each step.

### Question 6

Given a string of mixed data `"John,30,2000;Jane,25,2100;Doe,22,1800"`, split this string by ; to get each person's record, then split each record by , to access individual elements. Use a for loop to print a statement for each person like: "Name: John, Age: 30, Salary: 2000".

### Question 7

Given a string `"apple,banana,cherry"`, split the string by commas. Use enumerate() in a for loop to print each fruit along with its index in the format 1: apple.

### Question 8

Start with a string `"10,20,30,40,50"`. Split the string by commas, and use enumerate() to print the index and value for each number, but only if the number is greater than 20

### Question 9

Given a string of mixed data `"John,30;Jane,25;Doe,22"`, split the string by ; and then each element by , to get name and age. Use enumerate() to print a statement for each person like: "Person 1 - Name: John, Age: 30", incrementing the person number appropriately.

### Question 10

`Iterate over the range 1 to 10 using a for loop`, use continue to skip printing the number 5, and print all other numbers.

### Question 11

Given the string `"1,2,3,4,5,6,7,8,9,10"`, split the string, and use a for loop to print each number except for numbers that are divisible by 3.


### Question 12

Using the string `"apple,banana,cherry,duck,elephant,fig"`, split by commas. Print each fruit, but use continue to skip any fruit that contains the letter 'd'.


### Question 13

`Iterate over the range 1 to 10 using a for loop` and break the loop as soon as it reaches the number 5, printing each number until it breaks.


### Question 14

Given a string of numbers `"1,2,3,4,5,6,7,8,9,10"`, split the string, and use a for loop to print each number and break as soon as you encounter a number greater than 7.

### Question 15

Start with a string `"John,30;Jane,25;Doe,22;Max,28"`, representing names and ages. Split the string by ; and then by , to process each person's data. Use a for loop to print each person's name and age, and break as soon as you encounter someone younger than 25.