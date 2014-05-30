#!/bin/bash

#
# PyroPruner
# Removes unused language files from your PyroCMS installation
# https://github.com/chrisfranson/PyroPruner
#
# Author: Chris Franson (chris.franson@gmail.com)
# Version: 1.0
# License: GPL v2
# Usage:
#	1. Indicate which language you want to keep by setting
#	   the 'keeplanguage' and 'keeplang' variables below.
#	2. Run this script from inside your PyroCMS document root.
#

# Config: Set these to the language you want to keep
keeplanguage='english'
keeplang='en'


# Check to make sure the user's CWD is a PyroCMS document root
if [ ! -d addons -o ! -d assets -o ! -d system -o ! -d uploads ]
	then
	echo "It doesn't look like you're in a PyroCMS doc root..."
	exit 1
fi

mypwd=$(pwd)

shopt -s extglob

pyro_modules=("addons" "blog" "comments" "contact" "domains" "files" "groups" "keywords"
			 "maintenance" "navigation" "pages" "permissions" "redirects" "search" "settings"
			 "sitemap" "sites" "streams" "streams_core" "templates" "users" "variables" "widgets" "wysiwyg")

streams_field_types=("choice" "country" "datetime" "email" "encrypt" "file" "image" "integer" "keywords"
					 "multiple" "pyro_lang" "relationship" "slug" "state" "text" "textarea" "url" "user"
					 "wysiwyg" "year")

ckeditor_plugins=("a11yhelp" "about" "adobeair" "ajax" "autogrow" "bbcode" "clipboard" "colordialog" "devtools"
				  "dialog" "div" "docprops" "fakeobjects" "find" "flash" "forms" "iframe" "iframedialog" "image"
				  "link" "liststyle" "magicline" "menubutton" "pagebreak" "pastefromword" "pastetext" "placeholder"
				  "preview" "pyrofiles" "pyroimages" "scayt" "showblocks" "smiley" "specialchar" "styles"
				  "stylesheetparser" "table" "tableresize" "tabletools" "templates" "uicolor" "wsc" "xml")

misc=("system/cms/language", "system/codeigniter/language", "addons/shared_addons/modules/api/language")


echo "Removing all languages except $keeplanguage in:"


# PyroCMS Modules
for i in "${pyro_modules[@]}"
do
	echo "$mypwd/system/cms/modules/$i/language"
	cd $mypwd/system/cms/modules/$i/language
	rm -fr !($keeplanguage)
done


# PyroStreams Field Types
for i in "${streams_field_types[@]}"
do
	echo "$mypwd/system/cms/modules/streams_core/field_types/$i/language"
	cd $mypwd/system/cms/modules/streams_core/field_types/$i/language
	rm -fr !($keeplanguage)
done


# CKEditor
echo "$mypwd/system/cms/themes/pyrocms/js/ckeditor/lang"
cd $mypwd/system/cms/themes/pyrocms/js/ckeditor/lang
rm -fr !($keeplang.js)

for i in "${ckeditor_plugins[@]}"
do
	cd $mypwd/system/cms/themes/pyrocms/js/ckeditor/plugins/$i
	if [ -d lang ]
		then
		echo "$mypwd/system/cms/themes/pyrocms/js/ckeditor/plugins/$i/lang"
		cd lang
		rm -fr !($keeplang.js)
	fi

	cd ..

	if [ -d "dialogs/lang" ]
		then
		echo "$mypwd/system/cms/themes/pyrocms/js/ckeditor/plugins/$i/dialogs/lang"
		cd dialogs/lang
		rm -fr !($keeplang.js)
	fi
done


# Misc
for i in "${misc[@]}"
do
	if [ -d "$mypwd/$i" ]
		then
		echo "$mypwd/$i"
		cd $mypwd/$i
		rm -fr !($keeplanguage)
	fi
done

cd $mypwd
