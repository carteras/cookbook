# Robotics 11 Practice Exam 


## Variables and conditions 

1. Which of the following correctly declares an integer variable named sensorValue and assigns it a value of 100?

A) sensorValue = 100;  
B) int sensorValue = 100;  
C) var sensorValue = 100;  
D) integer sensorValue = 100;  


2. What will the following code output to the Serial Monitor? 

```cpp
int temperature = 30;

if (temperature > 25) {
  Serial.println("Hot");
} else {
  Serial.println("Cold");
}
```

A) Hot  
B) Cold  
C) 30  
D) Error: Invalid syntax  

3. Which of the following statements best describes the role of a condition in an Arduino if statement?

A) It stores data in the microcontroller's memory.
B) It continuously loops the code inside the if block.
C) It evaluates to either true or false to control program flow.
D) It assigns values to variables inside the if block.

4. Consider the following Arduino code:

```cpp
int value = 5;

void setup() {
  Serial.begin(9600);
  int value = 10;  // Local variable

  if (value > 7) {
    Serial.println("High");
  }

  if (value < 3) {
    Serial.println("Low");
  }

  Serial.println(value);
}

void loop() {}

```

What will be printed to the Serial Monitor?




5. Analyze this code snippet:

```cpp
int counter = 0;

void setup() {
  Serial.begin(9600);

  counter = counter + 3;

  if (counter == 3) {
    Serial.println("Three");
    counter = counter * 2;
  }

  if (counter == 6) {
    Serial.println("Six");
  } else {
    Serial.println("Not Six");
  }

  Serial.println("Final: " + String(counter));
}

void loop() {}
```

What will be printed to the Serial Monitor? Explain each step.




6. Given this code: 

```cpp
int temp = 20;

void setup() {
  Serial.begin(9600);

  if (temp >= 15) {
    Serial.println("Warm");
    temp = temp - 5;
  }

  if (temp == 15) {
    Serial.println("Exactly 15");
  }

  if (temp < 15) {
    Serial.println("Cool");
  }

  Serial.println("Temp is: " + String(temp));
}

void loop() {}

```

List the exact output printed to the Serial Monitor and explain any or all lines which appears. 


7. Agatha is working on an arduino project, but their code isn't behaving as expected. Look at the following code and identify at least 5 unique issues that could be causing their problem: 

```cpp
int voltage = 5;
int threshold = 10;
int reading;

void setup() {
  Serial.begin(9600);
  
  reading = voltage + 3;

  if (reading = threshold) {  // Issue 1?
    Serial.println("Threshold Met");
  } 

  >! spoiler 
  

  if (reading < threshold); {  // Issue 2?
    Serial.println("Below Threshold");
  }

  if (reading > threshold) {
    Serial.println("Above Threshold");
  }

  if (threshold)  // Issue 3?
    Serial.println("Threshold is Active");
  
  if (reading + 5 > threshold) {
    reading = reading++;  // Issue 4?  
    Serial.println("Adjusted Reading: " + String(reading));
  }

  if (reading - 3 = 5) {  // Issue 5?
    Serial.println("Special Condition Met");
  }

  if (voltage) {
    int voltage = 12;  // Issue 6?
    Serial.println("Voltage: " + String(voltage));
  }

  if (threshold = 0) {  // Issue 7?
    Serial.println("Threshold Disabled");
  }
}

void loop() {}

```

Identify at least 5 unique issues in the code.
For each issue:
1. State the problem clearly.
2. Explain why it would cause unintended behavior.
3. Suggest a fix.


```bash















```










 


## functions 

1. Which of the following correctly defines a function in Arduino that takes two integers as parameters and returns their sum?

```cpp
A) int add(a, b) { return a + b; }
B) void add(int a, int b) { return a + b; }
C) int add(int a, int b) { return a + b; }
D) function add(int a, int b) -> int { return a + b; }
```

2. What will the following code print to the Serial Monitor

```cpp
int multiplyByTwo(int num) {
  return num * 2;
}

void setup() {
  Serial.begin(9600);
  int result = multiplyByTwo(5);
  Serial.println(result);
}

void loop() {}

```

A) 5  
B) 10  
C) 2  
D) Error: Invalid function call


3. What will the following code output to the Serial Monitor?

```cpp
int adjustValue(int x) {
  if (x < 10) {
    return x + 5;
  }
  return x - 5;
}

void setup() {
  Serial.begin(9600);
  int a = adjustValue(7);
  int b = adjustValue(12);
  Serial.println(a);
  Serial.println(b);
}

void loop() {}
```

a) 
```cpp
7  
12  
```

b)
```cpp
12  
7 
```

c)
```cpp
12  
5
```

d)
```cpp
7  
7
```

4. Examine the following code:

```cpp
int doubleValue(int num) {
  return num * 2;
}

int increment(int num) {
  return num + 1;
}

void setup() {
  Serial.begin(9600);
  int a = 4;
  int b = doubleValue(a);
  int c = increment(b);

  Serial.println(a);
  Serial.println(b);
  Serial.println(c);
}

void loop() {}


```

What will be printed to the Serial Monitor? Explain how each value is calculated.


