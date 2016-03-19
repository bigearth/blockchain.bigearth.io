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
        blockchain_flavor = $('#blockchain_flavors .active').data 'blockchain_flavor'
        
        # POST name and flavor to new_chain endpoint
        $.post 'new_chain', {
          name: name
          blockchain_flavor: blockchain_flavor
        }, (rsp) =>
          @.reset_buttons()
          if rsp.status is 'already_exists'
            @.update_output("Bitcoin Blockchain #{name} already exists.")
            $(evt.currentTarget).removeClass('btn-primarys').addClass('btn-danger')
          else if _.isObject rsp
            @.update_output("Creating Bitcoin #{_.upperFirst blockchain_flavor.split('_')[1]} Blockchain #{name}.")
            $(evt.currentTarget).removeClass('btn-primary').addClass('btn-success')
          
      $('#delete_blockchain').click (evt) =>
        @.update_output "Processing..."
        name = $('#blockchain_title').data 'name'
        options = {
          name: name
        }
        $.ajax {
          url: "destroy_chain?#{$.param(options)}",
          type: 'DELETE',
          success: (rsp) =>
            # TODO handle case where droplet is still being created
            @.reset_buttons()
            if rsp.status_message is 'deleted'
              @.update_output("Deleting Bitcoin Blockchain #{name}.")
              $(evt.currentTarget).removeClass('btn-primary').addClass('btn-success')
            else if rsp.status_message is 'nothing_to_delete'
              @.update_output(" Bitcoin Blockchain #{name} doesn't exist. Click the 'New' button to create it.")
              $(evt.currentTarget).removeClass('btn-primary').addClass('btn-danger')
        }
        
      $('#blockchain_flavors a').click (evt) =>
        $('#blockchain_flavors a.active').removeClass 'active'
        $(evt.currentTarget).addClass 'active'
        evt.preventDefault()
        
    update_output: (output, output_type = 'in_progress') ->
      if output_type is 'in_progress'
        $('#output #in_progress').text output
      else if output_type is 'complete'
        $('#output #complete').append output
    update_button: (output) ->
      # do things
    reset_buttons: ->
      $('#new_blockchain, #delete_blockchain').removeClass('btn-danger btn-success').addClass('btn-primary')
  
  class Poller
    constructor: () ->
      @.blockchain = new Blockchain
      
    confirm_droplet_created: () ->
      $.get "confirm_droplet_created?id=#{$('#blockchain_title').data('id')}", (rsp) =>
        if rsp.message is 'droplet created'
          @.blockchain.update_output $("<li>Droplet has been created.</li>"), 'complete' 
          @.blockchain.update_output $("<li>IPv4 Address: #{rsp.ip_address}}.</li>"), 'complete' 
          @.confirm_client_bootstrapped()
        else
          setTimeout(() =>
            @.confirm_droplet_created()
          , 15000)
    
    confirm_client_bootstrapped: () ->
      console.log 'confirm_client_bootstrapped called'
      
  new Blockchain
  unless _.isEmpty $ '#blockchain_title'
    poller = new Poller 
    poller.confirm_droplet_created()
