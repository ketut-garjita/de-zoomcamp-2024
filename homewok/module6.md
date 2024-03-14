```
linux $ pwd
/mnt/d/zde/data-engineering-zoomcamp/cohorts/2024/06-streaming
linux $ docker compose up -d
[+] Running 1/1
 ⠿ Container redpanda-1  Started                                                                                   7.5s
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

v22.3.5 (rev 28b2443)

Question 2. Creating a topic
TOPIC       STATUS
test-topic  OK

Question 3. Connecting to the Kafka server
True

Question 4. Sending data to the stream
Sent: {'number': 0}
Sent: {'number': 1}
Sent: {'number': 2}
Sent: {'number': 3}
Sent: {'number': 4}
Sent: {'number': 5}
Sent: {'number': 6}
Sent: {'number': 7}
Sent: {'number': 8}
Sent: {'number': 9}
took 0.51 seconds

