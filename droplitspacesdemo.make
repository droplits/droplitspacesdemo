;$Id: spacesdemo.make,v 1.2.2.5 2009/12/16 16:58:38 alexb Exp $

core = 6.x

projects[] = "ctools"
projects[] = "cck"
projects[] = "data"
projects[] = "designkit"
projects[] = "devel"
projects[] = "diff"
projects[] = "feeds"
projects[] = "imageapi"
projects[] = "imagecache"
projects[] = "og"
projects[] = "views"
projects[] = "jquery_ui"
projects[simpletest][version] = "2.8"

projects[features][type] = "module"
projects[features][download][type] = "cvs"
projects[features][download][module] = "contributions/modules/features"
projects[features][download][revision] = "DRUPAL-6--1"

projects[admin][type] = "module"
projects[admin][download][type] = "cvs"
projects[admin][download][module] = "contributions/modules/admin"
projects[admin][download][revision] = "DRUPAL-6--2"

projects[strongarm][type] = "module"
projects[strongarm][download][type] = "cvs"
projects[strongarm][download][module] = "contributions/modules/strongarm"
projects[strongarm][download][revision] = "DRUPAL-6--2"

projects[purl][type] = "module"
projects[purl][download][type] = "cvs"
projects[purl][download][module] = "contributions/modules/purl"
projects[purl][download][revision] = "DRUPAL-6--1"

projects[context][type] = "module"
projects[context][download][type] = "cvs"
projects[context][download][module] = "contributions/modules/context"
projects[context][download][revision] = "DRUPAL-6--3"

projects[spaces][type] = "module"
projects[spaces][download][type] = "cvs"
projects[spaces][download][module] = "contributions/modules/spaces"
projects[spaces][download][revision] = "DRUPAL-6--3"

projects[rubik][type] = "theme"
projects[rubik][download][type] = "git"
projects[rubik][download][url] = "git://github.com/developmentseed/rubik.git"

projects[tao][type] = "theme"
projects[tao][download][type] = "git"
projects[tao][download][url] = "git://github.com/developmentseed/tao.git"

libraries[jquery_ui][download][type] = "get"
libraries[jquery_ui][download][url] = "http://jquery-ui.googlecode.com/files/jquery.ui-1.6.zip"
libraries[jquery_ui][directory_name] = jquery.ui
libraries[jquery_ui][destination] = modules/jquery_ui

projects[atrium_reader][type] = "module"
projects[atrium_reader][download][type] = "git"
projects[atrium_reader][download][url] = "git://github.com/yhahn/atrium_reader.git"

projects[jupiter][type] = "module"
projects[jupiter][download][type] = "git"
projects[jupiter][download][url] = "git://github.com/developmentseed/Jupiter.git"



