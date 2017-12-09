var path = require("path")
const webpack = require('webpack')
module.exports = {
  entry: {
    app: ["./app/main.js"]
  },
  output: {
    path: path.resolve(__dirname, "../backend/dist/build"), /* When running `webpack`, put bundle here */
    publicPath: "build", /* requests that go to this path... */
    filename: "bundle.js" /* ...and this filename will actually get the generated bundle, not a static file. */
  },
  module: {
    rules: [
      {
        test: /\.vue$/,
        loaders: ['babel-loader', 'vue-loader'],
      },
      {
        test: /\.js$/,
        loader: 'babel-loader',
        exclude: /node_moudles/
      },
      {
        test: /\.(png|jpg|gif|svg|woff2|woff|ttf|eot)$/,
        loader: 'url-loader?limit=10000', /* if resource less then 10kb, load inline, otherwise use file-loader */
        options: {
          name: '[name].[ext]?[hash]'
        }
      },
      {
        test: /\.css$/,
        loaders: ['style-loader', 'css-loader']
      },
      {
        test: /\.less$/,
        loaders: ['style-loader', 'css-loader', 'less-loader']
      }
    ]
  },
  resolve: {
    alias: {
      'vue$': 'vue/dist/vue.esm.js'
    }
  },
  plugins: [
    new webpack.NamedModulesPlugin(), /* displays the name of what was updated in HMR */
    new webpack.DefinePlugin({
      SETTINGS: JSON.stringify(require('./settings.json'))
    }),
  ],
  devServer: {
    /* Warning, adding hot and inline here, instead of on the command line, doesn't work.  (Console will say HMR is disabled.) */
    /*inline: true, /* auto reload */
    /*hot: true, /* hot module replacement */
    quiet: true, /* less webpack output */
    noInfo: true, /* webpack bundle information on startup and save is hidden, errors and warnings still shown */
    contentBase: "./static", /* Dev server will serve files from this dir */
    proxy: {
      '/api': {
        target: 'http://localhost:9299',
        secure: false
      }
    }
  },
  devtool: '#eval-source-map'
}

if (process.env.NODE_ENV === 'production'){
  module.exports.devtool = '#source-map'
  module.exports.plugins = (module.exports.plugins || []).concat([
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: '"production"'
      }
    }),
    new webpack.optimize.UglifyJsPlugin({
      sourceMap: true,
      compress: {
        warnings: false
      }
    }),
    new webpack.LoaderOptionsPlugin({
      minimize: true
    })
  ])
}
