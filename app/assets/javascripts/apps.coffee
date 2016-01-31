 # Place all the behaviors and hooks related to the matching controller here.
 # All this logic will automatically be available in application.js.
 
$ ->
  'use strict';
  class Calculator 
    constructor: (@exchange_rate) ->
      $('#btc_calculator_input').on 'change keyup', (evt) =>
        @.calculate_btc_exchange evt.currentTarget.value
      $('#usd_calculator_input').on 'change keyup', (evt) =>
        @.calculate_usd_exchange evt.currentTarget.value
    calculate_btc_exchange: (num) ->
      final_rate = @.exchange_rate * num
      $('#usd_value').text(final_rate.toLocaleString())
    calculate_usd_exchange: (num) ->
      final_rate = num / @.exchange_rate 
      $('#btc_value').text(final_rate.toFixed(8))
      
  calculator = new Calculator $('body').data 'exchange_rate'
