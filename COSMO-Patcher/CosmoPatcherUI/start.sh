#!/bin/bash
# update the list of effects and arguments
python effects.py
echo "effects collected, updated"
# start a web server
python -m SimpleHTTPServer 8888 &
# CGI webserver if we also want to run python functions
# from the site
#  python -m CGIHTTPServer 8888
echo "web server started as a background process"
# save the webserver pid
SIMPLE_SERVER_PID=$!
echo "web server process id: "$SIMPLE_SERVER_PID
# open the design page
xdg-open http://localhost:8888
