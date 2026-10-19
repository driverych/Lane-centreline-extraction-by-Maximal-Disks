function indices = findXmlChildrenByName(children,nodeName)
    % findXmlChildrenByName - Find XML children by type, ignoring whitespace.
    indices = [];
    if isempty(children)
        return
    end
    indices = find(strcmp({children.Name},nodeName));
    indices = reshape(indices,1,[]);
end
