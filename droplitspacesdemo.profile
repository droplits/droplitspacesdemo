<?php
// $Id: spacesdemo.profile,v 1.1.2.13 2009/12/17 01:37:01 yhahn Exp $

/**
 * Implementation of hook_profile_modules().
 */
function spacesdemo_profile_modules() {
  return array(
    // Core
    'color',
    'comment',
    'help',
    'menu',
    'taxonomy',
    'dblog',

    // Contrib
    'admin',
    'atrium_reader',
    'content',
    'text',
    'optionwidgets',
    'context',
    'context_layouts',
    'context_ui',
    'ctools',
    'data',
    'designkit',
    'devel',
    'devel_generate',
    'features',
    'feeds',
    'imageapi',
    'imageapi_gd',
    'imagecache',
    'jquery_ui',
    'jupiter',
    'og',
    'og_access',
    'og_views',
    'purl',
    'spaces',
    'spaces_blog',
    'spaces_dashboard',
    'spaces_og',
    'spaces_ui',
    'spaces_user',
    'strongarm',
    'views',
    'views_ui',
  );
}

/**
 * Implementation of hook_profile_details().
 */
function spacesdemo_profile_details() {
  return array(
    'name' => 'Spaces Demo',
    'description' => 'Demo of Spaces 3 + Context 3 by Development Seed.'
  );
}

/**
 * Implementation of hook_profile_task_list().
 */
function spacesdemo_profile_task_list() {
  return array();
}

/**
 * Implementation of hook_profile_tasks().
 */
function spacesdemo_profile_tasks(&$task, $url) {
  // Update the menu router information.
  menu_rebuild();

  // Rebuild the schema cache.
  drupal_get_schema(NULL, TRUE);

  // Clear caches.
  drupal_flush_all_caches();

  // Enable the right theme. This must be handled after drupal_flush_all_caches()
  // which rebuilds the system table based on a stale static cache,
  // blowing away our changes.
  _spacesdemo_system_theme_data();
  db_query("UPDATE {system} SET status = 0 WHERE type = 'theme'");
  db_query("UPDATE {system} SET status = 1 WHERE type = 'theme' AND name = 'cube'");
  db_query("UPDATE {blocks} SET region = '' WHERE theme = 'cube'");
  variable_set('theme_default', 'cube');

  // Generate groups, blog posts, comments.
  node_types_rebuild();
  module_load_include('inc', 'devel_generate', 'devel_generate');

  // Rebuild access lists.
  node_access_rebuild();

  // Create groups & feeds.
  $gids = array();
  $groups = array(
    'Jupiter' => array(
      array(
        'title' => 'Jupiter News',
        'source' => 'http://www.sciencedaily.com/rss/space_time/jupiter.xml',
        'feedtype' => 'news',
      ),
      array(
        'title' => 'Recent uploads tagged jupiter',
        'source' => 'http://api.flickr.com/services/feeds/photos_public.gne?tags=jupiter,space&tagmode=all',
        'feedtype' => 'image',
      ),
    ),
    'Mars' => array(
      array(
        'title' => 'Mars News',
        'source' => 'http://www.sciencedaily.com/rss/space_time/mars.xml',
        'feedtype' => 'news',
      ),
      array(
        'title' => 'Recent uploads tagged mars',
        'source' => 'http://api.flickr.com/services/feeds/photos_public.gne?tags=mars,space&tagmode=all',
        'feedtype' => 'image',
      ),
    ),
  );
  foreach ($groups as $title => $feeds) {
    $group = new stdClass();
    $group->type = 'group';
    $group->uid = 1;
    $group->title = $title;
    $group->og_description = devel_create_greeking(mt_rand(3, 7), TRUE);
    $group->body = devel_create_greeking(mt_rand(10, 20), TRUE);
    $group->teaser = node_teaser($group->body);
    node_save($group);

    // Store gids for group membership as well.
    $gids[] = $group->nid;

    // Create feeds in groups.
    foreach ($feeds as $feed) {
      $node = new stdClass();
      $node->type = 'feed_reader';
      $node->uid = 1;
      $node->og_groups = array($group->nid => $group->nid);
      $node->title = $feed['title'];
      $node->feeds['FeedsHTTPFetcher']['source'] = $feed['source'];
      $node->field_reader_feedtype[0]['value'] = $feed['feedtype'];
      node_save($node);
    }
  }

  // Create users
  for ($i = 0; $i < 2; $i++) {
    $account = array(
      'name' => devel_generate_word(mt_rand(6, 12)),
      'pass' => user_password(),
      'mail' => devel_generate_word(mt_rand(6, 12)) . '@' . $url['host'],
      'roles' => array(3 => 3, 4 => 4),
    );
    user_save(NULL, $account);
  }

  // Create blog posts.
  $generate = array();
  $generate['kill_content'] = FALSE;
  $generate['time_range'] = 604800;
  $generate['max_comments'] = 0;
  $generate['title_length'] = 8;
  $generate['add_upload'] = FALSE;
  $generate['add_terms'] = FALSE;
  $generate['add_alias'] = FALSE;
  $generate['add_statistics'] = FALSE;

  $blog = array('values' => $generate);
  $blog['values']['node_types'] = array('blog' => TRUE);
  $blog['values']['num_nodes'] = 30;
  $blog['values']['max_comments'] = 10;
  devel_generate_content($blog);

  // Create feed nodes.
  $feeds = array(
    array(
      'title' => 'Drupal Planet',
      'source' => 'http://drupal.org/planet/rss.xml',
      'feedtype' => 'news',
    ),
    array(
      'title' => 'Development Seed on Twitter',
      'source' => 'http://twitter.com/statuses/user_timeline/14074424.rss',
      'feedtype' => 'twitter',
    ),
    array(
      'title' => 'Pictures',
      'source' => 'http://api.flickr.com/services/feeds/photoset.gne?set=72157603970496952&nsid=28242329@N00&lang=en-us',
      'feedtype' => 'image',
    ),
  );
  foreach ($feeds as $feed) {
    $node = new stdClass();
    $node->type = 'feed_reader';
    $node->uid = 1;
    $node->title = $feed['title'];
    $node->feeds['FeedsHTTPFetcher']['source'] = $feed['source'];
    $node->field_reader_feedtype[0]['value'] = $feed['feedtype'];
    node_save($node);
  }
}

