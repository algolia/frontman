# frontman-webpack

> A starter template for Frontman with a Webpack-based assets pipeline.

This template provides a pre-configured [Webpack](https://webpack.js.org/) assets pipeline for Frontman.

## Getting started

### File structure

All entry points live under `assets/`. You can reuse or replace the example assets with your code.

The Webpack configuration lives under `webpack/`, and is split in three:
- `base.config.js`: the common configuration
- `dev.config.js`: the development configuration (used when using `bundle exec frontman serve`)
- `prod.config.js`: the production configuration (used when using `bundle exec frontman build`)

## Adding new assets

When adding new assets that you import in existing entry points, you don't have to do anything: Webpack builds them like any other dependency.

If you add a new entry point, you need to specify it in `webpack/webpack/base.config.js`.

For instance, if you want to build a new `analytics.js` script separately so you can call it conditionally:

```js
module.exports = {
  entry: {
    // ...
    analytics: path.resolve(__dirname, '../assets/analytics.js'),
  },
  // ...
};
```

## Importing assets

### URL
Assets in your `assets/` directory are available on the `/assets` URL. For example, the `assets/css/style.js` file is available through `/assets/css/style.js`.
```haml
%link{ rel: 'stylesheet', href: '/assets/css/style.css' }
```

### Code splitting

Webpack [code splits](https://webpack.js.org/guides/code-splitting/) each entry point for performance purposes. However, since Frontman isn't a full-JavaScript environment and Webpack only takes care of assets, it cannot automatically load chunks for each required asset.

To make sure you load all necessary chunks when importing an asset, you can use the `script_with_vendors.haml` partial.

```haml
= partial 'script_with_vendors.haml', locals: { file: 'index' }
```

In the example above, if the `index.js` script has any chunks, Frontman first loads them all, then includes the script.
