 # Place all the behaviors and hooks related to the matching controller here.
 # All this logic will automatically be available in application.js.
 
$ ->
  'use strict';
  class Calculator 
    constructor: (@exchange_rate) ->
      $('#btc_calculator_input, #usd_calculator_input').on 'change keyup', (evt) =>
        type = if evt.currentTarget.id is 'btc_calculator_input' then 'btc' else 'usd'
        @.calculate_exchange evt.currentTarget.value, type
    calculate_exchange: (num, type) ->
      final_rate = if type is 'btc' then @.exchange_rate * num else num / @.exchange_rate
      if type is 'btc'
        $('#usd_value').text(final_rate.toLocaleString())
      else if type is 'usd'
        $('#btc_value').text(final_rate.toFixed(8))
      
  calculator = new Calculator $('body').data 'exchange_rate'
