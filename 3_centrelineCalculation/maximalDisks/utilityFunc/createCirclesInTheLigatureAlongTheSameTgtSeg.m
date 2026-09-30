% This solution is from Marco


% function CC_lgt = createCirclesInTheLigatureAlongTheSameTgtSeg(strtPt_borderSeg,vctr_borderSeg,CC_strt,CC_end,passedPt,lgthBorderSeg) % gpt ver: Original centre-only output kept for reference.
function [CC_lgt,radius_lgt] = createCirclesInTheLigatureAlongTheSameTgtSeg(strtPt_borderSeg,vctr_borderSeg,CC_strt,CC_end,passedPt,lgthBorderSeg) % TODO gpt ver: Return radii for ligature interference validation.

% the projection from the circle centre to the start point of the border segment
k1 = (vctr_borderSeg(1)*CC_strt(1) + vctr_borderSeg(2)*CC_strt(2) - vctr_borderSeg(1)*strtPt_borderSeg(1) - vctr_borderSeg(2)*strtPt_borderSeg(2))/(vctr_borderSeg(1)^2 + vctr_borderSeg(2)^2);
k2 = (vctr_borderSeg(1)*CC_end(1) + vctr_borderSeg(2)*CC_end(2) - vctr_borderSeg(1)*strtPt_borderSeg(1) - vctr_borderSeg(2)*strtPt_borderSeg(2))/(vctr_borderSeg(1)^2 + vctr_borderSeg(2)^2);  

% If the k1 and k2 exceed the length of the border segment
if k1 >= lgthBorderSeg
    CC_lgt = [];
    radius_lgt = []; % TODO gpt ver: Keep output shape consistent when no ligature circle is generated.
    return
else
    k2 = min(k2,lgthBorderSeg);
end

if k2 < 0
    CC_lgt = [];
    radius_lgt = []; % TODO gpt ver: Keep output shape consistent when no ligature circle is generated.
    return
else
    k1 = max(k1,0);
end
    
% interpolate between k1 and k2
numInterp = 10;
k_list = linspace(k1,k2,numInterp);

% Use the border segment (tagent to the circle)
l21 = vctr_borderSeg(1);
l22 = vctr_borderSeg(2);
p21 = strtPt_borderSeg(1);
p22 = strtPt_borderSeg(2);
% The passed point (shared point by all circles)
p31 = passedPt(1);
p32 = passedPt(2);
% The centre of the circle
p01 = [];
p02 = [];
for k = k_list
    alpha1 = l21*p22 - l22*p21 - l21*p32 + l22*p31;
    alpha2 = p22^2 + p21^2  + p31^2 + p32^2;
    alpha3 = l21*p21 + l22*p22;
    alpha4 = l21*p22 - l22*p21;
    alpha5 = l21^2 + l22^2;
    p01(end+1) = ((l22*k^2 + 2*k*p22 - 2*k*p32)*alpha5 + 2*p21*alpha4 - 2*p32*alpha3 + l22*alpha2)/(2*alpha1);
    p02(end+1) = -((l21*k^2 + 2*k*p21 - 2*k*p31)*alpha5 - 2*p22*alpha4 - 2*p31*alpha3 + l21*alpha2)/(2*alpha1);
end

% ------------------------- plot for test -------------------------
% line(p01,p02,'LineStyle',':','Marker','+');

CC_lgt = [p01',p02'];
radius_lgt = sqrt((CC_lgt(:,1) - passedPt(1)).^2 + (CC_lgt(:,2) - passedPt(2)).^2); % TODO gpt ver: Ligature circles pass through passedPt, so this restores their radii.

end
