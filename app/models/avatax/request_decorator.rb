module Avatax
  module RequestDecorator
    include ::SpreeAvataxOfficial::HttpHelper

    def request(method, path, model, options = {}, apiversion = "")
      max_retries ||= ::SpreeAvataxOfficial::Config.max_retries
      uri_encoded_path = URI.parse(path).to_s

      response = connection.send(method) do |req|
        req.headers['X-Avalara-Client'] = req.headers['X-Avalara-Client'].to_s.gsub("API_VERSION", apiversion) if apiversion.present?
        req.options['timeout'] ||= 1_200
        case method
        when :get, :delete
          req.url("#{uri_encoded_path}?#{URI.encode_www_form(options)}")
        when :post, :put
          req.url("#{uri_encoded_path}?#{URI.encode_www_form(options)}")
          req.headers['Content-Type'] = 'application/json'
          req.body                    = model.to_json unless model.empty?
        end
      end

      if faraday_response
        response
      else
        response.body
      end
    rescue *::SpreeAvataxOfficial::HttpHelper::CONNECTION_ERRORS => e
      retry unless (max_retries -= 1).zero?

      mock_error_response(e) # SpreeAvataxOfficial::HttpHelper method
    end
  end
end

# This is correct class to prepend because of: https://github.com/avadev/AvaTax-REST-V2-Ruby-SDK/blob/eb7c20b8e925a3d682f6414207e298e519e0a549/lib/avatax/api.rb#L25
::AvaTax::API.prepend ::Avatax::RequestDecorator
