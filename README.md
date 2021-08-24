# Start db

```bash
cd docker
docker-compose up
```

Wait for the db to be live before running the test.

# Build the rust code for alpine

```bash
docker build -t test .

```

# Run the test

```bash
docker run --network=docker_tib -e JDBC_URL="jdbc:sqlserver://db:1433;databaseName=master;user=sa;password=Somepassword#123" test

```