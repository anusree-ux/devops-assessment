# Production Deployment and Rollback

## Deployment

production deployment uses Docker images published by Github Actions to Docker Hub.

Images are identified using the full Git commit SHA:

```text
anusree15/devops-assessment-frontend:<commit-sha>
anusree15/devops-assessment-backend:<commit-sha>
```

Deploy a specific version:
```bash
./scripts/deploy.sh <commit-sha>
```

The deployment script:
1. Validates the commit SHA format
2. pulls the corresponding imgaes from Docker Hub
3. Starts the application using Docker Compose
4. verifies frontend, backend, databse and S3 health
5. marks the version as current and known-good only after successful verification.

Production compose does not build application images locally

## Rollback

Rollback uses the previously recorded known-good commit SHA:
```bash
./scripts/rollback.sh
```

The rollback script:
1. reads the known-good version from `deployment/known_good_version`
2. pulls the previously published frontend and backend images from Docker Hub
3. Starts the application using that image version
4. verifies frontend, backend, database, S3 health
5. records the restored version as the current version

No application image is rebuilt during rollback

## Version Tracking
```text
deployment/current_version
```
stores the currenly deployed commit SHA


```text
deployment/known_good_version
```
stores the latest verified working commit SHA

This allows the production deployment to be traced back to an exact source commit and provides a reproducible rollback mechanism

## Rollback Example
A deployment can be rolled back from a newer version:

```text
Current version:
3f8cfb894eff066f345717da48725003a44830f6

Known-good version:
162ccb0461b571cd37c86c48b456e7bdf7048fb4
```

Running:
```bash
./scripts/rollback.sh
```
restores:
```text
162ccb0461b571cd37c86c48b456e7bdf7048fb4
```

The restored containers are then verified using the application health endpoints
