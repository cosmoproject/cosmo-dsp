#!/usr/bin/env python

import cgi

input = cgi.FieldStorage
print 'Content-type: text/html\n\n'
print 'This came all the way from a python program \
via javascript to this webpage. Do you see this?'
print 'The input was, '
print input.data
