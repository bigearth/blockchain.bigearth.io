module BigEarth 
  module Blockchain 
    module Exceptions
      class CreateNodeException < StandardError
      end
      
      class DestroyNodeException < StandardError
      end
      
      class ConfirmNodeCreatedException < StandardError
      end
      
      class CreateDNSRecordException < StandardError
      end
      
      class DestroyDNSRecordException < StandardError
      end
    end
  end
end
