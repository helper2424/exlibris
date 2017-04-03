module Exlibris
  module Alma
    class Search

      attr_reader :api_key, :base_url, :version

      def initialize(key:, base_url: Exlibris::Alma::BASE_URL_AMERICA, version: 1.2, code: '')
        @api_key = key
        @base_url = base_url
        @version = version
        @code = code
      end

      def search(query, offset = 1, limit = 20)
        request build_url, search_hash query, offset, limit
      rescue RuntimeError => e
        ::Exlibris::Base.logger.error(
          "EXLIBRIS-ALMA: exception #{e.message}"
        )
        nil
      end

      private

      def search_hash(query, offset, limit)
        base_m = "#{self.class.name}#search_hash"

        raise "#{base_m} offset should be greater then 0" if offset <= 0
        raise "#{base_m} limit should be between 0 and 50" if limit < 0 || limit > 50

        {
          version: @version,
          operation: 'searchRetrieve',
          query: query,
          startRecord: offset,
          maximumRecords: limit,
          recordSchema: 'marcxml'
        }
      end

      def build_url
        "#{base_url}/view/sru/#{code}"
      end

      def request(url, query_hash)
        begin
          response = RestClient::Request.execute method: :get,
                                                 url: url,
                                                 headers: { params: query_hash },
                                                 accept: :json
        rescue => e
          ::Exlibris::Base.logger.error(
            "EXLIBRIS-ALMA: failed: #{self.class.name}#request "\
              "for #{url} fails, response #{e.response}"
          )
        end
        response.body
      end
    end
  end
end