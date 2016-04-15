# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

$ ->
  'use strict';

  class Panel
    constructor: () ->
      @panel_data = 
        start:
          details: 'Start Bitcoin server.'
          verb: 'post'
          tier: 'pro'
        stop:
          details: 'Stop Bitcoin server.'
          verb: 'post'
          tier: 'pro'
        getinfo:
          details: 'Returns an object containing various state info.'
          verb: 'get'
          tier: 'free'
        destroy:
          details: 'Destroy Bitcoin Blockchain. **WARNING THIS IS DESTRUCTIVE AND CAN NOT BE UNDONE**'
          verb: 'delete'
          tier: 'free'
        getbestblockhash:
          details: 'Returns the hash of the best (tip) block in the longest block chain.
            Result `hex` (string) the block hash hex encoded'
          verb: 'get'
          tier: 'free'
        getblock:
          details: 'If verbose is false, returns a string that is serialized, hex-encoded data for block `hash`.
            If verbose is true, returns an Object with information about block <hash>.'
          verb: 'get'
          tier: 'free'
        getblockchaininfo:
          details: 'Returns an object containing various state info regarding block chain processing.'
          verb: 'get'
          tier: 'free'
        getblockcount:
          details: 'Returns the number of blocks in the longest block chain.'
          verb: 'get'
          tier: 'free'
        getblockhash:
          details: 'Returns hash of block in best-block-chain at index provided.'
          verb: 'get'
          tier: 'free'
        getblockheader:
          details: 'If verbose is false, returns a string that is serialized, hex-encoded data for blockheader `hash`.
            If verbose is true, returns an Object with information about blockheader <hash>.
            
            Arguments:
            1. `hash`          (string, required) The block hash
            2. verbose           (boolean, optional, default=true) true for a json object, false for the hex encoded data'
          verb: 'get'
          tier: 'free'
        getchaintips:
          details: 'Return information about all known tips in the block tree, including the main chain as well as orphaned branches.'
          verb: 'get'
          tier: 'free'
        getdifficulty:
          details: 'Returns the proof-of-work difficulty as a multiple of the minimum difficulty.'
          verb: 'get'
          tier: 'free'
        getmempoolinfo:
          details: 'Returns details on the active state of the TX memory pool.'
          verb: 'get'
          tier: 'free'
        getrawmempool:
          details: 'Returns all transaction ids in memory pool as a json array of string transaction ids.'
          verb: 'get'
          tier: 'free'
        gettxout:
          details: 'Returns details about an unspent transaction output.'
          verb: 'get'
          tier: 'free'
        gettxoutproof:
          details: 'Returns a hex-encoded proof that `txid` was included in a block.
            NOTE: By default this function only works sometimes. This is when there is an
            unspent output in the utxo for this transaction. To make it always work,
            you need to maintain a transaction index, using the -txindex command line option or
            specify the block in which the transaction is included in manually (by blockhash).
            Return the raw transaction data.'
          verb: 'get'
          tier: 'free'
        gettxoutsetinfo:
          details: 'Returns statistics about the unspent transaction output set.
            Note this call may take some time.'
          verb: 'get'
          tier: 'free'
        verifychain:
          details: 'Verifies blockchain database.'
          verb: 'get'
          tier: 'free'
        verifytxoutproof:
          details: 'Verifies that a proof points to a transaction in a block, returning the transaction it commits to and throwing an RPC error if the block is not in our best chain'
          verb: 'get'
          tier: 'free'
        generate:
          details: 'Mine blocks immediately (before the RPC call returns)
            Note: this function can only be used on the regtest network'
          verb: 'post'
          tier: 'free'
        getgenerate:
          details: 'Return if the server is set to generate coins or not. The default is false.
            It is set with the command line argument -gen (or bitcoin.conf setting gen)
            It can also be set with the setgenerate call.'
          verb: 'post'
          tier: 'free'
        setgenerate: 
          details: 'Set `generate` true or false to turn generation on or off.
            Generation is limited to `genproclimit` processors, -1 is unlimited.
            See the getgenerate call for the current setting.'
          verb: 'post'
          tier: 'free'
        getblocktemplate:
          details: 'If the request parameters include a `mode` key, that is used to explicitly select between the default `template` request or a `proposal`. 
            It returns data needed to construct a block to work on.
            See https://en.bitcoin.it/wiki/BIP_0022 for full specification.'
          verb: 'post'
          tier: 'free'
        getmininginfo:
          details: 'Returns a json object containing mining-related information.'
          verb: 'post'
          tier: 'free'
        getnetworkhashps:
          details: 'Returns the estimated network hashes per second based on the last n blocks.
            Pass in [blocks] to override # of blocks, -1 specifies since last difficulty change.
            Pass in [height] to estimate the network speed at the time when a certain block was found.'
          verb: 'post'
          tier: 'free'
        prioritisetransaction:
          details: 'Accepts the transaction into mined blocks at a higher (or lower) priority'
          verb: 'post'
          tier: 'free'
        submitblock:
          details: 'Attempts to submit new block to network.
            The `jsonparametersobject` parameter is currently ignored.
            See https://en.bitcoin.it/wiki/BIP_0022 for full specification.'
          verb: 'post'
          tier: 'free'
        addnode:
          details: 'Attempts add or remove a node from the addnode list.
            Or try a connection to a node once.'
          verb: 'post'
          tier: 'free'
        clearbanned:
          details: 'Clear all banned IPs.'
          verb: 'post'
          tier: 'free'
        disconnectnode:
          details: 'Immediately disconnects from the specified node.'
          verb: 'post'
          tier: 'free'
        getaddednodeinfo:
          details: 'Returns information about the given added node, or all added nodes
            (note that onetry addnodes are not listed here)
            If dns is false, only a list of added nodes will be provided,
            otherwise connected information will also be available.'
          verb: 'post'
          tier: 'free'
        getconnectioncount:
          details: 'Returns the number of connections to other nodes.'
          verb: 'post'
          tier: 'free'
        getnettotals:
          details: 'Returns information about network traffic, including bytes in, bytes out, and current time.'
          verb: 'post'
          tier: 'free'
        getnetworkinfo:
          details: 'Returns an object containing various state info regarding P2P networking.'
          verb: 'post'
          tier: 'free'
        getpeerinfo:
          details: 'Returns data about each connected network node as a json array of objects.'
          verb: 'post'
          tier: 'free'
        listbanned:
          details: 'List all banned IPs/Subnets.'
          verb: 'post'
          tier: 'free'
        ping:
          details: 'Requests that a ping be sent to all other nodes, to measure ping time.
            Results provided in getpeerinfo, pingtime and pingwait fields are decimal seconds.
            Ping command is handled in queue with all other commands, so it measures processing backlog, not just network ping.'
          verb: 'post'
          tier: 'free'
        setban:
          details: 'Attempts add or remove a IP/Subnet from the banned list.'
          verb: 'post'
          tier: 'free'
        createrawtransaction:
          details: 'Create a transaction spending the given inputs and creating new outputs.
            Outputs can be addresses or data.
            Returns hex-encoded raw transaction.
            Note that the transaction\'s inputs are not signed, and
            it is not stored in the wallet or transmitted to the network.'
          verb: 'post'
          tier: 'free'
        decoderawtransaction:
          details: 'Return a JSON object representing the serialized, hex-encoded transaction.'
          verb: 'post'
          tier: 'free'
        decodescript:
          details: 'Decode a hex-encoded script.'
          verb: 'post'
          tier: 'free'
        getrawtransaction:
          details: 'NOTE: By default this function only works sometimes. This is when the tx is in the mempool
            or there is an unspent output in the utxo for this transaction. To make it always work,
            you need to maintain a transaction index, using the -txindex command line option.
            
            Return the raw transaction data.
            
            If verbose=0, returns a string that is serialized, hex-encoded data for `txid`.
            If verbose is non-zero, returns an Object with information about `txid`.'
          verb: 'post'
          tier: 'free'
        sendrawtransaction:
          details: 'Submits raw transaction (serialized, hex-encoded) to local node and network.
            Also see createrawtransaction and signrawtransaction calls.'
          verb: 'post'
          tier: 'free'
        signrawtransaction:
          details: 'Sign inputs for raw transaction (serialized, hex-encoded).
            The second optional argument (may be null) is an array of previous transaction outputs that
            this transaction depends on but may not yet be in the block chain.
            The third optional argument (may be null) is an array of base58-encoded private
            keys that, if given, will be the only keys used to sign the transaction.'
          verb: 'post'
          tier: 'free'
        createmultisig:
          details: 'Creates a multi-signature address with n signature of m keys required.
            It returns a json object with the address and redeemScript.'
          verb: 'post'
          tier: 'free'
        estimatefee:
          details: 'Estimates the approximate fee per kilobyte needed for a transaction to begin
            confirmation within nblocks blocks.'
          verb: 'post'
          tier: 'free'
        estimatepriority:
          details: 'Estimates the approximate priority a zero-fee transaction needs to begin confirmation within nblocks blocks.'
          verb: 'post'
          tier: 'free'
        estimatesmartfee:
          details: 'WARNING: This interface is unstable and may disappear or change!
            Estimates the approximate fee per kilobyte needed for a transaction to begin
            confirmation within nblocks blocks if possible and return the number of blocks
            for which the estimate is valid.'
          verb: 'post'
          tier: 'free'
        estimatesmartpriority:
          details: 'WARNING: This interface is unstable and may disappear or change!
            Estimates the approximate priority a zero-fee transaction needs to begin
            confirmation within nblocks blocks if possible and return the number of blocks
            for which the estimate is valid.'
          verb: 'post'
          tier: 'free'
        validateaddress:
          details: 'Return information about the given bitcoin address.'
          verb: 'post'
          tier: 'free'
        verifymessage:
          details: 'Verify a signed message'
          verb: 'post'
          tier: 'free'
    update: (action_type) ->
      if @panel_data[action_type].tier is 'free'
        $('.alert').addClass 'hide'  
        $('#send').removeAttr 'disabled'
      else
        $('.alert').removeClass 'hide'  
        $('#send').attr 'disabled', ''
        
      $('#title_text').text action_type 
      $('#details').text @panel_data[action_type].details 
      $('#http_verb').removeClass('get post put delete').addClass(@panel_data[action_type].verb).text @panel_data[action_type].verb
      $('#action input').val action_type
  
  class Blockchain
    
    constructor: (@panel) ->
      @.bind_events()
      
    bind_events: () ->
      $('#flavors a').click (evt) =>
        $('#flavors a.active').removeClass 'active'
        $(evt.currentTarget).addClass 'active'
        evt.preventDefault()

      $('.parent_folder').click (evt) =>
        # Make the current target active
        $current_target = $ evt.currentTarget
        if $current_target.hasClass 'active'
          $current_target.removeClass 'active'
        else
          $current_target.addClass 'active'
          
        # Hide/show the related requests
        $requests = $ "##{$(evt.currentTarget).data('child_folder')}"
        if $requests.hasClass 'hide'
          $requests.removeClass('hide').addClass 'active'
        else
          $requests.addClass('hide').removeClass 'active'

      $('.requests li').click (evt) =>
        # Remove existing active item
        $('.requests li.active').removeClass 'active'
        
        # Make the current target active
        $current_target = $ evt.currentTarget
        if $current_target.hasClass 'active'
          $current_target.removeClass 'active'
        else
          $current_target.addClass 'active'
          
      $('#title').click (evt) =>
        $details = $ '#details'
        if $details.hasClass 'hide'
          $details.removeClass('hide')
          $('#caret_parent').removeClass('dropdown').addClass 'dropup'
        else
          $details.addClass('hide').removeClass 'active'
          $('#caret_parent').removeClass('dropup').addClass 'dropdown'
        evt.preventDefault()
        
      $('#controls ul a:not(#destroy_chain)').click (evt) =>
        $action = $(evt.currentTarget).find('code').text()
        @panel.update $action
        evt.preventDefault()
        
      $('#send').click (evt) =>
        $action = $('#title_text').text()
        href = $("[data-action='#{$action}']").parents('a').attr 'href'
        blockchain_property = $(evt.currentTarget).data 'blockchain_property'
        @.clear_output 'complete' 
        @.clear_output 'in_progress' 
        @.update_output $("<li>Working....</li>"), 'in_progress' 
        $.get href, { ipv4_address: $('#controls').data('ipv4_address') }, (rsp) =>
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
          @blockchain.update_output $("<li>URL: #{rsp.url}.</li>"), 'complete' 
          @.confirm_infrastructure_bootstrapped()
        else
          @blockchain.update_output $("<li>Working....</li>"), 'in_progress' 
          setTimeout(() =>
            @.confirm_node_created()
          , 15000)
    
    confirm_infrastructure_bootstrapped: () ->
      console.log 'confirm_infrastructure_bootstrapped called'
      
  panel = new Panel
  blockchain = new Blockchain panel
  unless _.isEmpty $ '#blockchain_title'
    poller = new Poller blockchain
    poller.confirm_node_created()
