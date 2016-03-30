# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

$ ->
  'use strict';
  
  class Blockchain
    
    constructor: () ->
      @.bind_events()
      
    bind_events: () ->
      $('#new_blockchain').click (evt) =>
        # Create a new blockchain
        @.update_output "Processing..."
        
        # Grab name and flavor from the DOM
        name = $('#blockchain_title').data 'name'
        flavor = $('#flavors .active').data 'flavor'
        
        # POST name and flavor to new_chain endpoint
        $.post 'new_chain', {
          name: name
          flavor: flavor
        }, (rsp) =>
          @.reset_buttons()
          if rsp.status is 'already_exists'
            @.update_output("Bitcoin Blockchain #{name} already exists.")
            $(evt.currentTarget).removeClass('btn-primarys').addClass('btn-danger')
          else if _.isObject rsp
            @.update_output("Creating Bitcoin #{_.upperFirst flavor.split('_')[1]} Blockchain #{name}.")
            $(evt.currentTarget).removeClass('btn-primary').addClass('btn-success')
          
      $('#flavors a').click (evt) =>
        $('#flavors a.active').removeClass 'active'
        $(evt.currentTarget).addClass 'active'
        evt.preventDefault()
        
    update_output: (output, output_type = 'in_progress') ->
      if output_type is 'in_progress'
        $('#output #in_progress').append output
      else if output_type is 'complete'
        $('#output #complete').append output
    update_button: (output) ->
      # do things
    reset_buttons: ->
      $('#new_blockchain, #delete_blockchain').removeClass('btn-danger btn-success').addClass('btn-primary')
  
  class Poller
    constructor: (@blockchain) ->
      
    confirm_node_created: () ->
      $.get "confirm_node_created?title=#{$('#blockchain_title').data('title')}", (rsp) =>
        if rsp.message is 'node created'
          @blockchain.update_output $("<li>Node has been created.</li>"), 'complete' 
          @blockchain.update_output $("<li>IPv4 Address: #{rsp.ipv4_address}.</li>"), 'complete' 
          @blockchain.update_output $("<li>IPv6 Address: #{rsp.ipv6_address}.</li>"), 'complete' 
          @.confirm_client_bootstrapped()
        else
          @blockchain.update_output $("<li>Working....</li>"), 'in_progress' 
          setTimeout(() =>
            @.confirm_node_created()
          , 15000)
    
    confirm_client_bootstrapped: () ->
      console.log 'confirm_client_bootstrapped called'
      
  blockchain = new Blockchain
  unless _.isEmpty $ '#blockchain_title'
    poller = new Poller blockchain
    poller.confirm_node_created()
