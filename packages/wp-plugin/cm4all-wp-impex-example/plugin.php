<?php

/**
 * Plugin Name: cm4all-wp-impex-example
 * Plugin URI: https://github.com/IONOS-WordPress/
 * Description: Example plugin contributing additional Importer/Exporter facilities to ImpEx plugin
 * Version: 1.5.7
 * Tags: import, export, migration
 * Requires PHP: 8.1
 * Requires at least: 6.0.2
 * Tested up to: 6.2
 * Author: lars gersmann
 * Author URI: https://github.com/IONOS-WordPress/
 * Domain Path: /languages
 **/

namespace cm4all\wp\impex\example;

// Exit if accessed directly.
if (!defined('ABSPATH')) {
  exit();
}

/*
  possible caveat : we cannot use Impex::WP_ACTION_REGISTER_PROFILES here because 
  our plugin would HARDLY DEPEND on plugin "cm4all-wp-impex" 
  => PHP WILL FAIL ion case of the absence/deactivation of cm4all-wp-impex

  solution: by using a string constant we are loosly coupled 
*/

\add_action('cm4all_wp_impex_register_profiles', function () {
  require_once __DIR__ . '/inc/impex-export-profile-example.php';
  require_once __DIR__ . '/inc/impex-import-profile-example.php';
  require_once __DIR__ . '/inc/impex-filter-profile-example.php';
});
