module SpreeAvataxOfficial
  module Utilities
    class PingService < SpreeAvataxOfficial::Base
      def call(store)
        request_result(client(store).ping)
      end
    end
  end
end
