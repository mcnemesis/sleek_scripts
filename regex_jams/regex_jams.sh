#!/usr/bin/sh

#play music matching given regex under current directory recursively...
#depends on mplayer (http://www.mplayerhq.hu/design7/dload.html)

function regex_jams {
    find  . -regex "$1" | sed 's/^/"/;s/$/"/' | xargs -I_ mplayer _
}

#incase someone execs the script itself...
regex_jams "$1"
