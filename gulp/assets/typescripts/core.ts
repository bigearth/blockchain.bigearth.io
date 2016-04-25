import * as $ from "jquery";
import * as _ from "lodash"

window.onload = () => {
 'use strict';
 
 class Utility {
   number_with_commas (x: number): string {
     // format number w/ commas
     return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
   }
 }
 
 class Bookmarks {
   constructor () {
     // bind click events
     this.bind_events();
     
     // fetch marshalled bookmarks from localStorage
     let bookmarks: string = localStorage.getItem('bookmarks');
     
     // parse marshalled bookmarks into JSON
     let parsed_bookmarks: any = JSON.parse(bookmarks);
     
     // check existing bookmarks to see if bookmark already exists
     let bookmark: any = this.find_bookmark(parsed_bookmarks);
     
     // if this page has already been bookmarked update the bookmark btn 
      if(bookmark) {
        this.update_bookmark_btn();
      }
     
     // update the bookmark count badge
     if(parsed_bookmarks) {
       this.set_bookmark_count_badge(parsed_bookmarks.length);
     }
     
     // build out the bookmarks DOM
     if($('#block_bookmarks').length) {
       this.build_bookmarks_dom();
     }
   }
   
   bind_events (): void {
     $('#create_bookmark').click((evt) => {
       // when clicked check state of btn 
       if($($(evt.currentTarget).find('span:nth-child(2)')).text() !== 'Bookmarked') {
         // if the page hasn't been bookmarked before create bookmark
         this.create_bookmark(evt);
         evt.preventDefault();
       }
     });
       
     $('.clear_all_bookmarks').click((evt) => {
       this.clear_all_bookmarks();
       evt.preventDefault();
     });
     
     // bind click events to toggle btc/usd values 
     $('.btc, .usd').click((evt) => {
       if($(evt.currentTarget).hasClass('btc')) {
         $('.btc').addClass('hide'); 
         $('.usd').removeClass('hide');
       } else if($(evt.currentTarget).hasClass('usd')) {
         $('.usd').addClass('hide'); 
         $('.btc').removeClass('hide'); 
       }
     });
   }
     
   build_bookmarks_dom (): void {
     // grab marshalled bookmarks from localStorage
     let bookmarks: string = localStorage.getItem('bookmarks');
     
     // parse marshalled bookmarks into JSON
     let parsed_bookmarks: any = JSON.parse(bookmarks);
     
     ['block', 'transaction', 'address'].forEach((item, index) => {
       // for all 3 bookmark types filter out respective bookmarks
       let bkmrks: any = _.filter(parsed_bookmarks, (bkmrk: any) => {
         return bkmrk.bookmark_type === item;
       });
     
       // build DOM of any bookmarks which exist for respective bookmark_type 
       if(!_.isEmpty(bkmrks)) {
         this.build_bookmarks(bkmrks);
       }
     });
   }
   
   build_bookmarks (bookmarks: any): void {
     // get bookmark_type of each respective bookmark group
     let bookmark_type: string = bookmarks[0].bookmark_type;
     
     // for each bookmark type hide "No Bookmarks" <p> and show the <ul> in prep for plugging in <li>s w/ the bookmarks
     $(`#${bookmark_type}_bookmarks`).find('p').hide().end().find('ul').removeClass('hide');
     
     _.each(bookmarks, (bookmark, index) => {
       // build out the DOM like this:
       // <li class="list-group-item">
       //  <a class="bookmark_path" href="/addresses/1Ebb8NfVmKMoGuMJCAEbVMv2dX8GnzgxSa">1Ebb8NfVmKMoGuMJCAEbVMv2dX8GnzgxSa</a>
       //  <a href="#" class="delete_bookmark">
       //    <span class="label label-danger pull-right" data-id="1Ebb8NfVmKMoGuMJCAEbVMv2dX8GnzgxSa">Delete</span>
       //  </a>
       // </li>
       
       // grab ul for respective bookmark type
       let $bookmarks_ul: any = $('#' + bookmark_type + '_bookmarks ul');
       
       // create each of the DOM elements
       let $list_group_item_li: any = $('<li class="list-group-item"></li>');
       let $bookmark_path_anchor: any = $(`<a data-id='${bookmark.id}' class='bookmark_path address_balance' href='${bookmark.path}'>${_.truncate(bookmark.id, {length: 45})}</a>`);
       let $delete_bookmark_anchor: any = $('<a href="#" class="delete_bookmark"></a>');
       let $label_danger_span: any = $(`<span class='label label-danger pull-right' data-id='${bookmark.id}'>Delete</span>`);
       
       // build out the DOM as described above for each bookmark type
       $bookmarks_ul.append($list_group_item_li.append($bookmark_path_anchor).append($delete_bookmark_anchor.append($label_danger_span)));
       
       // If there are address bookmarks 
       if(bookmark_type === 'address') {
         
         // get the panel footer of the address bookmarks
         let $sum_footer: any = $('#sum_btc').closest('.panel-footer');
         
         if($sum_footer.is(':hidden')) {
           // if the address bookmarks panel footer is hidden then show it
           $sum_footer.removeClass('hide');
         }
         
         // fetch the address balances to sum up and display 
         this.fetch_address_balances(bookmark.id);
       }
     });
     // now that delete buttons are in the DOM bind click event to delete bookmark
     $('.delete_bookmark').click((evt) => {
       this.delete_bookmark(evt);
     });
   }
     
   fetch_address_balances (address: string): void {
     $.getJSON(`/addresses/${address}.json`, (data) => {
       // fetch the balance for this address and calculate sum
       this.calculate_address_sum(data.data, 'add');
     });
   }
   
   calculate_address_sum (address_data: any, operation_type: any) {
     // grab some DOM elements
     let $sum: any = $('#sum_btc'); 
     let $sum_usd: any = $('#sum_usd');
     let $sum_footer: any = $sum.closest('.panel-footer');
     let $sum_li: any = $sum.closest('.panel').find('.panel-body li');
     let sum_text: string = $sum.text();
     let trimmed_sum_text: string = _.trimEnd(sum_text, ' BTC');
     
     // grab the existing sum of all bookmarked Addresses
     let existing_sum: number = parseFloat(trimmed_sum_text.replace(/,/g,''));
         
     // parse address balance into float to prevent strange maths
     let address_balance: number = parseFloat(address_data.balance);
     
     // set the bookmark's data-balance attribute on the DOM to use later when subtracting balance during bookmark deletion
     $($(`[data-id='${address_data.address}']`)[0]).attr('data-balance', address_balance.toFixed(8));
     
     // add or subtract address balance from existing sum to create new sum
     let new_sum: number;
     if(operation_type === 'add') {
       new_sum = existing_sum + address_balance;
     } else if(operation_type === 'subtract') {
       new_sum = existing_sum - address_balance;
     }
     
     // get the exchange rate from coinbase
     let usd_exchange_rate: any = $('body').data('exchange_rate');
     
     // convert BTC value to USD
     let new_usd: number = _.round(new_sum * usd_exchange_rate, 2);
     
     // split the value to format the whole Integers w/ commas
     let split_btc: string[] = new_sum.toFixed(8).toString().split('.');
     
     // create Utility instance
     let utility: Utility = new Utility;
     
     // format number w/ comma
     split_btc[0] = utility.number_with_commas(+split_btc[0]);
     
     // join after formatting
     let formatted_btc: string = split_btc.join('.');
     
     // set the BTC sum and USD title
     $sum.text(`${formatted_btc} BTC`).attr('title', `$${new_usd.toLocaleString()}`);
     
     // set the USD sum and BTC title
     $sum_usd.text(`$${new_usd.toLocaleString()}`).attr('title', `${formatted_btc} BTC`);
     
     // if there are no more address bookmarks and the address panel-footer is visible then hide it
     if(!$sum_li.length && $sum_footer.is(':visible')) {
       this.hide_sum();
     }
   }
   
   find_bookmark (bookmarks: any): any {
     // return single bookmark that matches current URL
     let bkmk: any = _.find(bookmarks, (bookmark: any) => {
       return bookmark.path === window.location.pathname;
     });
     
     return bkmk;
   }
   
   create_bookmark (evt: any): void {
     // get marshalled bookmarks from localStorage
     let bookmarks: any = localStorage.getItem('bookmarks');
     
     if(bookmarks) {
       // if there are previous bookmarks parse them into JSON
       bookmarks = JSON.parse(bookmarks);
     } else {
       // if there are no previous bookmarks prime an empty array
       bookmarks = [];
     }
     
     // check to see if bookmark already exists
     let bookmark: any = this.find_bookmark(bookmarks);
     
     if(_.isUndefined(bookmark)) {
       // if there is no existing bookmark for this page then create one
       let bookmark_options: any =  {
         path: window.location.pathname,
         created_at: Date.now(),
         id: $(evt.currentTarget).data('page_id'),
         bookmark_type: $(evt.currentTarget).data('bookmark_type')
       };
         
       bookmarks.push(bookmark_options);
       
       // now that the page has been bookmarked update the bookmark btn
       this.update_bookmark_btn();
       
       // marshall the bookmarks
       let marshalled_bookmarks: string = JSON.stringify(bookmarks);
       
       // update the bookmark count badge
       this.set_bookmark_count_badge(bookmarks.length);
       
       // save the marshalled bookmarks to localStorage
       localStorage.setItem('bookmarks', marshalled_bookmarks);
     }
   }
   
   set_bookmark_count_badge (bookmark_count: number): void {
     if(bookmark_count > 0) {
       $('#bookmark_count_badge').removeClass('hide').text(bookmark_count);
     } else {
       $('#bookmark_count_badge').addClass('hide').text(0);
     }
   }
   
   update_bookmark_btn (): void {
     $('#create_bookmark').attr('href', '/apps/bookmarks');
     $('#create_bookmark_description').text('Bookmarked');
   }
   
   delete_bookmark (evt: any): void {
     // get marshalled_bookmarks from localStorage
     let marshalled_bookmarks: string = localStorage.getItem('bookmarks');
     
     // parse marshalled bookmarks into JSON
     let parsed_bookmarks: any = JSON.parse(marshalled_bookmarks);
     
     // get the existing balance from the DOM
     let balance: any = $(evt.currentTarget).closest('.list-group-item').find('.address_balance').data('balance');
     
     // get the address from the DOM
     let address = $(evt.currentTarget).find('span').data('id');
     
     let new_bkmks: any = _.reject(parsed_bookmarks, (bk: any) => {
       return bk.path === $(evt.currentTarget).parents('.list-group-item').find('.bookmark_path').attr('href');
     });
       
     let parent_ul: any = $(evt.currentTarget).closest('.list-group');
     
     $(evt.currentTarget).parents('.list-group-item').remove();
     
     if(!$(parent_ul).children('li').length) {
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
   }
   
   clear_all_bookmarks (): void {
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
   }
   
   hide_sum (): void {
     // hide the address bookmark's panel-footer  
     $('#address_bookmarks .panel-footer').hide();
   }
 }
 
  let utility: Utility = new Utility;
  let bookmarks: Bookmarks = new Bookmarks;
};
