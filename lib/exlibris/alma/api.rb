module Exlibris
  module Alma
    class Api

      attr_reader :api_key, :base_url, :version

        private_class_method

        def request(method:, url_body:, data: {}, payload: nil)
          data.merge!({ api_key: api_key })
          begin
            response = RestClient::Request.execute method: method, url: build_url(url_body),
                                          content_type: :json,
                                          accept: :json,
                                          payload: payload,
                                          headers: { params: data }
          # rescue => e
          #   ::Exlibris::Base.logger.error "ERESERVE ERROR: response #{e.response if e.respond_to? :response}"
          end
          response
        end

      def initialize(api_key, url = BASE_URL_AMERICA)
        @api_key = api_key
        @base_url = url
        @version = 1
      end

      def check_availability(mms_id)
        data = {
          mms_id: mms_id,
          expand: 'p_avail,e_avail,d_avail'
        }
        response = request method: :get, url_body: 'bibs',
                           data: data
        return nil if response.nil?
        Oj.load(response)
      end

      private

      def build_url(url_body)
        "#{base_url}/almaws/v#{version}/#{url_body}"
      end
    end
  end
end