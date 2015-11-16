module AdminHelper

  def users_in_date_range(start_date: nil, end_date: nil)
    user_scope = User.current
    user_scope = user_scope.where("DATE(users.created_at) >= ?", start_date) if start_date
    user_scope = user_scope.where("DATE(users.created_at) <= ?", end_date) if end_date
    user_scope
  end

  def show_count_difference(current_count, last_count, append: '', format: nil)
    difference = current_count - last_count
    difference_string = if format.present?
      format % difference
    else
      number_with_delimiter difference
    end
    current_count_string = if format.present?
      format % current_count
    else
      number_with_delimiter current_count
    end
    title = "#{'+' if difference > 0}#{"#{difference_string}#{append}" if difference != 0}"
    content = if difference > 0
      content_tag(:i, nil, class: "fa fa-caret-up text-success")
    elsif difference < 0
      content_tag(:i, nil, class: "fa fa-caret-down text-danger")
    end
    content = "#{content} #{current_count_string}#{append}".html_safe
    content_tag(
      :span, content,
      class: "nowrap",
      data: {
        toggle: 'tooltip',
        container: 'body',
        placement: 'left',
        title: title
      }
    )
  end

  def engagement_data(record_data, start_date, end_date)
    data = []
    (start_date.beginning_of_day.to_i..end_date.end_of_day.to_i).step(1.hour) do |d|
      data.push([Time.at(d).day, Time.at(d).hour, record_data.where("updated_at > ? and updated_at < ?", Time.at(d), Time.at(d)+1.hour).count])
    end
    data
  end

end
