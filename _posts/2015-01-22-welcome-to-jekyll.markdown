---
layout: post
title:  "Test blog post"
subtitle: "LOLLllllllllll"
date:   2015-01-22 22:32:31
categories: jekyll update
author: "Prashant Sinha"
hero: /assets/img/progresso_oli_2014309_lrg copy.jpg
---
You’ll find this post in your `_posts` directory. Go ahead and edit it and re-build the site to see your changes. You can rebuild the site in many different ways, but the most common way is to run `jekyll serve --watch`, which launches a web server and auto-regenerates your site when a file is updated.

To add new posts, simply add a file in the `_posts` directory that follows the convention `YYYY-MM-DD-name-of-post.ext` and includes the necessary front matter. Take a look at the source for this post to get an idea about how it works.

Jekyll also offers powerful support for code snippets:

#Code

{% highlight python %}
import argparse
import cssutils
import os
import re
import uuid
import urllib.request

options = {
    'dir_location': os.curdir + os.sep + 'fonts',
    'css_location': os.curdir,
    'relative_uri': 'fonts/',
    'output_css': str(uuid.uuid4()),
    'debug': False
}

class imitator:
    """
    Pretends to be a browser and downloads the supplied URL. The User Agent
    Strings are supplied in the headers.
    """

    user_agents = {
        'self': 'Mozilla/5.0 Chrunch Google Fonts',
        'chrome_mac': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.94 Safari/537.36',
        'safari_mac': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/7046A194A'
    }

    def fetch(self, uri, browser = user_agents['self']):
        """
        Here used to download a CSS string, pretending to be a Browser.
        """
        opener = urllib.request.build_opener()
        opener.addheaders = [('User-agent', self.user_agents[browser])]
        try:
            return (opener.open(uri).read())
        except:
            return False

    def download(self, uri, location):
        """
        Used here to download the Font Files into the said location.
        """
        return urllib.request.urlretrieve(uri, location)[0]

class attribute_dictionary():
    """
    Parses, Modifies, and Returns the attribute dictionary. Sample attribute
    dictionary is of form:
    Example: a(val_a), b( "val_b" ), a('val_c'). Notice the varying Quotes, and Spaces.
    The above attribute dictionary is parsed to a Python Dictionary-like interface as
    source = {
        a: "val_a",
        b: "val_b",
        a: "val_c"
    }
    Notice that the values are automatically type-promoted/type-casted to String.
    Also, the keys are positional - not named.

    All properties are Greedy.
    """

    def __init__(self, source):
        """Initializes the class instance."""
        self.source = source
        self.pattern = r"[ \"\']*" + r"{0}" + r"\(" + r"[ \"\']*" + r"(.*?)" + r"[ \"\']*" + r"\)" + r"[ \"\']*"

    def get(self, key):
        """
        Returns the Values associated with the key. Since the attribute_dictionary
        can inherently have multiple values, this always returns a List containing
        every encountered value of the given Key. Returns an empty List in case of
        invalid key.
        Greedy.
        """
        pattern = self.pattern.format(key)
        return re.findall(pattern, self.source)

    def set(self, key, value):
        """
        Sets the value associated to the given key. If the "value" argument is
        passed a String, Every Instances of the Key in the attribute_dictionary
        are set to this String.
        If the value argument is passed a List, instead, The "positional" values
        of the Key are set in the order of appearance in the List. Obviously the
        dimension of value must be equal to the number of occurrence of the key
        (len(get(key))).
        Greedy.
        """
        dat = self.get(key)
        pattern = self.pattern.format(key)

        if type(value) is list:
            if len(dat) == len(value):
                value = value[::-1]
                self.source = re.sub(pattern, lambda match: " {0}({1}) ".format(key, value.pop()), self.source)
                return True
            else:
                return False
        elif type(value) is str:
            self.source = re.sub(pattern, " {0}({1}) ".format(key, value), self.source)
            return True
        else:
            return False

    def stringify(self):
        """Returns the String representation of attribute_dictionary."""
        return self.source

