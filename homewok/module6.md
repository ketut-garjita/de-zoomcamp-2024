```
linux $ pwd
/mnt/d/zde/data-engineering-zoomcamp/cohorts/2024/06-streaming
linux $ docker compose up -d
[+] Running 1/1
 ⠿ Container redpanda-1  Started                                                                                   7.5s
```
```
docker ps
```
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/f821864c-101f-4957-9e6c-0d2ac02e4e89)

Question 1: Redpanda version

```
rpk help
```
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/e6dcfa78-e033-4ec5-a69f-8b3d0e418c48)

```
rpk version
```
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/8c1ca47f-8306-4e69-8bbe-2573682f8b4e)

Answer : 
```
v22.3.5 (rev 28b2443)
```

Question 2. Creating a topic
```
rpk topic create test-topic
```
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/59cd7e81-1d30-4d54-81ca-e21afe5a1d61)

Answer : 
```
TOPIC       STATUS
test-topic  OK
```

Question 3. Connecting to the Kafka server

```
pip install kafka-python
```
```
python3
```
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/69c3c3b8-fbf4-4c1a-b294-27334ad3e43f)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/dab7d288-cfa1-4164-b630-fad730b40f31)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/a017a135-258d-4512-a0f9-23bd7e49af0a)

Answer : 
```
True
```

Question 4. Sending data to the stream

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/c0a833cc-48fa-4ba7-9873-7d4d9934dc47)

```
redpanda@fc5d6c5222a8:/$ rpk topic consume test-topic
{
  "topic": "test-topic",
  "value": "{\"number\": 0}",
  "timestamp": 1710340234553,
  "partition": 0,
  "offset": 0
}
{
  "topic": "test-topic",
  "value": "{\"number\": 1}",
  "timestamp": 1710340234604,
  "partition": 0,
  "offset": 1
}
{
  "topic": "test-topic",
  "value": "{\"number\": 2}",
  "timestamp": 1710340234654,
  "partition": 0,
  "offset": 2
}
{
  "topic": "test-topic",
  "value": "{\"number\": 3}",
  "timestamp": 1710340234705,
  "partition": 0,
  "offset": 3
}
{
  "topic": "test-topic",
  "value": "{\"number\": 4}",
  "timestamp": 1710340234756,
  "partition": 0,
  "offset": 4
}
{
  "topic": "test-topic",
  "value": "{\"number\": 5}",
  "timestamp": 1710340234806,
  "partition": 0,
  "offset": 5
}
{
  "topic": "test-topic",
  "value": "{\"number\": 6}",
  "timestamp": 1710340234858,
  "partition": 0,
  "offset": 6
}
{
  "topic": "test-topic",
  "value": "{\"number\": 7}",
  "timestamp": 1710340234909,
  "partition": 0,
  "offset": 7
}
{
  "topic": "test-topic",
  "value": "{\"number\": 8}",
  "timestamp": 1710340234960,
  "partition": 0,
  "offset": 8
}
{
  "topic": "test-topic",
  "value": "{\"number\": 9}",
  "timestamp": 1710340235011,
  "partition": 0,
  "offset": 9
}
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/fb43abcb-a725-4df5-a365-359e05d27190)



