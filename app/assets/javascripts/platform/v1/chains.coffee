# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
$ ->
  'use strict';
  class Blockchain
    constructor: () ->
      @.bind_events()
    bind_events: () ->
      $('#new_blockchain').click (evt) ->
        console.log evt
      
  blockchain = new Blockchain
