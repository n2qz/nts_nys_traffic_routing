# nts_nys_traffic_routing

nts_nys_traffic_routing is a Docker container to serve a web page
providing routing data for the [National Traffic
System](https://www.arrl.org/nts) in New York State.

## Installation

A Makefile is provided to build the container image.

```bash
make
```

## Usage

Run the container locally for testing:

```bash
docker run --rm -it -p 127.0.0.1:3000:3000 docker.io/n2qz/nts_nys_traffic_routing:latest
```

Then run a browser to interact with the page, for example:

```bash
lynx http://localhost:3000/
```

## Contributing

Pull requests are welcome. For major changes, please open an issue
first to discuss what you would like to change.

## Credits

See [credits.html](html/templates/credits.html)

## License

[Apache-2.0 License](https://www.apache.org/licenses/LICENSE-2.0)