4. Analyze this code snippet. 

```cpp
int processNumber(int x) {
  if (x < 5) {
    return x * 3;
  } 
  if (x == 5) {
    return x + 5;
  }
  return x - 2;
}

void setup() {
  Serial.begin(9600);
  Serial.println(processNumber(3));
  Serial.println(processNumber(5));
  Serial.println(processNumber(8));
}

void loop() {}

```

What will the Serial Monitor display? Provide the result for each function call and explain why.


5. Kevin is working on his project but the code isn't producing the expected results. Review the following code carefully, and identify at least 5 different issues that could cause unintended behavior or logical errors. 


```cpp
int sensorValue = 0;
int threshold = 50;

void setup() {
  Serial.begin(9600);
  sensorValue = getSensorReading();
  Serial.println("Sensor Value: " + String(sensorValue));

  if (checkThreshold(sensorValue)) {
    Serial.println("Threshold Reached");
  } else
    Serial.println("Threshold Not Reached");

  int result = doubleValue(sensorValue);
  Serial.println("Doubled Value: " + String(result));

  resetSensor(sensorValue);
  Serial.println("Sensor After Reset: " + String(sensorValue));
}

void loop() {}

int getSensorReading() {
  int value = 40;
  return;  // Issue 1?
}

bool checkThreshold(int value) {
  if (value = threshold) {  // Issue 2?
    return true;
  }
  if (value > threshold) {
    return true;
  }
  return false;
}

int doubleValue(int value) {
  value = value * 2;
  return value;
}

void resetSensor(int value) {
  value = 0;  // Issue 3?
}

bool isPositive(int number) {
  if (number > 0)
    return true;
  else
    return;  // Issue 4?
}

int faultyOperation(int num) {
  return num +;  // Issue 5?
}

int noReturnValue(int num) {  // Issue 6?
  int result = num * 3;
  // Missing return statement
}

void missingParameter() {  // Issue 7?
  Serial.println("Missing Parameter Example");
}

```

## iteration 

1. What will the following code print to the Serial Monitor?

```cpp
void setup() {
  Serial.begin(9600);
  
  for (int i = 0; i < 3; i++) {
    Serial.println(i);
  }
}

void loop() {}
```

a)  
```cpp
0  
1  
2 
```

b)  
```cpp
1  
2  
3  
```

c)  
```cpp
0  
1  
2  
3  
```

d)  
```cpp
0  
1  
2  
```


2. Consider the following code 


```cpp
void setup() {
  Serial.begin(9600);
  
  int counter = 0;

  while (counter < 4) {
    Serial.println(counter);
    counter++;
  }
}

void loop() {}

```


a)  
```cpp
0  
1  
2  
3  

```



b)  
```cpp
1  
2  
3  
4  

```



c)  
```cpp
0  
1  
2  
3  
4  

```



d)  
```cpp
0  
1  
2  
3  

```


3. What will be printed ot the serial moninitor? 

```cpp

void setup() {
  Serial.begin(9600);
  
  for (int i = 0; i < 5; i++) {
    Serial.println("Count: " + String(i));
  }
}

void loop() {}


```

List the exact lines printed to the Serial Monitor.



4. What will the following code output to the Serial Monitor? 

```cpp
void setup() {
  Serial.begin(9600);
  
  int num = 10;

  while (num > 0) {
    Serial.println("Num: " + String(num));
    num = num - 3;
  }

  Serial.println("Finished");
}

void loop() {}
```

List the exact lines printed to the Serial Monitor.





5. Examine the following code and determine what will be printed to the Serial Monitor:


```cpp
void setup() {
  Serial.begin(9600);
  
  for (int i = 1; i <= 3; i++) {
    Serial.println("Outer Loop i = " + String(i));
    
    int j = i;
    while (j < 5) {
      Serial.println("  Inner Loop j = " + String(j));
      j += 2;
    }
  }
}

void loop() {}
```


List the exact sequence of printed lines.

6. Agatha is working on her Arduino project, aiming to control a series of lights using loops. Her goal is to turn 5 lights ON one by one and then turn them OFF in reverse order. However, the Serial Monitor isn’t showing the expected results, and there seem to be multiple issues in her code. Here’s Agatha’s code:


```cpp
void setup() {
  Serial.begin(9600);
  
  int lightNumber = 1;

  while (lightNumber <= 5); {  // Issue 1?
    Serial.println("Turning ON light: " + String(lightNum));  // Issue 2?
    lightNumber++;
  }

  for (int i = 5; i > 0; i--); {  // Issue 3?
    Serial.println("Turning OFF light: " + String(i));
  }

  int totalLights;
  if (totalLights = 5) {  // Issue 4?
    Serial.println("Total lights set to 5");
  }

  for (int j = 1; j <= 5; j++) {  
    Serial.println("Light " + String(j) + " is " + status);  // Issue 5?
  }

  Serial.println("All lights handled.");
}

void loop() {}

```

1. What will the Serial Monitor actually print when the code runs?
2. Identify at least 5 unique issues in the code.
3. Explain how each issue affects the program and provide the correct fix.




## Circuits 



## Composite questions 



