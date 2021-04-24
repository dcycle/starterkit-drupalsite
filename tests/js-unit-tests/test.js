const test = require('ava');
const sinon = require('sinon');

var my = require('/mycode/custom-modules/my_custom_module/js/DcycleDrupalStarterkit.js');

test('Welcome message makes sense', t => {
  // See https://github.com/dcycle/docker-ava for more
  // complex tests with stubbing.
  t.true(my.welcomeMessage() == "Welcome to Dcycle Drupal Starterkit");
})
