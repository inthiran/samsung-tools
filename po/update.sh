#!/bin/bash
# This script creates a new template 'samsung-tools.pot', and updates all translations against it

echo "*** Extracting strings from *.glade files..."
intltool-extract --type=gettext/glade gui/glade/*.glade
mv gui/glade/*.glade.h .

echo
echo "*** Creating samsung-tools.pot..."
xgettext -k_ -kN_ -o po/samsung-tools.pot `cat po/FILES` *.glade.h

echo
echo "*** Removing unneeded files..."
rm *.glade.h

for locale in `cat po/LINGUAS`; do
	if [ -f po/$locale.po ]; then
		echo "*** Updating '`echo $locale.po | cut -d/ -f2`'..."
		msgmerge -U po/$locale.po po/samsung-tools.pot
	else
		echo "*** Creating new '`echo $locale.po | cut -d/ -f2`'..."
		cp po/samsung-tools.pot po/$locale.po
	fi
done