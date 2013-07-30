module ApplicationHelper
    def format_tags(tags)
        raw(tags.split(/,\s*/).collect do |t|
            "<span class='tag'>#{t}</span>"
        end.join(" "))
    end
end
