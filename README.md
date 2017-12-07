# Script Runner

Run custom scripts

## Development

### Development notes

If you make changes to the Ruby back-end, the server will automatically restart

If you make changes to the JavaScript front-end, the changes will automatically be reloaded in the browser using Hot Module Replacement

## Test in production mode (locally)

1. Build production JavaScript bundle

```bash
./prod_build
```

Run the server

```bash
./prod_start
```

Navigate your browser to http://localhost:8080

## Running on another server

Will depend heavily on your server, but the general steps would be:

1. Build the JavaScript assets
2. Zip up backend directory
3. Move zip to remote server
4. Run `bundle`
5. Run the production server

## Why
