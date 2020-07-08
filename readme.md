⚠️  **Frontman is currently in an alpha-release**, so breaking changes can be introduced. However, we try to keep backwards compatibility, and changes will be documented in our [changelog][changelog]

# Frontman

[![CircleCI](https://circleci.com/gh/algolia/frontman/tree/master.svg?style=shield&circle-token=ea3dfd1f27a86d050cbc806d3cbd27c1742746ac)](https://circleci.com/gh/algolia/frontman/tree/master)
[![License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)][license]
[![Gem Version](http://img.shields.io/gem/v/frontman-ssg.svg?style=flat)][gem]
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/dwyl/esta/issues)


![Frontman](frontman.svg)

Frontman is a static site generator written in Ruby, optimized for speed. It helps you convert your content to static HTML files, so you can focus on your content instead of maintaining servers.


**Check out our [wiki][wiki] for detailed documentation.**

## About Frontman
Frontman is heavily inspired by [Middleman][middleman], a great static site generator with a big community and feature set. We've been using it internally for a long time, with great success.
However, once our projects reached a certain size, we realized that Middleman was becoming a bottleneck for us to iterate fast. After unsuccesfully trying to improve our build times, we had to move away from Middleman. Instead of migrating to another tool, we decided to keep our current codebase, and create our own static site generator. Frontman was born, and we created it with one thing in mind: speed.

If you want to dive deeper into why and how we made Frontman faster than other tools, please watch the presentation we gave on [scaling the Algolia documentation][doc_talk].

## Installing Frontman

First, make sure you're using Ruby version 2.3 or up. Then, install the Frontman gem on your machine:

```sh
gem install frontman-ssg
```

## Creating your site

You can use the `frontman init` command to initialize a new project in the directory you provide:

```sh
frontman init my-project
```

Then, move into the newly created directory:

```sh
cd my-project
```

## Developing your site

To start a development server with a preview of your website, run the following command:

```sh
frontman serve
```

## Building your site

After you are happy with your changes, you can generate the HTML for all your pages by using the following command:

```sh
frontman build
```

## Going further
You can read the [Frontman documentation][wiki] to learn about all the features and possibilities of Frontman.

## Contributing

We encourage you to contribute to Frontman if you have ideas for improvements to the project. 
Before you contribute, please make sure to read our [code of conduct](.github/CODE_OF_CONDUCT.md) and [contributing guidelines](CONTRIBUTING.md).

[changelog]: https://github.com/algolia/frontman/blob/master/CHANGELOG.md
[doc_talk]: https://www.youtube.com/watch?v=6feV1DrCBdE
[gem]: https://rubygems.org/gems/frontman-ssg
[license]: https://github.com/algolia/frontman/blob/master/LICENSE.md
[middleman]: https://middlemanapp.com/
[wiki]: https://github.com/algolia/frontman/wiki
