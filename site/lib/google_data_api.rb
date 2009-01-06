require 'net/http'
require 'net/https'
require 'rubygems'
require 'xmlsimple'
require 'rexml/document'
require 'hpricot'
require 'open-uri'

module GoogleDataApi
  
  class SecureData
    CONTENT_TYPE_FORM = 'application/x-www-form-urlencoded'
    CONTENT_TYPE_ATOMXML = 'application/atom+xml'
    
    attr_accessor :auth, :email, :password, :headers
    
    def authenticate_to_service(service, email=email, password=password, content_type=CONTENT_TYPE_FORM)
      http = Net::HTTP.new('www.google.com', 443)
      http.use_ssl = true
      path = '/accounts/ClientLogin'
      data = "accountType=HOSTED_OR_GOOGLE&Email=#{email}&Passwd=#{password}&service=#{service}"
      @headers = { 'Content-Type' => content_type }
      resp, data = http.post(path, data, headers)
      cl_string = data[/Auth=(.*)/, 1]
      @headers["Authorization"] = "GoogleLogin auth=#{cl_string}"
      cl_string
    end

    # Set 'Content-Type' header to 'application/atom+xml'
    def set_header_content_type_to_xml()
      @headers["Content-Type"] = CONTENT_TYPE_ATOMXML
    end

    # Perform a GET request to a given uri
    #
    # Args:
    #   uri: string
    #
    # Returns:
    #   Net::HTTPResponse
    #
    def get_feed(uri)
      uri = URI.parse(uri)
      Net::HTTP.start(uri.host, uri.port) do |http|
        return http.get(uri.path, @headers)
      end
    end

    # Parse xml into a datastructure using xmlsimple
    #
    # Args:
    #   xml: string
    #
    # Returns:
    #   A hash containing the xml data provided in the argument
    #
    def create_datastructure_from_xml(xml)
      return XmlSimple.xml_in(xml, 'KeyAttr' => 'name')
    end

    # Post data to a specific uri
    #
    # Args:
    #   uri: string
    #   data: string (typically xml)
    #
    # Returns:
    #   Net::HTTPResponse
    #
    def post(uri, data)
      uri = URI.parse(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      return http.post(uri.path, data, @headers)
    end
  end
  
  class Spreadsheets < SecureData
    SPREADSHEET_FEED = 'http://spreadsheets.google.com/feeds/spreadsheets/private/full'
    SERVICE_NAME = 'wise'
    
    def initialize(options={})
      if options[:email]
        self.email = options[:email]
      end
      if options[:password]
        self.password = options[:password]
      end
      if options[:authenticate]
         authenticate(SERVICE_NAME)
      end
      # @headers['GData-Version'] = '2'
    end
    
    def authenticate
      authenticate_to_service(SERVICE_NAME)
    end

    # Get spreadsheet feed for currently authenticated user
    def get_my_spreadsheets()
      spreadsheet_feed_response = get_feed(SPREADSHEET_FEED)
      create_datastructure_from_xml(spreadsheet_feed_response.body)
    end
    
    def get_spreadsheet(ss_name)
      ssid = get_my_spreadsheets()["entry"].find{|e| e["title"][0]["content"] == ss_name}["id"][0]
    end
    
    def get_worksheet(ss_name, ws_name)
      ssid = get_my_spreadsheets()["entry"].find{|e| e["title"][0]["content"] == ss_name}["id"][0]
    end
    
    # my["entry"].find{|e| e["title"][0]["content"] == "Retorts"}["id"][0]
    #  http://spreadsheets.google.com/feeds/spreadsheets/private/full/p80Mflwp2CCpX7xtrETljXw

    # Get the worksheets feed for a given spreadsheet
    #
    # Args:
    #   spreadsheet_key: string
    #
    # Returns:
    #   Net::HTTPResponse: The worksheet feed
    #
    def get_worksheet_by_key(spreadsheet_key)
      worksheet_feed_uri =  "http://spreadsheets.google.com/feeds/worksheets/#{spreadsheet_key}/private/full"
      return get_feed(worksheet_feed_uri)
    end
  end
  
  class Documents < SecureData
  end
  
  # Contains all the methods listed in the 
  # 'Using Ruby with the Google Data API's article'.
  #
  # Performs authentication via ClientLogin, feed retrieval, post and batch 
  # update requests.
  #
  class SpreadsheetsExample


    # Obtain the version string for a specific cell
    #
    # Args:
    #   uri: string
    #
    # Returns:
    #   A string containing the version string
    #
    def get_version_string(uri)
      response = get_feed(uri)
      xml = REXML::Document.new response.body
      # use XPath to strip the href attribute of the first link whose
      # 'rel' attribute is set to edit
      edit_link = REXML::XPath.first(xml, '//[@rel="edit"]')
      edit_link_href = edit_link.attribute('href').to_s
      # return the version string at the end of the link's href attribute
      return edit_link_href.split(/\//)[10]
    end

    # Perform a batch update using the cellsfeed of a specific spreadsheet
    #
    # Args:
    #   batch_data: array of hashes of data to post
    #               sample hash: +batch_id+: string (i.e. "A")
    #                            +cell_id+: string (i.e. "R1C1")
    #                            +data+: string (i.e. "My data")
    #
    # Returns:
    #   Net::HTTPResponse
    #
    def batch_update(batch_data, cellfeed_uri)
      batch_uri = cellfeed_uri + '/batch'

        batch_request = <<FEED
<?xml version="1.0" encoding="utf-8"?> \
  <feed xmlns="http://www.w3.org/2005/Atom" \
  xmlns:batch="http://schemas.google.com/gdata/batch" \
  xmlns:gs="http://schemas.google.com/spreadsheets/2006" \
  xmlns:gd="http://schemas.google.com/g/2005">
  <id>#{cellfeed_uri}</id>
FEED

      batch_data.each do |batch_request_data|
        version_string = get_version_string(cellfeed_uri + '/' + batch_request_data[:cell_id])
        data = batch_request_data[:data]
        batch_id = batch_request_data[:batch_id]
        cell_id = batch_request_data[:cell_id]
        row = batch_request_data[:cell_id][1,1]
        column = batch_request_data[:cell_id][3,1]
        edit_link = cellfeed_uri + '/' + cell_id + '/' + version_string

        batch_request<< <<ENTRY
            <entry>
              <gs:cell col="#{column}" inputValue="#{data}" row="#{row}"/>
              <batch:id>#{batch_id}</batch:id>
              <batch:operation type="update" />
              <id>#{cellfeed_uri}/#{cell_id}</id>
              <link href="#{edit_link}" rel="edit" type="application/atom+xml" />
            </entry>
ENTRY
      end

      batch_request << '</feed>'
      return post(batch_uri, batch_request)
    end
  end
end