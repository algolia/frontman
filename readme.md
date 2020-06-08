# Frontman

![Frontman](frontman.svg)

A blazing fast static site generator written in Ruby.

## Getting Started

### Requirements

Frontman requires Ruby version 2.6 or up. 

### Installation

First, you have to install the Frontman gem on your machine

```sh
bundle install frontman-ssg
```

#### Mac OSx

If you are on a Mac, be sure to install Xcode and its tools:

```sh
xcode-select --install
```

## Creating your site

You can use the `frontman init` command to initialize a new project in the directory you provide:

```sh
bundle exec frontman init my-project
```

This command will create a new directory, `my-project`, and initialize the default Frontman starter template in it.
To initialize a new Frontman project in the current directory, you can run:

```sh
bundle exec frontman init .
```

### Developing your site

To start a development server with a preview of your website, run the following command:

```sh
bundle exec frontman serve
```

### Building your site

After you are happy with your changes, you can generate the HTML for all your pages by using the following command:

```sh
bundle exec frontman build
```

## Contributing

We encourage you to contribute to Frontman if you have ideas for improvements to the project. 
Before you contribute, please make sure to read our [code of conduct](.github/CODE_OF_CONDUCT.md) and [contributing guidelines](CONTRIBUTING.md).