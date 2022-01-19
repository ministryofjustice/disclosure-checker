// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//
// GOV.UK Frontend
// https://github.com/alphagov/govuk-frontend/blob/master/docs/installation/installing-with-npm.md
//
//= require govuk-frontend/govuk/all

//= require moj
//= require_tree ./modules

$(document).ready(function() {
  // Initialize custom modules
  moj.init();

  // Cookie banner
  var $cookieBanner = document.querySelector('[data-module="govuk-cookie-banner"]');
  if ($cookieBanner) {
    new CookieBanner($cookieBanner).init();
  }
});
