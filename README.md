# Manual de utilização da imagem



```bash
docker run --rm \
  -e 'SOURCE_METHOD=VOLUME' \
  -e 'LIQUIBASE_URL=jdbc:oracle:thin:@172.17.0.3:1521:xe' \
  -e 'LIQUIBASE_DB_USER=system' \
  -e 'LIQUIBASE_DB_PASS=oracle' \
  -v $(pwd):/opt/source liquibase-builder \
    --changeLogFile=liquibase/resources/changelog.xml status --verbose

```

```bash
docker run --rm \
  -e 'SOURCE_METHOD=VOLUME' \
  -e 'LIQUIBASE_URL=jdbc:postgresql://172.17.0.2:5432/usuario' \
  -e 'LIQUIBASE_DB_USER=usuario' \
  -e 'LIQUIBASE_DB_PASS=usuario' \
  -v $(pwd):/opt/source liquibase-builder \
    --changeLogFile=sipu-backend/sipu-persistence/src/main/resources/liquibase/changelog.xml status --verbose
```

## Versão inicial

```bash
docker run --rm \
  -e 'SOURCE_METHOD=VOLUME' \
  -e 'LIQUIBASE_URL=jdbc:postgresql://172.24.132.19:5432/db_sipu' \
  -e 'LIQUIBASE_DB_USER=username' \
  -e 'LIQUIBASE_DB_PASS=password' \
  -v $(pwd):/opt/source liquibase-builder \
    --changeLogFile=changeset_$(date +%F_%H-%M).xml \
    --logLevel=debug \
    --defaultSchemaName=sipu \
    generateChangeLog --verbose
```

## Gera versao local

```bash
docker run --rm \
  -e 'SOURCE_METHOD=VOLUME' \
  -e 'LIQUIBASE_URL=jdbc:postgresql://172.17.0.2:5432/sipu' \
  -e 'LIQUIBASE_DB_USER=sipu' \
  -e 'LIQUIBASE_DB_PASS=sipu' \
  -v $(pwd):/opt/source liquibase-builder \
    --logLevel=debug \
    --changeLogFile=changelog.xml status --verbose
```

```bash
docker run --rm \
  -e 'SOURCE_METHOD=VOLUME' \
  -e 'LIQUIBASE_URL=jdbc:postgresql://172.17.0.2:5432/sipu' \
  -e 'LIQUIBASE_DB_USER=sipu' \
  -e 'LIQUIBASE_DB_PASS=sipu' \
  -v $(pwd):/opt/source liquibase-builder \
    --logLevel=debug \
    --changeLogFile=changelog.xml update
```

## Compara com a versão implantada

```bash
docker run --rm \
  -e 'SOURCE_METHOD=VOLUME' \
  -e 'LIQUIBASE_URL=jdbc:postgresql://172.17.0.4:5432/sipu' \
  -e 'LIQUIBASE_DB_USER=sipu' \
  -e 'LIQUIBASE_DB_PASS=sipu' \
  -v $(pwd):/opt/source liquibase-builder \
    --logLevel=debug \
    diff \
        --referenceUrl=jdbc:postgresql://172.17.0.2:5432/sipu \
        --referenceUsername=sipu \
        --referencePassword=sipu
```

Reference é a versão mais antiga

```bash
docker run --rm \
  -e 'SOURCE_METHOD=VOLUME' \
  -e 'LIQUIBASE_URL=jdbc:postgresql://172.17.0.2:5432/sipu' \
  -e 'LIQUIBASE_DB_USER=sipu' \
  -e 'LIQUIBASE_DB_PASS=sipu' \
  -v $(pwd):/opt/source liquibase-builder \
    --changeLogFile=changeset-diff_$(date +%F_%H-%M).xml \
    --logLevel=debug \
    diffChangeLog \
        --referenceUrl=jdbc:postgresql://172.17.0.4:5432/sipu \
        --referenceUsername=sipu \
        --referencePassword=sipu
```

## Relatório

```bash
docker run --rm \
  -e 'SOURCE_METHOD=VOLUME' \
  -e 'LIQUIBASE_URL=jdbc:postgresql://172.17.0.4:5432/sipu' \
  -e 'LIQUIBASE_DB_USER=sipu' \
  -e 'LIQUIBASE_DB_PASS=sipu' \
  -v $(pwd):/opt/source liquibase-builder \
    --changeLogFile=changeset-diff_2018-12-09.xml dbDoc dbdoc-report_$(date +%F_%H-%M)
```

``` bash
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