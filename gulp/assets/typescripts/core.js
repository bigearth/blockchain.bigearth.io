System.register(["jquery", "lodash"], function(exports_1, context_1) {
    "use strict";
    var __moduleName = context_1 && context_1.id;
    var $, _;
    return {
        setters:[
            function ($_1) {
                $ = $_1;
            },
            function (_1) {
                _ = _1;
            }],
        execute: function() {
            window.onload = function () {
                'use strict';
                var Utility = (function () {
                    function Utility() {
                    }
                    Utility.prototype.number_with_commas = function (x) {
                        // format number w/ commas
                        return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                    };
                    return Utility;
                }());
                var Bookmarks = (function () {
                    function Bookmarks() {
                        // bind click events
                        this.bind_events();
                        // fetch marshalled bookmarks from localStorage
                        var bookmarks = localStorage.getItem('bookmarks');
                        // parse marshalled bookmarks into JSON
                        var parsed_bookmarks = JSON.parse(bookmarks);
                        // check existing bookmarks to see if bookmark already exists
                        var bookmark = this.find_bookmark(parsed_bookmarks);
                        // if this page has already been bookmarked update the bookmark btn 
                        if (bookmark) {
                            this.update_bookmark_btn();
                        }
                        // update the bookmark count badge
                        if (parsed_bookmarks) {
                            this.set_bookmark_count_badge(parsed_bookmarks.length);
                        }
                        // build out the bookmarks DOM
                        if ($('#block_bookmarks').length) {
                            this.build_bookmarks_dom();
                        }
                    }
                    Bookmarks.prototype.bind_events = function () {
                        var _this = this;
                        $('#create_bookmark').click(function (evt) {
                            // when clicked check state of btn 
                            if ($($(evt.currentTarget).find('span:nth-child(2)')).text() !== 'Bookmarked') {
                                // if the page hasn't been bookmarked before create bookmark
                                _this.create_bookmark(evt);
                                evt.preventDefault();
                            }
                        });
                        $('.clear_all_bookmarks').click(function (evt) {
                            _this.clear_all_bookmarks();
                            evt.preventDefault();
                        });
                        // bind click events to toggle btc/usd values 
                        $('.btc, .usd').click(function (evt) {
                            if ($(evt.currentTarget).hasClass('btc')) {
                                $('.btc').addClass('hide');
                                $('.usd').removeClass('hide');
                            }
                            else if ($(evt.currentTarget).hasClass('usd')) {
                                $('.usd').addClass('hide');
                                $('.btc').removeClass('hide');
                            }
                        });
                    };
                    Bookmarks.prototype.build_bookmarks_dom = function () {
                        var _this = this;
                        // grab marshalled bookmarks from localStorage
                        var bookmarks = localStorage.getItem('bookmarks');
                        // parse marshalled bookmarks into JSON
                        var parsed_bookmarks = JSON.parse(bookmarks);
                        ['block', 'transaction', 'address'].forEach(function (item, index) {
                            // for all 3 bookmark types filter out respective bookmarks
                            var bkmrks = _.filter(parsed_bookmarks, function (bkmrk) {
                                return bkmrk.bookmark_type === item;
                            });
                            // build DOM of any bookmarks which exist for respective bookmark_type 
                            if (!_.isEmpty(bkmrks)) {
                                _this.build_bookmarks(bkmrks);
                            }
                        });
                    };
                    Bookmarks.prototype.build_bookmarks = function (bookmarks) {
                        var _this = this;
                        // get bookmark_type of each respective bookmark group
                        var bookmark_type = bookmarks[0].bookmark_type;
                        // for each bookmark type hide "No Bookmarks" <p> and show the <ul> in prep for plugging in <li>s w/ the bookmarks
                        $("#" + bookmark_type + "_bookmarks").find('p').hide().end().find('ul').removeClass('hide');
                        _.each(bookmarks, function (bookmark, index) {
                            // build out the DOM like this:
                            // <li class="list-group-item">
                            //  <a class="bookmark_path" href="/addresses/1Ebb8NfVmKMoGuMJCAEbVMv2dX8GnzgxSa">1Ebb8NfVmKMoGuMJCAEbVMv2dX8GnzgxSa</a>
                            //  <a href="#" class="delete_bookmark">
                            //    <span class="label label-danger pull-right" data-id="1Ebb8NfVmKMoGuMJCAEbVMv2dX8GnzgxSa">Delete</span>
                            //  </a>
                            // </li>
                            // grab ul for respective bookmark type
                            var $bookmarks_ul = $('#' + bookmark_type + '_bookmarks ul');
                            // create each of the DOM elements
                            var $list_group_item_li = $('<li class="list-group-item"></li>');
                            var $bookmark_path_anchor = $("<a data-id='" + bookmark.id + "' class='bookmark_path address_balance' href='" + bookmark.path + "'>" + _.truncate(bookmark.id, { length: 45 }) + "</a>");
                            var $delete_bookmark_anchor = $('<a href="#" class="delete_bookmark"></a>');
                            var $label_danger_span = $("<span class='label label-danger pull-right' data-id='" + bookmark.id + "'>Delete</span>");
                            // build out the DOM as described above for each bookmark type
                            $bookmarks_ul.append($list_group_item_li.append($bookmark_path_anchor).append($delete_bookmark_anchor.append($label_danger_span)));
                            // If there are address bookmarks 
                            if (bookmark_type === 'address') {
                                // get the panel footer of the address bookmarks
                                var $sum_footer = $('#sum_btc').closest('.panel-footer');
                                if ($sum_footer.is(':hidden')) {
                                    // if the address bookmarks panel footer is hidden then show it
                                    $sum_footer.removeClass('hide');
                                }
                                // fetch the address balances to sum up and display 
                                _this.fetch_address_balances(bookmark.id);
                            }
                        });
                        // now that delete buttons are in the DOM bind click event to delete bookmark
                        $('.delete_bookmark').click(function (evt) {
                            _this.delete_bookmark(evt);
                        });
                    };
                    Bookmarks.prototype.fetch_address_balances = function (address) {
                        var _this = this;
                        $.getJSON("/addresses/" + address + ".json", function (data) {
                            // fetch the balance for this address and calculate sum
                            _this.calculate_address_sum(data.data, 'add');
                        });
                    };
                    Bookmarks.prototype.calculate_address_sum = function (address_data, operation_type) {
                        // grab some DOM elements
                        var $sum = $('#sum_btc');
                        var $sum_usd = $('#sum_usd');
                        var $sum_footer = $sum.closest('.panel-footer');
                        var $sum_li = $sum.closest('.panel').find('.panel-body li');
                        var sum_text = $sum.text();
                        var trimmed_sum_text = _.trimEnd(sum_text, ' BTC');
                        // grab the existing sum of all bookmarked Addresses
                        var existing_sum = parseFloat(trimmed_sum_text.replace(/,/g, ''));
                        // parse address balance into float to prevent strange maths
                        var address_balance = parseFloat(address_data.balance);
                        // set the bookmark's data-balance attribute on the DOM to use later when subtracting balance during bookmark deletion
                        $($("[data-id='" + address_data.address + "']")[0]).attr('data-balance', address_balance.toFixed(8));
                        // add or subtract address balance from existing sum to create new sum
                        var new_sum;
                        if (operation_type === 'add') {
                            new_sum = existing_sum + address_balance;
                        }
                        else if (operation_type === 'subtract') {
                            new_sum = existing_sum - address_balance;
                        }
                        // get the exchange rate from coinbase
                        var usd_exchange_rate = $('body').data('exchange_rate');
                        // convert BTC value to USD
                        var new_usd = _.round(new_sum * usd_exchange_rate, 2);
                        // split the value to format the whole Integers w/ commas
                        var split_btc = new_sum.toFixed(8).toString().split('.');
                        // create Utility instance
                        var utility = new Utility;
                        // format number w/ comma
                        split_btc[0] = utility.number_with_commas(+split_btc[0]);
                        // join after formatting
                        var formatted_btc = split_btc.join('.');
                        // set the BTC sum and USD title
                        $sum.text(formatted_btc + " BTC").attr('title', "$" + new_usd.toLocaleString());
                        // set the USD sum and BTC title
                        $sum_usd.text("$" + new_usd.toLocaleString()).attr('title', formatted_btc + " BTC");
                        // if there are no more address bookmarks and the address panel-footer is visible then hide it
                        if (!$sum_li.length && $sum_footer.is(':visible')) {
                            this.hide_sum();
                        }
                    };
                    Bookmarks.prototype.find_bookmark = function (bookmarks) {
                        // return single bookmark that matches current URL
                        var bkmk = _.find(bookmarks, function (bookmark) {
                            return bookmark.path === window.location.pathname;
                        });
                        return bkmk;
                    };
                    Bookmarks.prototype.create_bookmark = function (evt) {
                        // get marshalled bookmarks from localStorage
                        var bookmarks = localStorage.getItem('bookmarks');
                        if (bookmarks) {
                            // if there are previous bookmarks parse them into JSON
                            bookmarks = JSON.parse(bookmarks);
                        }
                        else {
                            // if there are no previous bookmarks prime an empty array
                            bookmarks = [];
                        }
                        // check to see if bookmark already exists
                        var bookmark = this.find_bookmark(bookmarks);
                        if (_.isUndefined(bookmark)) {
                            // if there is no existing bookmark for this page then create one
                            var bookmark_options = {
                                path: window.location.pathname,
                                created_at: Date.now(),
                                id: $(evt.currentTarget).data('page_id'),
                                bookmark_type: $(evt.currentTarget).data('bookmark_type')
                            };
                            bookmarks.push(bookmark_options);
                            // now that the page has been bookmarked update the bookmark btn
                            this.update_bookmark_btn();
                            // marshall the bookmarks
                            var marshalled_bookmarks = JSON.stringify(bookmarks);
                            // update the bookmark count badge
                            this.set_bookmark_count_badge(bookmarks.length);
                            // save the marshalled bookmarks to localStorage
                            localStorage.setItem('bookmarks', marshalled_bookmarks);
                        }
                    };
                    Bookmarks.prototype.set_bookmark_count_badge = function (bookmark_count) {
                        if (bookmark_count > 0) {
                            $('#bookmark_count_badge').removeClass('hide').text(bookmark_count);
                        }
                        else {
                            $('#bookmark_count_badge').addClass('hide').text(0);
                        }
                    };
                    Bookmarks.prototype.update_bookmark_btn = function () {
                        $('#create_bookmark').attr('href', '/apps/bookmarks');
                        $('#create_bookmark_description').text('Bookmarked');
                    };
                    Bookmarks.prototype.delete_bookmark = function (evt) {
                        // get marshalled_bookmarks from localStorage
                        var marshalled_bookmarks = localStorage.getItem('bookmarks');
                        // parse marshalled bookmarks into JSON
                        var parsed_bookmarks = JSON.parse(marshalled_bookmarks);
                        // get the existing balance from the DOM
                        var balance = $(evt.currentTarget).closest('.list-group-item').find('.address_balance').data('balance');
                        // get the address from the DOM
                        var address = $(evt.currentTarget).find('span').data('id');
                        var new_bkmks = _.reject(parsed_bookmarks, function (bk) {
                            return bk.path === $(evt.currentTarget).parents('.list-group-item').find('.bookmark_path').attr('href');
                        });
                        var parent_ul = $(evt.currentTarget).closest('.list-group');
                        $(evt.currentTarget).parents('.list-group-item').remove();
                        if (!$(parent_ul).children('li').length) {
                            $(parent_ul).closest('.panel-body').find('ul').hide().end().find('p').show();
                        }
                        if (!_.isUndefined(balance)) {
                            this.calculate_address_sum({
                                balance: balance,
                                address: address
                            }, 'subtract');
                        }
                        // update the bookmark count badge 
                        this.set_bookmark_count_badge(new_bkmks.length);
                        // marshall updated bookmark data
                        marshalled_bookmarks = JSON.stringify(new_bkmks);
                        // write marshalled bookmark data to localStorage
                        localStorage.setItem('bookmarks', marshalled_bookmarks);
                        // prevent click/tap on href='#''
                        evt.preventDefault();
                    };
                    Bookmarks.prototype.clear_all_bookmarks = function () {
                        // remove all bookmarks from localStorage
                        localStorage.removeItem('bookmarks');
                        // update the DOM 
                        $('#block_bookmarks ul, #transaction_bookmarks ul, #address_bookmarks ul').hide();
                        $('#block_bookmarks li, #transaction_bookmarks li, #address_bookmarks li').remove();
                        $('#block_bookmarks p, #transaction_bookmarks p, #address_bookmarks p').show();
                        // hide the address sum
                        this.hide_sum();
                        // hide the bookmark count badge
                        this.set_bookmark_count_badge(0);
                    };
                    Bookmarks.prototype.hide_sum = function () {
                        // hide the address bookmark's panel-footer  
                        $('#address_bookmarks .panel-footer').hide();
                    };
                    return Bookmarks;
                }());
                var utility = new Utility;
                var bookmarks = new Bookmarks;
            };
        }
    }
});
