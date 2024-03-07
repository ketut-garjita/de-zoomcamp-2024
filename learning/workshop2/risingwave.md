# Envronment
1. Github Codespace
2. GCP VM Instance

# Prerequisites
1. Docker and Docker Compose
   ```
   @garjita63 ➜ ~/risingwave-data-talks-workshop-2024-03-04 (main) $ docker version
   Client:
      Version:           24.0.9-1
      API version:       1.43
      Go version:        go1.20.13
      Git commit:        293681613032e6d1a39cc88115847d3984195c24
      Built:             Wed Jan 31 20:53:14 UTC 2024
      OS/Arch:           linux/amd64
      Context:           default
     
   Server:
      Engine:
       Version:          24.0.9-1
       API version:      1.43 (minimum version 1.12)
       Go version:       go1.20.13
       Git commit:       fca702de7f71362c8d103073c7e4a1d0a467fadd
       Built:            Thu Feb  1 00:12:23 2024
       OS/Arch:          linux/amd64
       Experimental:     false
      containerd:
       Version:          1.6.28-1
       GitCommit:        ae07eda36dd25f8a1b98dfbf587313b99c0190bb
      runc:
       Version:          1.1.12-1
       GitCommit:        51d5e94601ceffbbd85688df1c928ecccbfa4685
      docker-init:
       Version:          0.19.0
       GitCommit:        de40ad0
    ```
3. Python 3.7 or later
   ```
  @garjita63 ➜ ~/risingwave-data-talks-workshop-2024-03-04 (main) $ python --version
  Python 3.10.13
  ```

4. pip and virtualenv for Python
5. psql (I use PostgreSQL-14.9)

