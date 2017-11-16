# Simple Sinatra + Vue.js

Provides a back-end server written with Sinatra (Ruby), and a front end written with Vue

## Pre-requisites

* Ruby (I use v2.4.1 under rvm)
* Bundler (gem install bundler | I use v1.14.6)
* Node (I use v6.9.2)
* Yarn (npm i -g yarn | I use v0.23.4)

## Development

1. Get Ruby and npm libraries (Repeat only when you add new dependencies)

```bash
cd backend
bundle
cd ../frontend
yarn
cd ..
```

2. In a separate terminal window/tab, start the backend server

```bash
./dev_start_backend
```

3. Start the frontend server

```bash
./dev_start_frontend
```

Your web browser should automatically open to http://localhost:8080

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

> There are many boilerplates, why another?

* I don't want to use Gulp or Grunt as build tools: https://www.keithcirkel.co.uk/why-we-should-stop-using-grunt/  Many boilerplates use these.
* I didn't want to use easy-webpack.  I wanted to understand my webpack config and make it as simple as possible.  easy-webpack depends on many plugins, so you're at the mercy of plugin-authors to update / add new functionality.  Tutorials on the web are generally for vanilla webpack configs, and won't work with an easy-webpack config.
* I prefer Vue.js over React.JS
* I didn't want to use JavaScript for the back end.  It makes debugging much more difficult.
