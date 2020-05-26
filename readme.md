# Frontman

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
If you are on a Mac, be sure to install Xcode an its tools:
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

### Directory Structure
A freshly bootstrapped Frontman project has the following contents:
```
- app_data/
    - site.yml
- config.rb
- source/
    - index.html.md.erb
    - ...
- views/
    - layouts/
        - ...
    - partials/
        - ...
```

// TODO: explain app_data/ 

Frontman uses the `config.rb` to setup your application. 
By default, it will load all the files in the `source/` folder, and add them to the sitemap.

The `source/` folder contains all your pages. Frontman will automatically format the URL of the page based on the path of the page.
For example, Frontman exposes the `source/hello-world.html.md` file at `/hello-world/index.html` (and therefore `/hello-world/`). The same goes for `source/hello-world/index.html.md`

// TODO: explain views/ 


### Developing your site
#### Starting a development server
To start a development server with a preview of your site, run the following command:
```sh
bundle exec frontman serve
```

#### Modifying content
By default, all files in your `source` folder are considered pages. 
During development, Frontman will watch this directory for changes, and automatically apply the changes without you having to restart the server.
When you add a page, the URL of this page will match the filename. For example, the URL for the file `source/about.md` will be `/about/index.html`, and therefore be accesible through `/about/`.

Each source file can have multiple extensions, and Frontman will render each extension in reverse order. 
For example, if you have a `source/posts.md.erb` file, Frontman will _first_ parse the ERB in your file, and after that the Markdown.   

#### Reusing content
To reuse content, you can place it in a YAML file in your `app_data` folder.

### Building your site
After you are happy with your changes, you can generate the HTML for all your pages by using the following command:
```sh
bundle exec frontman build
```

This will build all your pages and place the generated HTML in the `build/` folder at the root of your project. 
To improve performance, Frontman builds your pages in parallel by default. 
To build your pages synchronously, simply append the `--sync` option:
```sh
bundle exec frontman build --sync
``` 

Please note that Frontman does **not** generate your assets. It's your job to generate production-ready assets, and put them in the right place.
You should do this **before** generating your pages with Frontman.

After you build your pages and assets, they are ready for deployment to your platform of choice. 

## Concepts
### Sitemap
### Templating languages
### Frontmatter
### Helper methods
### Layouts
### Partials
### Dynamix Pages
### Redirects

## Contributing
