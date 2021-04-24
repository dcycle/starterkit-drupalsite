/**
 * @file
 * Manage budget form.
 */

// @codingStandardsIgnoreStart
(function ($, Drupal, drupalSettings) {
  Drupal.behaviors.DcycleDrupalStarterkit = {
    attach: function (context, settings) {
      // This is just to demonstrate unit testing.
      // See also
      // ./drupal/custom-modules/my_custom_module/js/DcycleDrupalStarterkit.js
      // ./scripts/unit-js.sh
      console.log(DcycleDrupalStarterkit.welcomeMessage());
    }
  };
})(jQuery, Drupal, drupalSettings);
// @codingStandardsIgnoreEnd
