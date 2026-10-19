function value = getXmlTagValue(xmlNode,tagKey)
% getXmlTagValue - Read a tag by key independently of child order.
value = '';
indices = findXmlChildrenByName(xmlNode.Children,'tag');
for idxTag = indices
    tag = xmlNode.Children(idxTag);
    if strcmp(getXmlAttr(tag,'k'),tagKey)
        value = getXmlAttr(tag,'v');
        return
    end
end
end
