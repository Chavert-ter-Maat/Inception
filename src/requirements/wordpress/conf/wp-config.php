<?php

// Load environment variables from .env file
$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', getenv('WORDPRESS_DB_NAME') );
/** MySQL database username */
define( 'DB_USER', getenv('WORDPRESS_DB_USER') );
/** MySQL database password */
define( 'DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD') );
/** MySQL hostname */
define( 'DB_HOST', getenv('WORDPRESS_DB_HOST') );

define( 'DB_CHARSET', 'utf8' );

define('WPMS_ON', false ); # Turn off email feature, otherwise error during build

$table_prefix = 'wp_';

if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';
?>