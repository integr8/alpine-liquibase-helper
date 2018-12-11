``` bash
docker run --rm \
  -e 'SOURCE_METHOD=VOLUME' \
  -e 'LIQUIBASE_URL=jdbc:postgresql://172.17.0.2:5432/sipu' \
  -e 'LIQUIBASE_DB_SCHEME=sipu' \
  -e 'LIQUIBASE_DB_USER=username' \
  -e 'LIQUIBASE_DB_PASS=password' \
  -v $(pwd)/source:/opt/source  \
  -v $(pwd)/liquibase:/opt/liquibase \
liquibase-helper generate

```

```bash
docker run --rm \
  -e 'SOURCE_METHOD=VOLUME' \
  -e 'LIQUIBASE_URL=jdbc:postgresql://172.17.0.3:5432/sipu' \
  -e 'LIQUIBASE_DB_SCHEME=public' \
  -e 'LIQUIBASE_DB_USER=sipu' \
  -e 'LIQUIBASE_DB_PASS=sipu' \
  -v $(pwd)/source:/opt/source  \
liquibase-helper status
```

```bash
docker run --rm \                                   
  -e 'SOURCE_METHOD=VOLUME' \
  -e 'LIQUIBASE_URL=jdbc:postgresql://172.17.0.3:5432/sipu' \
  -e 'LIQUIBASE_DB_SCHEME=public' \
  -e 'LIQUIBASE_DB_USER=sipu' \
  -e 'LIQUIBASE_DB_PASS=sipu' \
  -v $(pwd)/source:/opt/source  \
liquibase-helper update
```

```bash
docker run --rm \
  -e 'SOURCE_METHOD=VOLUME' \
  -e 'LIQUIBASE_URL=jdbc:postgresql://172.17.0.3:5432/sipu' \
  -e 'LIQUIBASE_DB_USER=sipu' \
  -e 'LIQUIBASE_DB_PASS=sipu' \
  -e 'LIQUIBASE_DB_REFERENCE_URL=jdbc:postgresql://172.17.0.2:5432/sipu' \
  -e 'LIQUIBASE_DB_REFERENCE_USER=sipu' \
  -e 'LIQUIBASE_DB_REFERENCE_PASS=sipu' \
  -v $(pwd)/source:/opt/source \
  -v $(pwd)/liquibase:/opt/liquibase \
liquibase-helper diff
```


```bash
docker run --rm \
  -e 'SOURCE_METHOD=VOLUME' \
  -e 'LIQUIBASE_URL=jdbc:postgresql://172.17.0.2:5432/sipu' \
  -e 'LIQUIBASE_DB_USER=sipu' \
  -e 'LIQUIBASE_DB_PASS=sipu' \
  -e 'LIQUIBASE_DB_REFERENCE_URL=jdbc:postgresql://172.17.0.3:5432/sipu' \
  -e 'LIQUIBASE_DB_REFERENCE_USER=sipu' \
  -e 'LIQUIBASE_DB_REFERENCE_PASS=sipu' \
  -v $(pwd)/source:/opt/source \
  -v $(pwd)/liquibase:/opt/liquibase \
liquibase-helper generateDiff
```

```bash
docker run --rm \  
  -e 'SOURCE_METHOD=VOLUME' \
  -e 'LIQUIBASE_URL=jdbc:postgresql://172.17.0.2:5432/sipu' \
  -e 'LIQUIBASE_DB_USER=sipu' \
  -e 'LIQUIBASE_DB_PASS=sipu' \
  -e 'LIQUIBASE_DB_REFERENCE_URL=jdbc:postgresql://172.17.0.3:5432/sipu' \
  -e 'LIQUIBASE_DB_REFERENCE_USER=sipu' \
  -e 'LIQUIBASE_DB_REFERENCE_PASS=sipu' \
  -v $(pwd)/source:/opt/source \
  -v $(pwd)/liquibase:/opt/liquibase \
liquibase-helper report
```