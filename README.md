[![noop.pw](riptide/assets/img/misc/banner-gh.png)](https://noop.pw)

This repo contains source code for my homepage at [noop.pw](https://noop.pw).

You may be looking for source of my [resume](https://noop.pw/resume).

[![Build Status](https://travis-ci.org/prashnts/prashnts.github.io.svg?branch=master)](https://travis-ci.org/prashnts/prashnts.github.io)
[![Greenkeeper badge](https://badges.greenkeeper.io/prashnts/prashnts.github.io.svg)](https://greenkeeper.io/)

[![Deploy to Netlify](https://www.netlify.com/img/deploy/button.svg)](https://app.netlify.com/start/deploy?repository=https://github.com/prashnts/prashnts.github.io)

## Quickstart
- Install packages. Use `npm install`, or `yarn install` if you use `yarnpkg`.
- Build site using `npm run build`. The static content will be in `public` directory.
- To use live-reload and in-built dev server, use `npm run start`.
- Tests are written using `mocha` and `chai`. Use `npm run test` to run them.

## More info
The resume is built using a combination of `pugjs` [template](riptide/markup/resume.jade) and `brunch` hooks.
Content is structured in a [`yaml` file](riptide/vita.yaml), which is transformed using [`demi`](demi/demi.coffee).
During transformation, the markdown in `yaml` is rendered to `html`, date-times are parsed and formatted to
more human readable format, and then passed to the template which renders a static html.


Thanks to [**Netlify**](https://www.netlify.com/open-source/) for powering this website. They're awesome!

## License
MIT
