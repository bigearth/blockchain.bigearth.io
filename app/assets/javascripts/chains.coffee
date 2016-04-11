# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

$ ->
  'use strict';

  class Panel
    constructor: () ->
      @panel_data = 
        start:
          details: 'Start Bitcoin server.'
        stop:
          details: 'Stop Bitcoin server.'
        getinfo:
          details: 'Returns an object containing various state info.'
        destroy:
          details: 'Destroy Bitcoin Blockchain. **WARNING THIS IS DESTRUCTIVE AND CAN NOT BE UNDONE**'
        getbestblockhash:
          details: 'Returns the hash of the best (tip) block in the longest block chain.
            Result "hex" (string) the block hash hex encoded'
        getblock:
          details: 'If verbose is false, returns a string that is serialized, hex-encoded data for block "hash".
            If verbose is true, returns an Object with information about block <hash>.'
        getblockchaininfo:
          details: 'Returns an object containing various state info regarding block chain processing.'
        getblockcount:
          details: 'Returns the number of blocks in the longest block chain.'
        getblockhash:
          details: 'Returns hash of block in best-block-chain at index provided.'
        getblockheader:
          details: 'If verbose is false, returns a string that is serialized, hex-encoded data for blockheader "hash".
            If verbose is true, returns an Object with information about blockheader <hash>.
            
            Arguments:
            1. "hash"          (string, required) The block hash
            2. verbose           (boolean, optional, default=true) true for a json object, false for the hex encoded data'
        getchaintips:
          details: 'Return information about all known tips in the block tree, including the main chain as well as orphaned branches.'
        getdifficulty:
          details: 'Returns the proof-of-work difficulty as a multiple of the minimum difficulty.'
        getmempoolinfo:
          details: 'Returns details on the active state of the TX memory pool.'
        getrawmempool:
          details: 'Returns all transaction ids in memory pool as a json array of string transaction ids.'
        gettxout:
          details: 'Returns details about an unspent transaction output.'
        gettxoutproof:
          details: 'Returns a hex-encoded proof that "txid" was included in a block.
            NOTE: By default this function only works sometimes. This is when there is an
            unspent output in the utxo for this transaction. To make it always work,
            you need to maintain a transaction index, using the -txindex command line option or
            specify the block in which the transaction is included in manually (by blockhash).
            Return the raw transaction data.'
        gettxoutsetinfo:
          details: 'Returns statistics about the unspent transaction output set.
            Note this call may take some time.'
        verifychain:
          details: 'Verifies blockchain database.'
        verifytxoutproof:
          details: 'Verifies that a proof points to a transaction in a block, returning the transaction it commits to and throwing an RPC error if the block is not in our best chain'
        generate:
          details: 'Mine blocks immediately (before the RPC call returns)
            Note: this function can only be used on the regtest network'
        getgenerate:
          details: 'Return if the server is set to generate coins or not. The default is false.
            It is set with the command line argument -gen (or bitcoin.conf setting gen)
            It can also be set with the setgenerate call.'
        setgenerate: 
          details: 'Set "generate" true or false to turn generation on or off.
            Generation is limited to "genproclimit" processors, -1 is unlimited.
            See the getgenerate call for the current setting.'
        getblocktemplate:
          details: 'If the request parameters include a `mode` key, that is used to explicitly select between the default `template` request or a "proposal". 
            It returns data needed to construct a block to work on.
            See https://en.bitcoin.it/wiki/BIP_0022 for full specification.'
        getmininginfo:
          details: 'Returns a json object containing mining-related information.'
        getnetworkhashps:
          details: 'Returns the estimated network hashes per second based on the last n blocks.
            Pass in [blocks] to override # of blocks, -1 specifies since last difficulty change.
            Pass in [height] to estimate the network speed at the time when a certain block was found.'
        prioritisetransaction:
          details: 'Accepts the transaction into mined blocks at a higher (or lower) priority'
        submitblock:
          details: 'Attempts to submit new block to network.
            The `jsonparametersobject` parameter is currently ignored.
            See https://en.bitcoin.it/wiki/BIP_0022 for full specification.'
        addnode:
          details: 'Attempts add or remove a node from the addnode list.
            Or try a connection to a node once.'
        clearbanned:
          details: 'Clear all banned IPs.'
        disconnectnode:
          details: 'Immediately disconnects from the specified node.'
        getaddednodeinfo:
          details: 'Returns information about the given added node, or all added nodes
            (note that onetry addnodes are not listed here)
            If dns is false, only a list of added nodes will be provided,
            otherwise connected information will also be available.'
        getconnectioncount:
          details: 'Returns the number of connections to other nodes.'
        getnettotals:
          details: 'Returns information about network traffic, including bytes in, bytes out, and current time.'
        getnetworkinfo:
          details: 'Returns an object containing various state info regarding P2P networking.'
        getpeerinfo:
          details: 'Returns data about each connected network node as a json array of objects.'
        listbanned:
          details: 'List all banned IPs/Subnets.'
        ping:
          details: 'Requests that a ping be sent to all other nodes, to measure ping time.
            Results provided in getpeerinfo, pingtime and pingwait fields are decimal seconds.
            Ping command is handled in queue with all other commands, so it measures processing backlog, not just network ping.'
        setban:
          details: 'Attempts add or remove a IP/Subnet from the banned list.'
        createrawtransaction:
          details: 'Create a transaction spending the given inputs and creating new outputs.
            Outputs can be addresses or data.
            Returns hex-encoded raw transaction.
            Note that the transaction\'s inputs are not signed, and
            it is not stored in the wallet or transmitted to the network.'
        decoderawtransaction:
          details: 'Return a JSON object representing the serialized, hex-encoded transaction.'
        decodescript:
          details: 'Decode a hex-encoded script.'
        getrawtransaction:
          details: 'NOTE: By default this function only works sometimes. This is when the tx is in the mempool
            or there is an unspent output in the utxo for this transaction. To make it always work,
            you need to maintain a transaction index, using the -txindex command line option.
            
            Return the raw transaction data.
            
            If verbose=0, returns a string that is serialized, hex-encoded data for `txid`.
            If verbose is non-zero, returns an Object with information about `txid`.'
        sendrawtransaction:
          details: 'Submits raw transaction (serialized, hex-encoded) to local node and network.
            Also see createrawtransaction and signrawtransaction calls.'
        signrawtransaction:
          details: 'Sign inputs for raw transaction (serialized, hex-encoded).
            The second optional argument (may be null) is an array of previous transaction outputs that
            this transaction depends on but may not yet be in the block chain.
            The third optional argument (may be null) is an array of base58-encoded private
            keys that, if given, will be the only keys used to sign the transaction.'
        createmultisig:
          details: 'Creates a multi-signature address with n signature of m keys required.
            It returns a json object with the address and redeemScript.'
        estimatefee:
          details: 'Estimates the approximate fee per kilobyte needed for a transaction to begin
            confirmation within nblocks blocks.'
        estimatepriority:
          details: 'Estimates the approximate priority a zero-fee transaction needs to begin confirmation within nblocks blocks.'
        estimatesmartfee:
          details: 'WARNING: This interface is unstable and may disappear or change!
            Estimates the approximate fee per kilobyte needed for a transaction to begin
            confirmation within nblocks blocks if possible and return the number of blocks
            for which the estimate is valid.'
        estimatesmartpriority:
          details: 'WARNING: This interface is unstable and may disappear or change!
            Estimates the approximate priority a zero-fee transaction needs to begin
            confirmation within nblocks blocks if possible and return the number of blocks
            for which the estimate is valid.'
        validateaddress:
          details: 'Return information about the given bitcoin address.'
        verifymessage:
          details: 'Verify a signed message'
    update: (action_type) ->
      $('#panel #title_text').text action_type 
      $('#panel #details').text @panel_data[action_type].details 
  
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
        action = $(evt.currentTarget).find('code').text()
        @panel.update action
      #   blockchain_property = $(evt.currentTarget).data 'blockchain_property'
      #   @.clear_output 'complete' 
      #   @.clear_output 'in_progress' 
      #   @.update_output $("<li>Working....</li>"), 'in_progress' 
      #   $.get $(evt.currentTarget).attr('href'), { ipv4_address: $('#controls').data('ipv4_address') }, (rsp) =>
      #     @.clear_output 'complete' 
      #     @.clear_output 'in_progress' 
      #     _.each rsp, (value, key) =>
      #       @.update_output $("<li>#{key}: #{value}</li>"), 'complete' 
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
      
  panel = new Panel
  blockchain = new Blockchain panel
  unless _.isEmpty $ '#blockchain_title'
    poller = new Poller blockchain
    poller.confirm_node_created()
