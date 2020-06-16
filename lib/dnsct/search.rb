require "crtsh"
require "uri"

module Dnsct
  class Search

    def initialize
      @api = Crtsh::API.new
      @subdomains = []
    end

    def domain_search(dns)
      search = @api.search(dns, match: "LIKE")

      search.each do |subdomain|
        if subdomain["name_value"].include?("\n")
        else
          @subdomains << extract(subdomain["name_value"])
        end
      end

      pp @subdomains
      @subdomains.uniq! # Unique per domain is OK, but not per list
    end

    def extract(name)
      # extract subdomain from full DNS
      name.split('.').first
    end

  end
end