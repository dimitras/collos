module ApplicationHelper
    def format_tags(tags)
        raw(tags.to_s.split(/,\s*/).collect do |t|
            "<span class='tag'>#{t}</span>"
        end.join(" "))
    end
end
