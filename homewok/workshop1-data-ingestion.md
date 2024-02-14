## Homework

### Question 1: What is the sum of the outputs of the generator for limit = 5?

A: 10.23433234744176

B: 7.892332347441762

C: 8.382332347441762

D: 9.123332347441762


**Answer 1: C: 8.382332347441762**

```
def square_root_generator(limit):
    n = 1
    while n <= limit:
        yield n ** 0.5
        n += 1

# Example usage:
limit = 5
generator = square_root_generator(limit)
sum_gen = 0

for sqrt_value in generator:
    print(sqrt_value)
    sum_gen =  sum_gen + sqrt_value

print("sum of the outputs of the generator for limit = 5 ==>",sum_gen)
```
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/9ec78d5b-bd6a-4ae8-bc98-cb238e154600)


### Question 2: What is the 13th number yielded by the generator?

A: 4.236551275463989

B: 3.605551275463989

C: 2.345551275463989

D: 5.678551275463989


**Answer 2: B: 3.605551275463989**

```
def square_root_generator(limit):
    n = 1
    while n <= limit:
        yield n ** 0.5
        n += 1

# Example usage:
limit = 13
generator = square_root_generator(limit)

for sqrt_value in generator:
    print(sqrt_value)

print(" 13th number yielded by the generator ==>",sqrt_value)
```
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/16de0689-456a-4e54-9488-efd97d027a79)

 
### Question 3: Append the 2 generators. After correctly appending the data, calculate the sum of all ages of people.

A: 353

B: 365

C: 378

D: 390

**Answer 3: A: 353**

```
import dlt
import json

pipeline = dlt.pipeline(pipeline_name='person_append',
                        destination='duckdb',
                        dataset_name='person_append_dataset')

from typing import AsyncGenerator

def people_1():
    for i in range(1, 6):
        yield {"ID": i, "Name": f"Person_{i}", "Age": 25 + i, "City": "City_A"}

info = pipeline.run(people_1(), table_name="person", write_disposition="replace")
print(info)

def people_2():
    for i in range(3, 9):
        yield {"ID": i, "Name": f"Person_{i}", "Age": 30 + i, "City": "City_B", "Occupation": f"Job_{i}"}

info = pipeline.run(people_2(), table_name="person", write_disposition="append")
print(info)
```
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/18f2099d-f68c-4c52-8fed-f9081ea195e3)

```
dlt pipeline person_append info
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/b6141b71-697d-40ab-a475-23f8ae339c99)


```
dlt pipeline person_append show
```
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/41080d85-9496-46c0-8aab-6ccca2b849c1)

![image](https://github.com/garjita63/de-zoomcamp-2024-homework-workshop-data-ingestion/assets/77673886/8fa657c2-f741-43d6-b0b6-d723ca27f814)
![image](https://github.com/garjita63/de-zoomcamp-2024-homework-workshop-data-ingestion/assets/77673886/80f7a893-ca33-4ff0-9656-6c8526856edd)


### Question 4: Merge the 2 generators using the ID column. Calculate the sum of ages of all the people loaded as described above.

A: 215

B: 266

C: 241

D: 258

**Answer 4: B: 266**

```
import dlt
import json

pipeline = dlt.pipeline(pipeline_name='person_merge',
                        destination='duckdb',
                        dataset_name='person_merge_dataset')

from typing import AsyncGenerator

def people_1():
    for i in range(1, 6):
        yield {"ID": i, "Name": f"Person_{i}", "Age": 25 + i, "City": "City_A"}

info = pipeline.run(people_1(), table_name="person", write_disposition="replace")
print(info)   

def people_2():
    for i in range(3, 9):
        yield {"ID": i, "Name": f"Person_{i}", "Age": 30 + i, "City": "City_B", "Occupation": f"Job_{i}"}

info = pipeline.run(people_2(), table_name="person", write_disposition="merge", primary_key="ID")
print(info)   
```
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/c9261431-5d6a-4831-b35c-3617ec8e0dad)

```
dlt pipeline person_merge info
```
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/edd65aa3-af16-4d5c-94e8-47e2b85ffa05)

```
dlt pipeline person_merge show
```
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/796e3057-e290-43a5-8a9b-ddf515ea0d7a)

![image](https://github.com/garjita63/de-zoomcamp-2024-homework-workshop-data-ingestion/assets/77673886/f912dd3e-731c-4e7f-8378-6ec48b2f3dcc)
![image](https://github.com/garjita63/de-zoomcamp-2024-homework-workshop-data-ingestion/assets/77673886/5379a33b-05ec-401e-9e20-875fb4dbcce9)
