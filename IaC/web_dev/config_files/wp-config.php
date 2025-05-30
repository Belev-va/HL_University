<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the website, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'bitnami_wordpress' );

/** Database username */
define( 'DB_USER', 'bn_wordpress' );

/** Database password */
define( 'DB_PASSWORD', '8493a0d7166fc5bd2a6eff40af4cd9f41e52011af3c3728dbe0f226f0e0618c6' );

/** Database hostname */
define( 'DB_HOST', '127.0.0.1:3306' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         'Wm!LZSO$f,k[`SDZ9k^RaK^M/1AU&`5wD7>/XK7N~T!z~jSLL6sv[X3-:30.|YIT' );
define( 'SECURE_AUTH_KEY',  '4VN]m&+@xfi`s^/40._ZH_x3DNwFM%6Jr#v{5i/xDdZY9`c~`~A|kV|}[{It|_e@' );
define( 'LOGGED_IN_KEY',    'mMRGNc%_YS+o?&/. fpZt`4`XaKG_pG97UZKRhh=e_RqN<FEcwmWy^EKW3og<.dO' );
define( 'NONCE_KEY',        'W~X7>h-X;aGz~8KDDqdf#Q^kF?r79E9S+c6#>}TT6TucP|h`ZPdBWg ~g.p([.@I' );
define( 'AUTH_SALT',        '4.z*==XG$pCc9XbsU+V!V4lM#= QbX-[Je5BF}^RW.7*$E:fQ7^^Mw9kr0M<t1jW' );
define( 'SECURE_AUTH_SALT', 'i!Y!3adB,PVgR9Fm?kh<pk{SCDB{uBR&i#mRz)uYL#S!KF|zz#yd_bj]6}Q*^?+t' );
define( 'LOGGED_IN_SALT',   '+do/];-v^ZR]F`^6.Hai|0y){[Z$]b2W[pY{r7Z4`Lr#)Yf6)wXk+_=}/+_yu_0]' );
define( 'NONCE_SALT',       'N^ZvWgu2%SzQ{g)xCYtc`|&2t+Onng&n_Qs;F<oEk+rjRA-3fm`M;,Ve_EAb_};E' );

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 *
 * At the installation time, database tables are created with the specified prefix.
 * Changing this value after WordPress is installed will make your site think
 * it has not been installed.
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/#table-prefix
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://developer.wordpress.org/advanced-administration/debug/debug-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



define( 'FS_METHOD', 'direct' );
/**
 * The WP_SITEURL and WP_HOME options are configured to access from any hostname or IP address.
 * If you want to access only from an specific domain, you can modify them. For example:
 *  define('WP_HOME','http://example.com');
 *  define('WP_SITEURL','http://example.com');
 *
 */
if ( defined( 'WP_CLI' ) ) {
        $_SERVER['HTTP_HOST'] = '127.0.0.1';
}

define('WP_HOME', 'https://www.flure.com/testing-blog');
define('WP_SITEURL', 'https://www.flure.com/testing-blog');
define( 'WP_AUTO_UPDATE_CORE', 'minor' );
/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';

/**
 * Disable pingback.ping xmlrpc method to prevent WordPress from participating in DDoS attacks
 * More info at: https://docs.bitnami.com/general/apps/wordpress/troubleshooting/xmlrpc-and-pingback/
 */
if ( !defined( 'WP_CLI' ) ) {
        // remove x-pingback HTTP header
        add_filter("wp_headers", function($headers) {
                unset($headers["X-Pingback"]);
                return $headers;
        });
        // disable pingbacks
        add_filter( "xmlrpc_methods", function( $methods ) {
                unset( $methods["pingback.ping"] );
                return $methods;
        });
}
