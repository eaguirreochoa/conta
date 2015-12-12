module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Sys"
    if page_title.empty?
      base_title
    else
      "#{page_title}"
    end
  end

  def sub_title(page_sub_title)
  	  "#{page_sub_title}"
  end
end
