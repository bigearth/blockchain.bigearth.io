# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

$ ->
  'use strict';
  
  class Blockchain
    
    constructor: () ->
      @.bind_events()
      
    bind_events: () ->
      $('#new_blockchain').click (evt) =>
        @.update_output "Processing..."
        name = $('#data_name').data 'name'
        $.post 'new_chain', {
          name: name
        }, (rsp) =>
          @.reset_buttons()
          if rsp.status is 'already_exists'
            @.update_output("Bitcoin Blockchain #{name} already exists. Next time click the 'Ping' button first.")
            $(evt.currentTarget).removeClass('btn-primarys').addClass('btn-danger')
          else if _.isObject rsp
            @.update_output("Creating Bitcoin Blockchain #{name}. Give it like 20 seconds.")
            $(evt.currentTarget).removeClass('btn-primary').addClass('btn-success')
          
      $('#ping_blockchain').click (evt) =>
        @.update_output "Processing..."
        name = $('#data_name').data 'name'
        $.get 'get_chain', {
          name: name
        }, (rsp) =>
          @.reset_buttons()
          if rsp.status is 500
            @.update_output("Error trying to create Bitcoin Blockchain #{name}. Try again in a bit.")
            $('#ping_blockchain span').removeClass('glyphicon-question-sign glyphicon-ok').addClass 'glyphicon-remove'
            $(evt.currentTarget).removeClass('btn-primarys').addClass('btn-danger')
          else if rsp.status is 'does_not_exist'
            @.update_output("Nope, Bitcoin Blockchain #{name} doesn't exist. Click the 'New' button to create it.")
            $('#ping_blockchain span').removeClass('glyphicon-question-sign glyphicon-ok').addClass 'glyphicon-remove'
            $(evt.currentTarget).removeClass('btn-primarys').addClass('btn-danger')
          else if rsp.length
            @.update_output("Yup, Bitcoin Blockchain #{name} exists at IPv4 Address: #{rsp[0].networks.v4[0].ip_address}.")
            $('#ping_blockchain span').removeClass('glyphicon-question-sign glyphicon-remove').addClass 'glyphicon-ok'
            $(evt.currentTarget).removeClass('btn-primary').addClass('btn-success')
          
      $('#delete_blockchain').click (evt) =>
        @.update_output "Processing..."
        name = $('#data_name').data 'name'
        options = {
          name: name
        }
        $.ajax {
          url: "destroy_chain?#{$.param(options)}",
          type: 'DELETE',
          success: (rsp) =>
            # TODO handle case where droplet is still being created
            @.reset_buttons()
            if rsp.status is 'deleted'
              @.update_output("Deleting Bitcoin Blockchain #{name}.")
              $(evt.currentTarget).removeClass('btn-primary').addClass('btn-success')
            else if rsp.status is 'nothing_to_delete'
              @.update_output(" Bitcoin Blockchain #{name} doesn't exist. Click the 'New' button to create it.")
              $(evt.currentTarget).removeClass('btn-primary').addClass('btn-danger')
        }
        
      $('#flavors a').click (evt) =>
        $('#flavors a.active').removeClass 'active'
        $(evt.currentTarget).addClass 'active'
        evt.preventDefault()
        
    update_output: (output) ->
      $('#output').text output
    update_button: (output) ->
      # do things
    reset_buttons: ->
      $('#new_blockchain, #ping_blockchain, #delete_blockchain').removeClass('btn-danger btn-success').addClass('btn-primary')
      $('#ping_blockchain span').removeClass('glyphicon-remove glyphicon-ok').addClass('glyphicon-question-sign')
      
  new Blockchain
