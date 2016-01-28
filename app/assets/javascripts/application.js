// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap.min
// require turbolinks
//= require lodash.min
//= require_tree .

(function(){
  'use strict';
  window.onload = function() {
    var BigEarth = {
      init: function(){
        $('.btc, .usd').click(function(evt){
          if($(evt.currentTarget).hasClass('btc')) {
            $('.btc').addClass('hide')
            $('.usd').removeClass('hide')
          } else if($(evt.currentTarget).hasClass('usd')) {
            $('.usd').addClass('hide')
            $('.btc').removeClass('hide')
          }
        });
      }
    };
    BigEarth.init();

    var Bookmark = {
      init: function(){
        var bookmarks = JSON.parse(localStorage.getItem('bookmarks'));
        var bookmark = _.find(bookmarks, function(bookmark) { 
          return bookmark.url_path === window.location.pathname; 
        });

        if(bookmark) {
          $('.bookmark').text('Bookmarked').attr('href', '/bookmarks');
        }

        $('.bookmark').click(function(evt) {
          if($(evt.currentTarget).text() != 'Bookmarked') {
            Bookmark.set_bookmark(evt);
            evt.preventDefault();
          }
        });

        $('.clear_all_bookmarks').click(function(evt) {
          Bookmark.clear_all_bookmarks();
          evt.preventDefault();
        });
      },
      set_bookmark: function(evt) {
        var bookmarks = localStorage.getItem('bookmarks');
        if(bookmarks === null) {
          bookmarks = [];
        } else {
          bookmarks = JSON.parse(bookmarks);
        }
        var options = {
          url_path: window.location.pathname,
          created_at: Date.now(),
          id: $(evt.currentTarget).data('page_id'), 
          page_type: $(evt.currentTarget).data('page_type')
        };
        var bookmark = _.find(bookmarks, function(bookmark) { 
          return bookmark.url_path === window.location.pathname; 
        });
        if(_.isUndefined(bookmark)) {
          bookmarks.push(options)
          $('.bookmark').text('Bookmarked').attr('href', '/bookmarks');
        }
        localStorage.setItem('bookmarks', JSON.stringify(bookmarks));
      },
      clear_all_bookmarks: function(){
        localStorage.removeItem('bookmarks');
      }
    };
    Bookmark.init();
  };
}());
