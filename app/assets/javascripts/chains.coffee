# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

$ ->
  'use strict';
  
  class Blockchain
    
    constructor: () ->
      @.bind_events()
      
    bind_events: () ->
      $('#flavors a').click (evt) =>
        $('#flavors a.active').removeClass 'active'
        $(evt.currentTarget).addClass 'active'
        evt.preventDefault()

      # $('.child_folder div').click (evt) =>
      #   console.log 'one'
      #   current_target = $(evt.currentTarget)
      #   if $(current_target).hasClass 'child_folder_active'
      #     $(current_target).removeClass 'child_folder_active'
      #   else
      #     $(current_target).addClass 'child_folder_active'
        
      $('.parent_folder').click (evt) =>
        current_target = $(evt.currentTarget)
        if $(current_target).hasClass 'active'
          $(current_target).removeClass 'active'
        else
          $(current_target).addClass 'active'
          
        requests = $("##{$(evt.currentTarget).data('child_folder')}")
        if $(requests).hasClass 'hide'
          $(requests).removeClass('hide').addClass 'active'
        else
          $(requests).addClass('hide').removeClass 'active'
        
      $('#controls ul a:not(#destroy_chain)').click (evt) =>
        blockchain_property = $(evt.currentTarget).data 'blockchain_property'
        @.clear_output 'complete' 
        @.clear_output 'in_progress' 
        @.update_output $("<li>Working....</li>"), 'in_progress' 
        $.get $(evt.currentTarget).attr('href'), { ipv4_address: $('#controls').data('ipv4_address') }, (rsp) =>
          @.clear_output 'complete' 
          @.clear_output 'in_progress' 
          _.each rsp, (value, key) =>
            @.update_output $("<li>#{key}: #{value}</li>"), 'complete' 
        evt.preventDefault()
        
    update_output: (output, output_type = 'in_progress') ->
      if output_type is 'in_progress'
        $('#output #in_progress').append output
      else if output_type is 'complete'
        $('#output #complete').append output
    clear_output: (type) ->
        $("#output ##{type}").html ''
    update_button: (output) ->
      # do things
    reset_buttons: ->
      $('#new_blockchain, #delete_blockchain').removeClass('btn-danger btn-success').addClass('btn-primary')
  
  class Poller
    constructor: (@blockchain) ->
      
    confirm_node_created: () ->
      $.get "confirm_node_created?title=#{$('#blockchain_title').data('title')}", (rsp) =>
        if rsp.message is 'node created'
          @blockchain.clear_output 'in_progress' 
          @blockchain.update_output $("<li>Node has been created.</li>"), 'complete' 
          @blockchain.update_output $("<li>IPv4 Address: #{rsp.ipv4_address}.</li>"), 'complete' 
          @blockchain.update_output $("<li>IPv6 Address: #{rsp.ipv6_address}.</li>"), 'complete' 
          @.confirm_infrastructure_bootstrapped()
        else
          @blockchain.update_output $("<li>Working....</li>"), 'in_progress' 
          setTimeout(() =>
            @.confirm_node_created()
          , 15000)
    
    confirm_infrastructure_bootstrapped: () ->
      console.log 'confirm_infrastructure_bootstrapped called'
      
  blockchain = new Blockchain
  unless _.isEmpty $ '#blockchain_title'
    poller = new Poller blockchain
    poller.confirm_node_created()
