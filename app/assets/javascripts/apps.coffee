 # Place all the behaviors and hooks related to the matching controller here.
 # All this logic will automatically be available in application.js.
 
$ ->
  'use strict';
  Calculator = 
    init: ->
      this.exchange_rate = $('body').data 'exchange_rate'
    multiply: (num) ->
      console.log this.exchange_rate * num
      
  Calculator.init()
  Calculator.multiply(5)