class crunch:
    """
    Provides methods to Crunch the CSS URI.
    """

    def __init__(self):
        """
        Prepares the class instance, sets the imitator instance, and retrieves defaults.
        """
        self.stylesheets = []
        self.dir_location = options['dir_location']
        self.file_name = self.dir_location + os.sep + '{0}'
        if not os.path.isdir(self.dir_location):
            os.makedirs(self.dir_location)

    def routine(self, css):
        """
        Carries out the routine in this order:
        1. Finds the FONT_FACE_RULE in the CSS.
        2. Gets all the font sources that get us "url" to the remote font.
        3. Call the sub routine "get_font_from_source" that fetches all the fonts
           and returns the new attributes.
        Always returns true.
        """

        self.stylesheets.append(cssutils.parseString(css))

        for rule in self.stylesheets[-1]:
            if rule.type == rule.FONT_FACE_RULE:
                for prop in rule.style:
                    if prop.name == 'src':
                        font_sources = prop.value
                        new_sources = self.get_font_from_source(font_sources)
                        prop.value = new_sources
        return True

    def get_font_from_source(self, value):
        """
        This sub routine takes in the attributes_list, and iterates over all the
        'url' elements. It downloads all the Fonts at the said url, and replaces
        the attributes_list variables to the new location.
        Returns the new attributes_list.
        """

        attributes_list = attribute_dictionary(value)
        font_list = attributes_list.get('url')
        replacement_list = []

        for font in font_list:
            font_file_name = self.f_name()
            font_location = self.file_name.format(font_file_name)
            saved_font_uri = imitator().download(font, font_location)
            replacement_list.append(options['relative_uri'] + font_file_name)

        attributes_list.set('url', replacement_list)
        
        progress("OKA: Downloaded {0} font.".format(len(font_list)))

        return attributes_list.stringify()

    def f_name(self):
        """Returns a Random Name for any purpose. Uses UUID."""
        return str(uuid.uuid4())

    def save_stylesheet(self):
        """Saves the final output css."""
        file_loc = options['css_location'] + os.sep + options['output_css'] + ".css"
        with open(file_loc, "wb") as Minion:
            for sheet in self.stylesheets:
                Minion.write(sheet.cssText)
                Minion.write(b"\r\n")
        return True

def fetch(base_stylesheet_uri):
    css_reparser = crunch()

    for browser, user_agents in imitator.user_agents.items():
        progress("OKA: Beginning download Routine for '{0}'.".format(browser), True)
        returned_css = imitator().fetch(base_stylesheet_uri, browser)
        try:
            css_reparser.routine(returned_css)
        except:
            progress("ERR: Aborting routine for '{0}'. Bad CSS retrieved.".format(browser), True)
    
    progress("OKA: Saving the Style sheet.", True)
    css_reparser.save_stylesheet()

def progress(str, force = False):
    if options['debug']:
        print(str)
    elif force:
        print(str)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description = 'Crunches the Google Font CSS, and liberates them from their Server! Very helpful, if you want to test your website locally, or, serve over your own Server/CDN.',
        prog = 'Crunch Google Fonts'
    )

    parser.add_argument(
        '-s',
        "--source",
        nargs = '?',
        help = 'The CSS URI, obtained from Google Fonts Service..',
        required = True)
    parser.add_argument(
        '-d',
        "--destination",
        nargs = '?',
        default = options['dir_location'],
        help = 'Destination where to Store the Fonts.')
    parser.add_argument(
        '-p',
        "--css_path",
        nargs = '?',
        default = options['css_location'],
        help = 'Destination where to store the CSS file.')
    parser.add_argument(
        '-r',
        "--relative_path",
        nargs = '?',
        default = options['relative_uri'],
        help = 'The URI prefix, where the Fonts will be hosted.')
    parser.add_argument(
        '-o',
        "--output",
        nargs = '?',
        default = options['output_css'],
        help = 'Output name of the CSS file. Must not be already in the directory - raises and IO Exception.')
    args = parser.parse_args()

    options['dir_location'] = args.destination
    options['css_location'] = args.css_path
    options['relative_uri'] = args.relative_path
    options['output_css'] = args.output

    fetch(args.source)

{% endhighlight %}

Check out the [Jekyll docs][jekyll] for more info on how to get the most out of Jekyll. File all bugs/feature requests at [Jekyll’s GitHub repo][jekyll-gh]. If you have questions, you can ask them on [Jekyll’s dedicated Help repository][jekyll-help].

{% include image url="/assets/img/progresso_oli_2014309_lrg%20copy.jpg" description="My cat, Robert Downey Jr." %}


Check out the [Jekyll docs][jekyll] for more info on how to get the most out of Jekyll. File all bugs/feature requests at [Jekyll’s GitHub repo][jekyll-gh]. If you have questions, you can ask them on [Jekyll’s dedicated Help repository][jekyll-help].

[jekyll]:      http://jekyllrb.com
[jekyll-gh]:   https://github.com/jekyll/jekyll
[jekyll-help]: https://github.com/jekyll/jekyll-help

