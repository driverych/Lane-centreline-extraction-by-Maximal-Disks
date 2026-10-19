% getXmlAttr - Get an XML attribute value by attribute name.
%
% Syntax:
%    value = getXmlAttr(xmlNode,attrName)
%
% Input:
%    xmlNode - a parsed XML node struct created by parseXML
%    attrName - the name of the target attribute
%
% Output:
%    value - the value of the target attribute
%
% Read attributes by name instead of fixed indexes so
% different Lanelet2/OSM attribute orders can be parsed by the same code.

function value = getXmlAttr(xmlNode,attrName)

    for idxAttr = 1:numel(xmlNode.Attributes)
        if strcmp(xmlNode.Attributes(idxAttr).Name,attrName)
            value = xmlNode.Attributes(idxAttr).Value;
            return
        end
    end

    if isfield(xmlNode,'Name')
        nodeName = xmlNode.Name;
    else
        nodeName = 'unknown';
    end
    error('XML attribute "%s" is not found in node "%s".',attrName,nodeName);

end
