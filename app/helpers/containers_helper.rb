module ContainersHelper
    def grid(container)
        if container.can_have_children?
            # this is not a leaf node, hence no samples
        else
            # this is a lead node, e.g. contains samples
        end
    end
end
