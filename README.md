This is a rails app designed to use browserstack to take screenshots of local or remote apps.

Browserstack ruby docs [https://www.browserstack.com/automate/ruby](https://www.browserstack.com/automate/ruby)

### Setup

1. You need an account at browserstack.com
1. Set your environment variables

		set ENV["NODES"] to the number of nodes available in BrowserStack to run in parallel
		set ENV["BROWSERSTACK_USERNAME"] to your browserstack username
		set ENV["BROWSERSTACK_ACCESS_KEY"] to your browserstack access key

		In ~/.bash_profile:
		export NODES=...
		export BROWSERSTACK_USERNAME=...
		export BROWSERSTACK_ACCESS_KEY=...
		$ source ~/.bash_profile (or restart terminal)
1. Download and unzip command line interface tool from [http://www.browserstack.com/local-testing#command-line](http://www.browserstack.com/local-testing#command-line)
1. Move it to /usr/local/bin so it can be accessed from a rake task

		$ sudo mv BrowserStackLocal /usr/bin/BrowserStackLocal

### Usage

The rake task test:cross_browser takes the following arguments

* local ( true|false, optional, default true) - tell browserstack to use local testing mode - localhost:3000 will resolve to your machine

To test a local site

		# In project you want to test
		$ rails s
		...in a separate terminal...
		# In screenshot-me
		$ rake test:browserstacklocal
		...in a separate terminal...
		# In screenshot-me
		$ rake test:cross_browser[true]
		
To test a publicly availiable site

		# In screenshot-me
		$ rake test:browserstacklocal
		...in a separate terminal...
		# In screenshot-me
		$ rake test:cross_browser[false]

Screenshots are saved to tmp/screenshots_*

To delete all screenshots from tmp/

		$ rake test:delete_screenshots

### Selecting the browsers you wish to test

[http://www.browserstack.com/automate/ruby#setting-os-and-browser](http://www.browserstack.com/automate/ruby#setting-os-and-browser)

[http://www.browserstack.com/automate/capabilities](http://www.browserstack.com/automate/capabilities)

[http://www.browserstack.com/list-of-browsers-and-platforms?product=automate](http://www.browserstack.com/list-of-browsers-and-platforms?product=automate)

In your browsers.json, you specify the set of capabilities you want.

Our task supports arrays and will expand the browser list if you use arrays.  For example, the following will run 9 tests:

Win7+FF27, Win7+FF26, Win7+FF25, Win8+FF27, Win8+FF26, Win8+FF25, Win8.1+FF27, Win8.1+FF26, Win8.1+FF25

		[
			{
        		"browser": "firefox",
        		"browser_version": ["27.0","26.0","25.0"],
        		"device": null,
        		"os": "Windows",
        		"os_version": ["7","8","8.1"]
    		}
		]
