module Exlibris
  module Alma
    # The API class is aimed at providing methods for interacting with the Exlibris Alma API
    class Api
      attr_reader :api_key, :base_url, :version

      def initialize(api_key, url = BASE_URL_AMERICA)
        @api_key = api_key
        @base_url = url
        @version = 1
      end

      def check_availability(mms_id)
        data = { expand: 'p_avail,e_avail,d_avail' }
        response = request method: :get, url_body: "bibs/#{mms_id}",
                           data: data
        return nil if response.nil?
        xml = Nokogiri::XML response.body
        xml.remove_namespaces!
        Hash[xml.xpath('//bib/*').map { |row| [row.name, row.text] }]
      end

      private

      def build_url(url_body)
        "#{base_url}/almaws/v#{version}/#{url_body}"
      end

      def request(method:, url_body:, data: {}, payload: nil)
        data[:apikey] = api_key

        begin
          response = RestClient::Request.execute method: method, url: build_url(url_body),
                                                 content_type: :json,
                                                 accept: :json,
                                                 payload: payload,
                                                 headers: { params: data }
        rescue RestClient::Exception, SocketError => e
          message = e.message
          message = e.response if e.respond_to? :response
          ::Exlibris::Base.logger.error "ERESERVE ERROR: response #{message}"
        end
        response
      end
    end
  end
end
