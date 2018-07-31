<?php
function site_scripts() {
    // Register Custom styles
    wp_enqueue_style( 'custom-css', get_template_directory_uri() . '/css/custom.css', array(), "6.4.1", 'all' );

    // Adding custom scripts file in the footer
    wp_enqueue_script( 'custom-js', get_template_directory_uri() . '/assets/js/custom/custom.js', array( 'jquery' ), '', true );

    // Register main stylesheet
    wp_enqueue_style( 'site-css', get_template_directory_uri() . '/assets/css/custom.css', '', 'all' );

    // Comment reply script for threaded comments
    if ( is_singular() AND comments_open() AND (get_option('thread_comments') == 1)) {
      wp_enqueue_script( 'comment-reply' );
    }
}
add_action('wp_enqueue_scripts', 'site_scripts', 999);