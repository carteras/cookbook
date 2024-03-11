# Dictionaries 


## Basic usage

### Creating a Dictionary

```python
# Empty dictionary
my_dict = {}

# Dictionary with initial values
my_dict = {"name": "John", "age": 30}
```

Initializes dictionaries. The first is empty, and the second contains initial key-value pairs for name and age.

### Accessing Values

```python
# Get value by key
name = my_dict["name"]

# Using get() to avoid KeyError
age = my_dict.get("age")

```

The get() method prevents errors if the key doesn't exist by returning None instead of throwing a KeyError.

### Adding or Updating Entries

```python
# Add or update
my_dict["email"] = "john@example.com"
print(my_dict['email'])   # prints john@example.com
my_dict['email'] = 'harry@example.com'
print(my_dict['email'])   # prints harry@example.com
```

Adding and updating key-value pair is the same. 

### Removing Entries

```python
# Remove entry with specific key
del my_dict["age"]

# Remove and return value
email = my_dict.pop("email")
```

### Iterating through dictionaries

```python
# Iterate over keys
for key in my_dict:
    print(key)

# Iterate over values
for value in my_dict.values():
    print(value)

# Iterate over items (key-value pairs)
for key, value in my_dict.items():
    print(key, value)
```

### Checking for a Key

```python
if "name" in my_dict:
    print("Name is present.")
```

## Worked examples

### Counting letters in a string 

```python
def count_letters(text):
    count_dict = {}
    for letter in text:
        if letter not in count_dict:
            count_dict[letter] = 1
        else:
            count_dict[letter] += 1
    return count_dict

result = count_letters("hello world")
print(result)
```

### Dictionary attack for passwords 

```python
# A string containing comma-separated key-value pairs of passwords and their corresponding hashes
passwords = "password:5f4dcc3b5aa765d61d8327deb882cf99,123456:e10adc3949ba59abbe56e057f20f883e,123456789:25f9e794323b453885f5181f1b624d0b,test1:5a105e8b9d40e1329780d62ea2265d8a,password1:7c6a180b36896a0a8c02787eeafb0e4c"

# Split the string by commas to create a list of individual key-value pairs
passwords = passwords.split(',')

# Create an empty dictionary to store the reverse mapping (hash to password)
reverse_dict = {}

# Iterate through each key-value pair in the list
for password in passwords:
    # Split the key-value pair by the colon to separate the password and hash
    password, hash = password.split(":")
    # Store the password as the value and the hash as the key in the reverse dictionary
    reverse_dict[hash] = password

# The hash for which we want to find the corresponding password
hash_to_find = "25f9e794323b453885f5181f1b624d0b"

# Print the password corresponding to the given hash by accessing the reverse dictionary
print(f"The password for the hash: {hash_to_find} is {reverse_dict['25f9e794323b453885f5181f1b624d0b']}")

```

### Reversing a dictionary 

```python
# Original dictionary
original_dict = {"a": 1, "b": 2, "c": 3}

# Inverting the dictionary without using dictionary comprehension
inverted_dict = {}
for key, value in original_dict.items():
    inverted_dict[value] = key

# Printing the inverted dictionary
print(inverted_dict)

```

