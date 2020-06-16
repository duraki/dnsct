module Dnsct
  class Manager

    def initialize
      @list = []
    end

    def export
      # implement export method
    end

    def merge(subdomains)
      @list = (@list + subdomains).uniq
    end

  end
end