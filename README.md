# offline_pink

## Installation
Create a pg database called `offline_pink_development`

Then:

```shellsession
shards update
amber migrate up
```

## Usage

To run the demo:

```shellsession
shards build src/offline_pink.cr
./offline_pink
```

in another tab:
```shellsession
crystal run src/worker.cr
```
