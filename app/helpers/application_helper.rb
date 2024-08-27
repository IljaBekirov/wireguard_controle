# frozen_string_literal: true

module ApplicationHelper
  def human_readable_size(size_in_bytes)
    units = %w[B KB MB GB TB PB EB]
    return '0 B' if size_in_bytes.zero?

    size = size_in_bytes.to_f
    unit_index = 0

    while size >= 1024 && unit_index < units.length - 1
      size /= 1024
      unit_index += 1
    end

    formatted_size = (size % 1).zero? ? size.to_i : size.round(1)

    "#{formatted_size} #{units[unit_index]}"
  end

  def time_zone(datetime)
    return '' unless datetime

    utc_time = Time.parse(datetime)
    utc_time.in_time_zone(Time.zone)
  end
end
