class UserSync < Sync
  def initialize
    # Replace with sheet ID
    super(<sheet id>)
    @range = 'users!A1'
  end

  def update(element, *changes)
    response = service.batch_get_spreadsheet_values(sheet, 
                                                    ranges: 'users!B:C', 
                                                    major_dimension: 'COLUMNS')
    col_values = response.value_ranges.first.values
    down_sync_timestamps = col_values.first
    userids = col_values.last

    if userids.index(element.to_s).nil?
      append(changes)
      return
    end

    index = userids.index(element.to_s)
    range = "users!A#{index + 1}:Z#{index + 1}"
    changes[0][1] = down_sync_timestamps[index]

    update_sheet(range, changes)
  end 
end
