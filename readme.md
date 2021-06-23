⚠️  **Frontman is currently in an alpha release**, which can involve breaking changes. However, we try to preserve backwards compatibility as much as possible, and we document all changes in the [changelog][changelog].

<div align="center">

# Frontman

[![CircleCI](https://circleci.com/gh/algolia/frontman/tree/master.svg?style=shield&circle-token=ea3dfd1f27a86d050cbc806d3cbd27c1742746ac)](https://circleci.com/gh/algolia/frontman/tree/master)
[![License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)][license]
[![Gem Version](http://img.shields.io/gem/v/frontman-ssg.svg?style=flat)][gem]
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/algolia/frontman/issues)

<img src="frontman.svg" alt="Frontman" height="200"/>

Frontman is a static site generator written in Ruby, optimized for speed. It helps you convert your content to static HTML files, so you can focus on your content instead of maintaining servers.

**Check out our [wiki][wiki] for detailed documentation.**

</div>

## About Frontman
Frontman is heavily inspired by [Middleman][middleman], a fantastic static site generator with a large community and feature set. We've used it for a long time, with great success.
However, once our project reached a certain size, we realized that Middleman had a few shortcomings when it comes to performance. It was becoming a serious bottleneck for us to iterate fast. After unsuccessfully trying to improve build time, we had to move away from it. Instead of undertaking a huge, lengthy migration to another tool and language, we decided to preserve our current codebase, and create our own, Middleman-inspired static site generator.

That's how Frontman was born 🚀

We created Frontman with a strong focus on speed, but also as a quick and easy replacement for Middleman. Our goal was to be able to switch from the Middleman gem to the Frontman gem in your project, and for the migration to take less than a day.

If you want to dive deeper into why and how we made Frontman faster than other tools, please watch the presentation we gave on [scaling the Algolia documentation][doc_talk].

## Installing Frontman

First, make sure you're using Ruby version 2.6 or up. Then, install the Frontman gem on your machine:

```sh
gem install frontman-ssg
```

## Creating your site

You can use the `frontman init` command to initialize a new project in the directory you provide:

```sh
frontman init my-project
```

Then, navigate to the newly created directory:

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

You can read the [Frontman documentation][wiki] to learn about all the features and possibilities.

## Contributing

We encourage you to contribute to Frontman if you have ideas for improvements to the project. 
Before you contribute, please make sure to read our [code of conduct](.github/CODE_OF_CONDUCT.md) and [contributing guidelines](CONTRIBUTING.md).

[changelog]: https://github.com/algolia/frontman/blob/master/CHANGELOG.md
[doc_talk]: https://www.youtube.com/watch?v=6feV1DrCBdE
[gem]: https://rubygems.org/gems/frontman-ssg
[license]: https://github.com/algolia/frontman/blob/master/LICENSE.md
[middleman]: https://middlemanapp.com/
[wiki]: https://github.com/algolia/frontman/wiki
