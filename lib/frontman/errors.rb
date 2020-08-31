module Frontman
  
  class Error < StandardError; end

  class DuplicateResourceError < StandardError
    def self.create(resource, url, existing_resource)
      new("Unable to add #{resource.file_path} as #{url}.
           Resource #{existing_resource.file_path} already exists on this URL.")
    end
  end

  class ExistingRedirectError < StandardError
    def self.create(resource, url)
      new("Unable to add #{resource.file_path} as #{url}.
           A redirect already exists for this URL.")
    end
  end

  class ExistingResourceError < StandardError
    def self.create(url, resource)
      new("Unable to redirect for #{url},
           the resource #{resource.file_path} already exists on this URL")
    end
  end

  class ServerPortError < StandardError
    def initialize
      super("Server failed to attach to port. Please shutdown some processes or increase the :port_retries configuration variable.")
    end
  end

end
