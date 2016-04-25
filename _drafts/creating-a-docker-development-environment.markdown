---
layout: default
---

# Creating a [Docker](/) development environment

Today I'm going to cover how to setup a development environment using Docker.

## Why use Docker for development

Put simply, containers allow you to encapsulate your application and its operational
needs. For all intents and purposes, a container can be considered a lightweight
operating system dedicated just for your application. This level of isolation, combined
with Docker's ability to create snapshots of containers (also known as Docker images)
which store your application's library dependencies and system configurations allow you to create
reproducible environments that can be easily shared.

When doing distributed development, having a reproducible environment
can reduce the overhead of onboarding new team members, and reduce the likeliness of
errors related to inconsistent dependency versions.

## Building a simple Ruby on Rails development environment

The first step in creating a development environment is understanding what are your
core development dependencies. In a Rails application it is pretty obvious you are
going to need Ruby and its ecosystem. Besides Ruby, depending on the application
you are developing, you may need a database; For this example, I'll use [Postgres](/)
given that it is one of the most commonly used databases and it is easy to get a
working example with Rails.

### **Building your first container**

We will need be to create a Ruby container; We do this by telling Docker
to create a container based on the Ruby image (or snapshot, if this facilitates
building a mental picture). Run the following:

{% highlight sh %}
docker run --interactive --tty --rm ruby irb
irb(main):001:0> RUBY_VERSION
=> "2.3.0"
{% endhighlight %}

I generally recommend not to dwell on the many flags and switches the Docker CLI supports, because
it can be overwhelming. However, to test the above, we needed to use the
`--interactive` flag to allow the container to receive input through `STDIN`
and the `--tty` flag to allow the container to write to `STDOUT`, therefore
allowing us to interact with the `irb` shell. The `--rm` flag cleans up the container once
it is done running. (This is good for one off tasks like the above).

### **Put your code in the container**

To allow the Ruby ecosystem to perform development tasks in the context of your
code base, you need to allow the Ruby container to access your code. You can do this
in many interesting ways but in my experience, the most practical is to use volumes.

Unlike a container, a volume is a shared, persitent space. For the purpose of this post,
I will focus on two types of volumes. There are volumes that are mounted to a
container from a specified directory on the host machine, and there are volumes that are
mounted to a container from a dynamically generated directory.

To put your code in the container, we will create a volume mounted to the directory
of your code. This is done with the `--volume` option.

{% highlight sh %}
docker run --interactive --tty --rm --volume $(pwd):/usr/src/my-app ruby irb
{% endhighlight %}


--------------------------------------------------------------------------------

To create a Docker development environment we'll leverage [Docker Compose](/),
a tool that allows you to define container templates.

Our first step will be to define our Ruby container, this container will be responsible
for hosting our code and having all of the development tools that come from the
Ruby ecosystem. We do this by creating a `docker-compose.yml` file and adding
the following:

{% highlight yaml %}
version: "2"
services:
  app:
    image: "ruby"
{% endhighlight %}

This alone gives you access to a Ruby environment. You can test this out by running:
(Note that, if this is your first time creating a Ruby container, docker will try to pull
the Ruby image from docker hub. Make you that you have internet access)

{% highlight sh %}
docker-compose run --rm app
...
irb(main):001:0>
{% endhighlight %}

{% comment %}

# Potential sections

- major pain points when doing development with docker



To start lets say we have the following Rails application.

{% highlight plain %}
my-rails-app
| - app/
| - bin/
| - config/
| - db/
| - log/
| - test/
| - tmp/
| - vendor/
| - config.ru
| - Gemfile
| - Gemfile.lock
| - Rakefile
| - README.md
{% endhighlight %}




{% highlight sh %}
{% endhighlight %}

# Case study

Simple rails project

# Steps

- Create a `docker-compose.yml` file
- Declare your containers
  ei.

{% highlight yaml %}
version: "2"
services:
  app:
    image: ruby:2.3
    volumes:
      - .:/usr/src/my-app
    workind_dir: /usr/src/my-app
    network_mode: host

  db:
    image: postgres
    environment:
      POSTGRES_USER: my_app
    network_mode: host
{% endhighlight %}

- Create data volumes
{% highlight yaml %}
version: "2"
services:
  app:
    image: ruby:2.3
    volumes:
      - .:/usr/src/my-app
      - gems:/usr/local/bundle
    workind_dir: /usr/src/my-app
    network_mode: host

  db:
    image: postgres
    environment:
      POSTGRES_USER: my_app
    network_mode: host

volumes:
  gems:
    driver: local
{% endhighlight %}

- Create alias file to facilitate working with multiple containers

- Adjust vm to use more cores (if applicable)

{% endcomment %}
