cat sos.xml | grep -i '<item>' -A 5 | grep -i '<link>' | grep -iv '/?' | perl -nle'print $1 if m{link>(.*)(?=</link>)}'
