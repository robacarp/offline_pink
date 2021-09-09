/*
 | Mix Asset Management
 |
 | Mix provides a clean, fluent API for defining some Webpack build steps
 | for your application.
 |
 | Docs: https://github.com/JeffreyWay/laravel-mix/tree/master/docs#readme
 */

let mix = require("laravel-mix");
let plugins = [];

// Customize the notifier to be less noisy
let WebpackNotifierPlugin = require('webpack-notifier');
let webpackNotifier = new WebpackNotifierPlugin({
  alwaysNotify: false,
  skipFirstNotification: true
})
plugins.push(webpackNotifier)

// Compress static assets in production
if (mix.inProduction()) {
  let CompressionWepackPlugin = require('compression-webpack-plugin');
  let gzipCompression = new CompressionWepackPlugin({
    compressionOptions: { level: 9 },
    test: /\.js$|\.css$|\.html$|\.svg$/
  })
  plugins.push(gzipCompression)

  // Add additional compression plugins here.
  // For example if you want to add Brotli compression:
  //
  // let brotliCompression = new CompressionWepackPlugin({
  //   compressionOptions: { level: 11 },
  //   filename: '[path].br[query]',
  //   algorithm: 'brotliCompress',
  //   test: /\.js$|\.css$|\.html$|\.svg$/
  // })
  // plugins.push(brotliCompression)
}

mix
  // Set public path so manifest gets output here
  .setPublicPath("public")
  // JS entry file. Supports Vue, and uses Babel
  //
  // More info and options (like React support) here:
  // https://github.com/JeffreyWay/laravel-mix/blob/master/docs/mixjs.md
  .js("src/js/app.js", "js")
  // SASS entry file. Uses autoprefixer automatically.
  .sass("src/css/app.scss", "css")
  // Customize postCSS:
  // https://github.com/JeffreyWay/laravel-mix/blob/master/docs/css-preprocessors.md#postcss-plugins
  .options({
    // If you want to process images, change this to true and add options from
    // https://github.com/tcoopman/image-webpack-loader
    imgLoaderOptions: { enabled: false },
    // Stops Mix from clearing the console when compilation succeeds
    clearConsole: false
  })
  // Add assets to the manifest
  .version(["public/assets"])
  // Reduce noise in Webpack output
  .webpackConfig({
    stats: "errors-only",
    plugins: plugins,
    watchOptions: {
      ignored: /node_modules/
    }
  })
  // Disable default Mix notifications because we're using our own notifier
  .disableNotifications()
