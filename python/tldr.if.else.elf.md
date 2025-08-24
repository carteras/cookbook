# Conditions 



Conditions are logical statements that guide decision-making in programming, crucial for enabling software to perform dynamically based on varying inputs. For system and network engineers managing enterprise networks, conditions are essential for automating and securing network operations. They facilitate the implementation of adaptive security measures, real-time threat detection, and automated system responses, ensuring networks are both efficient and resilient against cyber threats. This makes conditions a cornerstone in the design and security of sophisticated network infrastructures, streamlining management and bolstering defense mechanisms.

## if statements 

- purpose: execute a block of code only if some condition is true
- syntax:

```python
if condition:
    # stuff happens in here
```

## if/else statements 

- purpose: execute one block of code if the condition is `True`, otherwise execute a different block of code. 
- syntax: 
```python
if condition: 
    # something happens here
else: 
    # something different happens here 
```
## if/else/elif

- purpose: test multiple conditions and execute specific blocks of code depending on which condition is `True` first. 
- syntax: 
```python
if condition:
    # do something
elif condition_2:
    # do something else
elif condition_3:
    # do a third thing
else: 
    #if nothing else is true, do this
```

```python
x = 10
y = 20

if x > 5:
    print("x is greater than 5")

if x > 15:
    print("x is greater than 15")
else:
    print("x is not greater than 15")

if x > 15:
    print("x is greater than 15")
elif y > 15:
    print("y is greater than 15")
else:
    print("Neither x nor y is greater than 15")

```


