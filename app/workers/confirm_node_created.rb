class ConfirmNodeCreated
  # This Resque worker checks Digital Ocean to confirm that a node has been created. This basically means has the Ubunutu instance been created yet?
  # If it has then have the Chef Workstation Bootstrap it 
  # If it hasn't then queue this same Worker up and try again in a few minutes
  @queue = :confirm_node_created_resque_queue

  def self.perform(name)
    puts "Confirming that node #{name} has been created"
    if false
      puts "CONFIRMED: node #{name} has been created"
      # Node has been created. Now have the Chef Workstation Boostrap it
      # POST /boostrap on Chef Workstation
      # Need auth credentials
      # POST over data:
      #  * ip address
      #  * name
      #  * auth credentials
    else
      # Node hasn't yet been created on Digital Ocean. Give it a few minutes and try again.
      puts "NOPE: node #{name} hasn't been created"
      sleep 1
      Resque.enqueue(ConfirmNodeCreated, name)
    end
  end
end
