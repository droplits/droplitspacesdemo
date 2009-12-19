;$Id: spacesdemo.make,v 1.1 2009/12/15 15:20:09 alexb Exp $

core = 6.x

projects[] = "ctools"
projects[] = "devel"
projects[] = "diff"
projects[] = "features"
projects[] = "og"
projects[] = "views"
projects[] = "jquery_ui"
projects[simpletest][version] = "2.8"

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
projects[context][download][type] = "git"
projects[context][download][url] = "git://github.com/yhahn/context_ctools.git"

projects[spaces][type] = "module"
projects[spaces][download][type] = "git"
projects[spaces][download][url] = "git://github.com/yhahn/spaces_experimental.git"

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
