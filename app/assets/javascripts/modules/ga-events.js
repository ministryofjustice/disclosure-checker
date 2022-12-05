'use strict';

moj.Modules.gaEvents = {
    radioFormClass: '.govuk-radios__item input[type="radio"]',
    dateFormClass: '.govuk-date-input input[type="text"]',
    checkboxClass:  '.govuk-checkboxes__item input[type="checkbox"]',
    linkClass: '.ga-pageLink',
    revealingLinkClass: '.govuk-details__summary span.govuk-details__summary-text',

    init: function() {
        window.onload = function() { setTimeout('moj.Modules.gaEvents.pageLoaded()',1000); }
    },

    pageLoaded: function() {
        var self = this;

        // don't bind anything if the GA object isn't defined
        if (typeof window.ga !== 'undefined') {
            if ($(self.radioFormClass).length) {
                self.trackRadioForms();
            }
            if ($(self.dateFormClass).length) {
                self.trackDateForms();
            }
            if ($(self.checkboxClass).length) {
                self.trackCheckboxes();
            }
            if ($(self.linkClass).length) {
                self.trackLinks();
            }
            if ($(self.revealingLinkClass).length) {
                self.trackRevealingLinks();
            }
            // External links, tracked as GA outbound events
            if ($("a[rel^=external]").length) {
                self.trackExternalLinks();
            }
        }
    },

    trackRadioForms: function () {
        var self = this,
            $form = $(self.radioFormClass).closest('form');

        // submitting GA tracked radio groups is intercepted[1] until the GA event
        // has been sent, by sending target to make a callback[2]
        $form.on('submit', function (e) {
            var eventDataArray,
                options;

            e.preventDefault(); // [1]

            eventDataArray = self.getRadioChoiceData($form);

            if (eventDataArray.length) {
                // there could be multiple radios that are checked and need a GA event firing,
                // but we only want to submit the form after sending the last one
                eventDataArray.forEach(function (eventData, n) {
                    if (n === eventDataArray.length - 1) {
                        options = {
                            actionType: 'form',
                            actionValue: $form // [2]
                        };
                    }

                    self.sendAnalyticsEvent(eventData, options);
                });
            } else {
                $form.unbind('submit').trigger('submit');
            }
        });
    },

    trackDateForms: function () {
        var self = this,
            $form = $(self.dateFormClass).closest('form');

        $form.on('submit', function (e) {
            var eventDataArray,
                options;

            e.preventDefault(); // [1]

            eventDataArray = self.getDateYearData($form);

            if (eventDataArray.length) {
                // there could be multiple dates that need a GA event firing,
                // but we only want to submit the form after sending the last one
                eventDataArray.forEach(function (eventData, n) {
                    if (n === eventDataArray.length - 1) {
                        options = {
                            actionType: 'form',
                            actionValue: $form // [2]
                        };
                    }

                    self.sendAnalyticsEvent(eventData, options);
                });
            } else {
                $form.unbind('submit').trigger('submit');
            }
        });
    },

    trackCheckboxes: function () {
        var self = this,
            $form = $(self.checkboxClass).closest('form');

        // submitting forms containing a GA tracked checkbox is intercepted[1]
        // until the GA event has been send, by sending target to make a
        // callback[2], unless no GA checkboxes in the form are checked, in which
        // case unbind and submit the form directly[3]
        $form.on('submit', function (e) {
            var eventDataArray,
                options;

            e.preventDefault(); // [1]

            eventDataArray = self.getCheckboxFormData($form);

            if (eventDataArray.length) {
                // there could be multiple GA checkboxes that are checked and need a
                // GA event firing, but we only want to submit the form after sending
                // the last one
                eventDataArray.forEach(function (eventData, n) {
                    if (n === eventDataArray.length - 1) {
                        options = {
                            actionType: 'form',
                            actionValue: $form // [2]
                        };
                    }

                    self.sendAnalyticsEvent(eventData, options);
                });
            } else {
                $form.unbind('submit').trigger('submit'); // [3]
            }
        });
    },

    trackLinks: function () {
        var self = this,
            $links = $(self.linkClass);

        // following GA tracked links is intercepted[1] until the GA event has
        // been sent, by sending target to make a callback[2]
        $links.on('click', function (e) {
            var $link = $(e.target),
                eventData,
                options;

            e.preventDefault(); // [1]

            eventData = self.getLinkData($link);
            options = {
                actionType: 'link',
                actionValue: $link // [2]
            };

            self.sendAnalyticsEvent(eventData, options);
        });
    },

    trackRevealingLinks: function() {
        var self = this,
            $links = $(self.revealingLinkClass);

        $links.on('click', function() {
            var $link = $(this),
                eventData,
                options;

            eventData = self.getLinkData($link);
            options = {
                actionType: 'revealing_link',
                actionValue: $link
            };

            // Only track when opening the details, not on close
            if ($link.closest('details:not([open])').length && eventData.eventCategory) {
                self.sendAnalyticsEvent(eventData, options);
            }
        });
    },

    // This function will not send to GA the query string, as frequently
    // this may contain personal identification or secure tokens.
    trackExternalLinks: function() {
        $("a[rel^=external]").on('click', function(e) {
            var $el = this,
                url = $el.href,
                target = $el.target || '_self',
                event_url = url.replace($el.search, '');

            window.open(url, target);
            ga('create', 'UA-113317790-4');
            ga('send', 'event', 'outbound', 'click', event_url, {});

            e.preventDefault();
        });
    },

    getLinkData: function ($link) {
        var eventData;

        eventData = {
            eventCategory: $link.data('ga-category'),
            eventAction: 'select_link',
            eventLabel: $link.data('ga-label')
        };

        return eventData;
    },

    getRadioChoiceData: function ($form) {
        var $selectedRadios = $form.find('input[type="radio"]:checked'),
            eventDataArray = [];

        $selectedRadios.each(function (n, radio) {
            var $radio = $(radio),
                eventData;

            eventData = {
                hitType: 'event',
                eventCategory: $radio.attr('name'),
                eventAction: 'choose',
                eventLabel: $radio.val()
            };

            eventDataArray.push(eventData);
        });

        return eventDataArray;
    },

    getDateYearData: function ($form) {
        var $dateYears = $form.find('input[type="text"][id$="date_1i"]'),
            eventDataArray = [];

        $dateYears.each(function (n, year) {
            var $year = $(year),
                eventData;

            eventData = {
                hitType: 'event',
                eventCategory: $year.attr('name').replace("(1i)", "_yyyy"),
                eventAction: 'enter_date',
                eventLabel: $year.val()
            };

            if ($year.val()) {
                eventDataArray.push(eventData);
            }
        });

        return eventDataArray;
    },

    getCheckboxFormData: function ($form) {
        var checkedCheckboxes = $form.find('input[type="checkbox"]:checked'),
            eventDataArray = [];

        checkedCheckboxes.each(function (n, checkbox) {
            var $checkbox = $(checkbox),
                eventData;

            eventData = {
                hitType: 'event',
                eventCategory: $checkbox.attr('name'),
                eventAction: 'checkbox',
                eventLabel: $checkbox.data('ga-label')
            };

            eventDataArray.push(eventData);
        });

        return eventDataArray;
    },

    sendAnalyticsEvent: function (eventData, opts) {
        var self = this,
            opts = opts || {};
        ga('create', 'UA-113317790-4');
        ga('send', 'event', eventData.eventCategory, eventData.eventAction, eventData.eventLabel, {
            hitCallback: self.createFunctionWithTimeout(function () {
                if (opts.actionType) {
                    if (opts.actionType === 'form') {
                        opts.actionValue.unbind('submit').trigger('submit');
                    } else if (opts.actionType === 'link') {
                        if (opts.actionValue.attr('target')) {
                            window.open(opts.actionValue.attr('href'), opts.actionValue.attr('target'));
                        } else {
                            document.location = opts.actionValue.attr('href');
                        }
                    }
                }
            })
        });
    },

    createFunctionWithTimeout: function (callback, opt_timeout) {
        // https://developers.google.com/analytics/devguides/collection/analyticsjs/sending-hits
        var called = false;

        function fn() {
            if (!called) {
                called = true;
                callback();
            }
        }

        setTimeout(fn, opt_timeout || 1000);
        return fn;
    }
};
