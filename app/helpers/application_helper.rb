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
end
