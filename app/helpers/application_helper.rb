# frozen_string_literal: true

module ApplicationHelper
  def reformat_errors_object(old)
    return old unless old

    new = {}
    old.each do |v|
      if v[0] == :error_code
        new[:error] = { code: v[1][0][0], message: v[1][0][1] }
      else
        new[:errors] ||= {}
        new[:errors][v[0]] = v[1]
      end
    end
    new
  end

  def age(dob)
    return nil unless dob

    now = Time.now.utc.to_date
    now.year - dob.year - (now.month > dob.month || (now.month == dob.month && now.day >= dob.day) ? 0 : 1)
  end
end
