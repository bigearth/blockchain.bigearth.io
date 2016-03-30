module BigEarth 
  module Blockchain 
    module Exceptions
      class CreateNodeException < StandardError
      end
      
      class DestroyNodeException < StandardError
      end
      
      class ConfirmNodeCreatedException < StandardError
      end
    end
  end
end