/**
 * Implementation of hook_form_alter().
 */
function spacesdemo_form_alter(&$form, $form_state, $form_id) {
  if ($form_id == 'install_configure') {
    // Set default for site name field.
    $form['site_information']['site_name']['#default_value'] = $_SERVER['SERVER_NAME'];
  }
}

/**
 * Reimplementation of system_theme_data(). The core function's static cache
 * is populated during install prior to active install profile awareness.
 * This workaround makes enabling themes in profiles/managingnews/themes possible.
 */
function _spacesdemo_system_theme_data() {
  global $profile;
  $profile = 'spacesdemo';

  $themes = drupal_system_listing('\.info$', 'themes');
  $engines = drupal_system_listing('\.engine$', 'themes/engines');

  $defaults = system_theme_default();

  $sub_themes = array();
  foreach ($themes as $key => $theme) {
    $themes[$key]->info = drupal_parse_info_file($theme->filename) + $defaults;

    if (!empty($themes[$key]->info['base theme'])) {
      $sub_themes[] = $key;
    }

    $engine = $themes[$key]->info['engine'];
    if (isset($engines[$engine])) {
      $themes[$key]->owner = $engines[$engine]->filename;
      $themes[$key]->prefix = $engines[$engine]->name;
      $themes[$key]->template = TRUE;
    }

    // Give the stylesheets proper path information.
    $pathed_stylesheets = array();
    foreach ($themes[$key]->info['stylesheets'] as $media => $stylesheets) {
      foreach ($stylesheets as $stylesheet) {
        $pathed_stylesheets[$media][$stylesheet] = dirname($themes[$key]->filename) .'/'. $stylesheet;
      }
    }
    $themes[$key]->info['stylesheets'] = $pathed_stylesheets;

    // Give the scripts proper path information.
    $scripts = array();
    foreach ($themes[$key]->info['scripts'] as $script) {
      $scripts[$script] = dirname($themes[$key]->filename) .'/'. $script;
    }
    $themes[$key]->info['scripts'] = $scripts;

    // Give the screenshot proper path information.
    if (!empty($themes[$key]->info['screenshot'])) {
      $themes[$key]->info['screenshot'] = dirname($themes[$key]->filename) .'/'. $themes[$key]->info['screenshot'];
    }
  }

  foreach ($sub_themes as $key) {
    $themes[$key]->base_themes = system_find_base_themes($themes, $key);
    // Don't proceed if there was a problem with the root base theme.
    if (!current($themes[$key]->base_themes)) {
      continue;
    }
    $base_key = key($themes[$key]->base_themes);
    foreach (array_keys($themes[$key]->base_themes) as $base_theme) {
      $themes[$base_theme]->sub_themes[$key] = $themes[$key]->info['name'];
    }
    // Copy the 'owner' and 'engine' over if the top level theme uses a
    // theme engine.
    if (isset($themes[$base_key]->owner)) {
      if (isset($themes[$base_key]->info['engine'])) {
        $themes[$key]->info['engine'] = $themes[$base_key]->info['engine'];
        $themes[$key]->owner = $themes[$base_key]->owner;
        $themes[$key]->prefix = $themes[$base_key]->prefix;
      }
      else {
        $themes[$key]->prefix = $key;
      }
    }
  }

  // Extract current files from database.
  system_get_files_database($themes, 'theme');
  db_query("DELETE FROM {system} WHERE type = 'theme'");
  foreach ($themes as $theme) {
    $theme->owner = !isset($theme->owner) ? '' : $theme->owner;
    db_query("INSERT INTO {system} (name, owner, info, type, filename, status, throttle, bootstrap) VALUES ('%s', '%s', '%s', '%s', '%s', %d, %d, %d)", $theme->name, $theme->owner, serialize($theme->info), 'theme', $theme->filename, isset($theme->status) ? $theme->status : 0, 0, 0);
  }
}