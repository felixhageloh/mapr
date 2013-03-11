mapr
===============

A little web app with an original name that uses google maps to display a stream of locations on a map. 
It expects a backend which it polls at /update for new locations. The current backend uses a list of
ips and looks up their location using www.geoplugin.net.

Getting started
---------------

You need to have [nodejs](http://nodejs.org) and [coffeescript](http://coffeescript.org) installed. In the 
mapr dir run

    npm install

to install all dependencies. Then run
  
    coffee server

to start the server. It will automatically listen to changes on mapr.coffee and compile it.


That's it; you read me.