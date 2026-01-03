# Siwapp

[API Documentation](https://github.com/mamhoff/friendly_invoice/blob/master/API_DOC.md)

## SMTP Configuration

In order to be able to send emails through the app, you must configure the following environment variables in your system:

```
SMTP_HOST
SMTP_PORT
SMTP_DOMAIN
SMTP_USER
SMTP_PASSWORD
SMTP_AUTHENTICATION (plain | login | cram_md5)
SMTP_ENABLE_STARTTLS_AUTO (set to 1 to enable it)
```

## How to Install on Heroku

First clone the friendly_invoice repository into your computer:

    $ git clone https://github.com/friendly_invoice/friendly_invoice.git
    $ cd friendly_invoice

Create the app in heroku (we suppose in the terminal your are logged
in heroku). Here we call the app "friendly_invoice-demo", but choose whatever
you like.

    $ heroku apps:create friendly_invoice-demo
    $ heroku apps:create --region eu --buildpack heroku/ruby friendly_invoice-demo
    $ heroku addons:create heroku-postgresql
    $ heroku addons:create scheduler:standard

Push the code to heroku, and setup database.

    $ git push heroku
    $ heroku run rake db:setup

Finally create an user to be able to login into the app.

    $ heroku run "rake friendly_invoice:user:create['demo','demo@example.com','secret_password']"

If you want the recurring invoices to be generated automatically, you have to setup the heroku scheduler addon:

    $ heroku addons:open scheduler

Add a new job, and put "rake friendly_invoice:generate_invoices"

That's it! You can enjoy friendly_invoice now entering on your heroku app url.

    $ heroku apps:open
