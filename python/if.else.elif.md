# Using If Statements in Python: A Technical Cookbook Recipe

## Problem

In programming, decision-making is a fundamental concept where a program chooses different actions based on whether a condition is true or false. Python's `if` statement is one of the basic building blocks for this type of logic. However, newcomers to Python or programming in general might struggle with understanding how to effectively use `if` statements in different scenarios.

## Solution

### Basic Structure

```python
if condition:
    # Code to execute if the condition is true
```

### Example 1: Simple If Statement

```python
x = 10
if x > 5:
    print("x is greater than 5")
```

### Example 2: If-Else Statement

```python
y = 4
if y > 5:
    print("y is greater than 5")
else:
    print("y is not greater than 5")
```

### Example 3: If-Elif-Else Statement

```python
z = 7
if z > 10:
    print("z is greater than 10")
elif z > 5:
    print("z is greater than 5 but not greater than 10")
else:
    print("z is 5 or less")
```

### Example 4: Nested If Statements

```python
a = 15
if a > 10:
    print("a is greater than 10")
    if a % 2 == 0:
        print("a is even")
    else:
        print("a is odd")
```

## Discussion

- **Condition Evaluation**: The condition in an `if` statement is always evaluated to either `True` or `False`. Python supports different operators like `==`, `!=`, `>`, `<`, `>=`, `<=` for comparison to form these conditions.
- **Indentation**: Python relies on indentation to define scope. The code block under each `if`, `elif`, and `else` statement must be indented.
- **Elif and Else**: `elif` allows multiple checks, while `else` covers anything not caught by preceding conditions. Both are optional.
- **Nesting**: If statements can be nested within each other, but this should be done sparingly to maintain readability.
- **Boolean Logic**: Conditions can use logical operators like `and`, `or`, and `not` to form more complex checks.

By understanding and using `if` statements effectively, you can control the flow of your Python program to handle different scenarios and data conditions.
