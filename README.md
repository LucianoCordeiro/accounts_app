# Accounts API

## Setup

To build the docker image and create the application container, run:

```bash
docker build --tag accounts-app .
docker run -d --name accounts-app -p 4567:4567 accounts-app
```

Connect to ``localhost:4567`` in the browser to see the application running

To run unit tests:

```bash
docker exec -it accounts-app bundle exec rspec spec
```
