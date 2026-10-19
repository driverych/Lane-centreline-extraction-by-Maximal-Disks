% wgs2utm - Convert the WGS84 coordinates into the UTM
%
% Syntax:  [x_utm,y_utm] = wgs2utm(x_wgs,y_wgs,origin)
%
% Input:
%    x_wgs - x position in WGS84
%    y_wgs - y position in WGS84
%    origin - UTM zone (utm_zone) and reference coordinates (utm_x,utm_y)
%
% Output:
%    x_utm - x position in UTM
%    y_utm - y position in UTM
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
% Abbreviation: none

function [x_utm,y_utm] = wgs2utm(x_wgs,y_wgs,origin)

    % The default is in the global coordinate
    isGlobal = 1;
    % Origins of location in the lanelet2 map
    xUtmOrigin = origin.utm_x;
    yUtmOrigin = origin.utm_y;

    % Amended settings according to Lanelet2
    wgs84_referencePara = wgs84Ellipsoid;
    UTM_ellipsoid(1,1) = wgs84_referencePara.SemimajorAxis;
    UTM_ellipsoid(1,2) = wgs84_referencePara.Eccentricity;
    utmStruct = defaultm('utm');
    utmStruct.zone = origin.utm_zone;
    utmStruct.geoid = UTM_ellipsoid;
    utmStruct = defaultm(utmStruct);
    
    if isGlobal == 1
        [x_utm, y_utm] = mfwdtran(utmStruct,x_wgs,y_wgs);
    else
        [x_utm, y_utm] = mfwdtran(utmStruct,x_wgs,y_wgs);
        % Convert the global to the local coordinate
        x_utm = x_utm - xUtmOrigin;
        y_utm = y_utm - yUtmOrigin;
    end

end
