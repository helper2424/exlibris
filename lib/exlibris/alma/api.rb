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

      # See https://developers.exlibrisgroup.com/alma/apis/bibs/GET/gwPcGly021q2Z+qBbnVJzw==/af2fb69d-64f4-42bc-bb05-d8a0ae56936e
      def check_availability(mms_id)
        data = { expand: 'p_avail,e_avail,d_avail' }
        response = request method: :get, url_body: "bibs/#{mms_id}",
                           data: data
        return nil if response.nil?
        Oj.load response.body
      end

      # See https://developers.exlibrisgroup.com/alma/apis/bibs/GET/gwPcGly021om4RTvtjbPleCklCGxeYAfEqJOcQOaLEvEGUPgvJFpUQ==/af2fb69d-64f4-42bc-bb05-d8a0ae56936e
      def holdings(mms_id)
        response = request method: :get, url_body: "bibs/#{mms_id}/holdings"
        return nil if response.nil?
        Oj.load response.body
      end

      # See https://developers.exlibrisgroup.com/alma/apis/bibs/GET/gwPcGly021om4RTvtjbPleCklCGxeYAfY09xr4k8GXw=/af2fb69d-64f4-42bc-bb05-d8a0ae56936e
      def loans(mms_id)
        response = request method: :get, url_body: "bibs/#{mms_id}/loans"
        return nil if response.nil?
        Oj.load response.body
      end

      # See https://developers.exlibrisgroup.com/alma/apis/bibs/GET/gwPcGly021om4RTvtjbPleCklCGxeYAfEqJOcQOaLEvNcHQT0/ozqu3DGTurs/XxIP4LrexQUdc=/af2fb69d-64f4-42bc-bb05-d8a0ae56936e
      def holding_items(mms_id, holding_id)
        response = request method: :get, url_body: "bibs/#{mms_id}/holdings/#{holding_id}/items"
        return nil if response.nil?
        Oj.load response.body
      end

      private

      def build_url(url_body)
        "#{base_url}/almaws/v#{version}/#{url_body}"
      end

      def request(method:, url_body:, data: {}, payload: nil)
        data[:apikey] = api_key
        data[:format] = :json

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
