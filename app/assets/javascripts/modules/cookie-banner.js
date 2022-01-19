'use strict';

function nodeListForEach(nodes, callback) {
  if (window.NodeList.prototype.forEach) {
    return nodes.forEach(callback)
  }
  for (var i = 0; i < nodes.length; i++) {
    callback.call(window, nodes[i], i, nodes)
  }
}

function CookieBanner($module) {
  this.$module = $module
}

CookieBanner.prototype.init = function() {
  this.$cookieBanner = this.$module
  this.$cookieBannerHideButtons = this.$module.querySelectorAll('.app--js-cookie-banner-hide')

  nodeListForEach(this.$cookieBannerHideButtons, function($cookieBannerHideButton) {
    $cookieBannerHideButton.addEventListener('click', this.hideBanner.bind(this))
  }.bind(this))
};

CookieBanner.prototype.hideBanner = function(e) {
  this.$cookieBanner.setAttribute('hidden', true)
  e.preventDefault()
};
