# And and OR

## And

Purpose: Combine two conditions, both must be True for the combined condition to be True.

Usage:

```python
if condition1 and condition2:
    # block of code if both condition1 and condition2 are True
```

## or

Purpose: Combine two conditions, at least one must be True for the combined condition to be True.

Usage:
```python
if condition1 or condition2:
    # block of code if either condition1 or condition2 is True
```

## example

```python
x = 10
y = 20

if x > 5 and y > 15:
    print("x is greater than 5 and y is greater than 15")

if x > 15 or y > 15:
    print("Either x or y (or both) is greater than 15")
```