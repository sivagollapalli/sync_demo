require 'google/apis/sheets_v4'
require 'googleauth'

class Sync
  attr_accessor :sheet, :service, :range

  def initialize(sheet_id)
    @service = Google::Apis::SheetsV4::SheetsService.new
    @service.client_options.application_name = "Fennel_#{Rails.env}"
    # Place service JSON file in config dir
    @service.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open("#{Rails.root}/config/client_secret.json"),
      scope: Google::Apis::SheetsV4::AUTH_SPREADSHEETS
    )
    @sheet = sheet_id
  end

  def append(changes)
    request_body = Google::Apis::SheetsV4::ValueRange.new(range: range, values: changes)
    service.append_spreadsheet_value(sheet,
                                     range, 
                                     request_body,
                                     insert_data_option: 'INSERT_ROWS',
                                     value_input_option: 'RAW')
  end

  def update_sheet(range, changes)
    request_body = Google::Apis::SheetsV4::ValueRange.new(range: range, 
                                                          values: changes,
                                                          major_dimension: 'ROWS')
    service.update_spreadsheet_value(sheet, 
                                     range, 
                                     request_body,
                                     value_input_option: 'RAW')
  end
end
