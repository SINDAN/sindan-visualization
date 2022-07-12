const path    = require("path")
const webpack = require("webpack")

// CSS/SASS
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const RemoveEmptyScriptsPlugin = require('webpack-remove-empty-scripts');

// mode
const mode = process.env.NODE_ENV === 'production' ? 'production' : 'development';
const devtool = (mode === 'production') ? "source-map" : false;

module.exports = {
  mode,
  devtool: devtool,
  entry: {
    application: [
      "./app/frontend/packs/application.js",
      "./app/frontend/stylesheets/application.scss",
    ]
  },
  output: {
    filename: "[name].js",
    sourceMapFilename: "[file].map",
    path: path.resolve(__dirname, "..", "..", "app/assets/builds"),
  },
  plugins: [
    new webpack.optimize.LimitChunkCountPlugin({
      maxChunks: 1
    }),
    new webpack.ProvidePlugin({
      $: 'jquery',
      jQuery: 'jquery'
    }),
    // CSS/SASS
    new RemoveEmptyScriptsPlugin(),
    new MiniCssExtractPlugin(),
  ],
  module: {
    rules: [
      // babel
      {
        test: /\.m?js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader",
          options: {
            presets: ['@babel/preset-env']
          }
        }
      },
      // Add CSS/SASS/SCSS rule with loaders
      {
        test: /\.(?:sa|sc|c)ss$/i,
        use: [MiniCssExtractPlugin.loader, 'css-loader', 'sass-loader'],
      },
    ],
  },
  resolve: {
    // Add additional file types
    extensions: ['.js', '.jsx', '.scss', '.css'],
    alias: {
      '@js': path.resolve(__dirname, '..', '..', 'app/frontend', 'javascripts'),
      '@components': path.resolve(__dirname, '..', '..', 'app/frontend', 'javascripts', 'components'),
      '@css': path.resolve(__dirname, '..', '..', 'app/frontend', 'stylesheets')
    }
  }
}
