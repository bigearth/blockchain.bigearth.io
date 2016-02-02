 # Place all the behaviors and hooks related to the matching controller here.
 # All this logic will automatically be available in application.js.
 
$ ->
  'use strict';
  class Calculator 
    constructor: (@exchange_rate) ->
      # accept @exchange_rate argument and set it as an instance var
      
      # event handler for 2 selectors and 2 events
      $('#btc_calculator_input, #usd_calculator_input').on 'change keyup', (evt) =>
        
        # determine which type of input has fired
        type = if evt.currentTarget.id is 'btc_calculator_input' then 'btc' else 'usd'
        
        # calculate exchange rate
        @.calculate_exchange evt.currentTarget.value, type
        
      # event handler for radio btns
      $("input[name=bitcoin_calculator]:radio").change (evt) =>
        
        # determine which radio btn is selected
        type = evt.currentTarget.value
        
        # update the DOM accordingly
        if type is 'btc'
          $('#usd_calculator_input').closest('.form-group').addClass 'hide' unless $('#usd_calculator_input').closest('.form-group').hasClass 'hide' ;
          $('#usd_value').closest('div').removeClass 'hide' if $('#usd_value').closest('div').hasClass 'hide';
          
          $('#btc_calculator_input').closest('.form-group').removeClass 'hide' if $('#btc_calculator_input').closest('.form-group').hasClass 'hide' ;
          $('#btc_value').closest('div').addClass 'hide' unless $('#btc_value').closest('div').hasClass 'hide';
        else if type is 'usd'
          $('#usd_calculator_input').closest('.form-group').removeClass 'hide' if $('#usd_calculator_input').closest('.form-group').hasClass 'hide' ;
          $('#usd_value').closest('div').addClass 'hide' unless $('#usd_value').closest('div').hasClass 'hide';
          
          $('#btc_calculator_input').closest('.form-group').addClass 'hide' unless $('#btc_calculator_input').closest('.form-group').hasClass 'hide' ;
          $('#btc_value').closest('div').removeClass 'hide' if $('#btc_value').closest('div').hasClass 'hide';
    calculate_exchange: (num, type) ->
      # calculate exchange value depending on which input field has fired
      final_rate = if type is 'btc' then @.exchange_rate * num else num / @.exchange_rate
      
      # update the DOM accordingly
      if type is 'btc'
        $('#btc_value').text(num)
        $('#usd_value').text(final_rate.toFixed(2).toLocaleString())
        $('#usd_calculator_input').val(final_rate.toFixed(2).toLocaleString())
      else if type is 'usd'
        $('#usd_value').text(num)
        $('#btc_value').text(final_rate.toFixed(8))
        $('#btc_calculator_input').val(final_rate.toFixed(8))
      
  calculator = new Calculator $('body').data 'exchange_rate'
