# Frontman

[![CircleCI](https://circleci.com/gh/algolia/frontman/tree/master.svg?style=shield&circle-token=ea3dfd1f27a86d050cbc806d3cbd27c1742746ac)](https://circleci.com/gh/algolia/frontman/tree/master)
[![License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)][license]
[![Gem Version](http://img.shields.io/gem/v/frontman-ssg.svg?style=flat)][gem]


![Frontman](frontman.svg)

Frontman is a static site generator written in Ruby, optimized for speed. It helps you convert your content to static HTML files, so you can focus on your content instead of maintaining servers.

## About Frontman
Frontman has been built to satisfy our own needs: we want to iterate fast to continually improve. Existing tools did not provide us the freedom we need to do this, because these tools are optimized for flexibility over speed.
Frustrated with the increasing build times of otherwise great tools, we decided to create a custom static site generator that is built with one thing in mind: speed. No matter the size or complexity of your project, Frontman generates the HTML faster than any other Ruby-based static site generator out there.
If you want to dive deeper into why and how we made Frontman faster than other tools, please watch the presentation we gave on [scaling the Algolia documentation][doc_talk].

## Getting Started

### Requirements

Frontman requires Ruby version 2.6 or up. 

### Installation

First, you have to install the Frontman gem on your machine

```sh
gem install frontman-ssg
```

## Creating your site

You can use the `frontman init` command to initialize a new project in the directory you provide:

```sh
frontman init my-project
```

This command will create a new directory, `my-project`, and initialize the default Frontman starter template in it.
To initialize a new Frontman project in the current directory, you can run:

```sh
frontman init .
```

### Developing your site

To start a development server with a preview of your website, run the following command:

```sh
frontman serve
```

### Building your site

After you are happy with your changes, you can generate the HTML for all your pages by using the following command:

```sh
frontman build
```

## Contributing

We encourage you to contribute to Frontman if you have ideas for improvements to the project. 
Before you contribute, please make sure to read our [code of conduct](.github/CODE_OF_CONDUCT.md) and [contributing guidelines](CONTRIBUTING.md).

[gem]: https://rubygems.org/gems/frontman-ssg
[license]: https://github.com/algolia/frontman/blob/master/LICENSE.md
[doc_talk]: https://www.youtube.com/watch?v=6feV1DrCBdE
