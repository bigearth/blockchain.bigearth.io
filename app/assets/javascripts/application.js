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

    var BookmarkBtn = {
      init: function(){
        var bookmarks = JSON.parse(localStorage.getItem('bookmarks'));
        var bookmark = _.find(bookmarks, function(bookmark) { 
          return bookmark.path === window.location.pathname; 
        });

        if(bookmark) {
          $('.bookmark').text('Bookmarked').attr('href', '/apps/bookmarks');
        }

        $('.bookmark').click(function(evt) {
          if($(evt.currentTarget).text() != 'Bookmarked') {
            BookmarkBtn.set_bookmark(evt);
            evt.preventDefault();
          }
        });

        $('.clear_all_bookmarks').click(function(evt) {
          BookmarkBtn.clear_all_bookmarks();
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
          path: window.location.pathname,
          created_at: Date.now(),
          id: $(evt.currentTarget).data('page_id'), 
          bookmark_type: $(evt.currentTarget).data('bookmark_type')
        };
        var bookmark = _.find(bookmarks, function(bookmark) { 
          return bookmark.path === window.location.pathname; 
        });
        if(_.isUndefined(bookmark)) {
          bookmarks.push(options)
          $('.bookmark').text('Bookmarked').attr('href', '/apps/bookmarks');
        }
        localStorage.setItem('bookmarks', JSON.stringify(bookmarks));
      },
      clear_all_bookmarks: function(){
        localStorage.removeItem('bookmarks');
        $('#block_bookmarks ul, #transaction_bookmarks ul, #address_bookmarks ul').hide()
        $('#block_bookmarks li, #transaction_bookmarks li, #address_bookmarks li').remove()
        $('#block_bookmarks p, #transaction_bookmarks p, #address_bookmarks p').show()
      }
    };
    var Bookmarks = {
      init: function() {
        var bookmarks = JSON.parse(localStorage.getItem('bookmarks'));
        var block_bookmarks = _.filter(bookmarks, function(bookmark) {
          return bookmark.bookmark_type === 'block';
        });
        var transaction_bookmarks = _.filter(bookmarks, function(bookmark) {
          return bookmark.bookmark_type === 'transaction';
        });
        var address_bookmarks = _.filter(bookmarks, function(bookmark) {
          return bookmark.bookmark_type === 'address';
        });
        
        if(!_.isEmpty(block_bookmarks)) {
          this.build_bookmarks(block_bookmarks);
        }
        
        if(!_.isEmpty(transaction_bookmarks)) {
          this.build_bookmarks(transaction_bookmarks);
        }
        
        if(!_.isEmpty(address_bookmarks)) {
          this.build_bookmarks(address_bookmarks);
        }
        $('.delete_bookmark').click(function(evt) {
          var bkmks = JSON.parse(localStorage.getItem('bookmarks'));
          var new_bkmks = _.reject(bkmks, function(bk) {
            return bk.path == $($(evt.currentTarget)).parents('.list-group-item').find('.bookmark_path').attr('href');
          });
          var parent_ul = $(evt.currentTarget).closest('.list-group');
          $(evt.currentTarget).parents('.list-group-item').remove();
          if(!$(parent_ul).children('li').length) {
            $(parent_ul).closest('.panel-body').find('ul').hide().end().find('p').show();
          }
          localStorage.setItem('bookmarks', JSON.stringify(new_bkmks));
          evt.preventDefault();
        });
      },
      build_bookmarks: function(bookmarks) {
        if(!_.isEmpty(bookmarks)) {
          $('#' + bookmarks[0].bookmark_type + '_bookmarks p').hide()
          $('#' + bookmarks[0].bookmark_type + '_bookmarks ul').removeClass('hide');
          _.each(bookmarks, function(bookmark, index) {
            $('#' + bookmark.bookmark_type + '_bookmarks ul').append($('<li class="list-group-item"><a class="bookmark_path" href="' + bookmark.path + '">' + _.truncate(bookmark.id, {length: 45}) + '<a href="#" class="delete_bookmark"><span class="label label-danger pull-right">Delete</span></a></li>'))
          });
        }
      }
    }
    BigEarth.init();
    BookmarkBtn.init();
    if($('#block_bookmarks').length) {
      Bookmarks.init();
    }
  };
}());
