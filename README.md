This is a rails app designed to use browserstack to take screenshots of local or remote apps.

Ruby docs here https://www.browserstack.com/automate/ruby

You need an account at browserstack.com

Set your environment variables

Download and unzip command line interface tool from http://www.browserstack.com/local-testing#command-line
Move it to /usr/local/bin so it can be accessed from a rake task
$ sudo mv BrowserStackLocal /usr/bin/BrowserStackLocal

$ rails s
...in a separate terminal...
$ rake test:browserstacklocal
...in a separate terminal...
$ rake test:cross_browser

Screenshots are saved to tmp/screenshots_*

To clean out tmp/ of screenshots:
$ rake test:delete_screenshots

Environment variables
set ENV["NODES"] to the number of nodes available in BrowserStack to run in parallel
set ENV["BROWSERSTACK_USERNAME"] to your browserstack username
set ENV["BROWSERSTACK_ACCESS_KEY"] to your browserstack access key

In ~/.bash_profile:
export NODES=...
export BROWSERSTACK_USERNAME=...
export BROWSERSTACK_ACCESS_KEY=...
source ~/.bash_profile (or restart terminal)

### Selecting the browsers you wish to test

http://www.browserstack.com/automate/ruby#setting-os-and-browser
http://www.browserstack.com/automate/capabilities
http://www.browserstack.com/list-of-browsers-and-platforms?product=automate

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
