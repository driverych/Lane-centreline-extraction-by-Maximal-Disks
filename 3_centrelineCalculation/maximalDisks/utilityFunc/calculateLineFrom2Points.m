function [p1, l1] = calculateLineFrom2Points(p1,p2)
%CALCULATELINEFROM2POINTS calculates the parametric form of a line starting
%from 2 point that belongs to it
l1 = (p2 - p1);
l1 = l1/norm(l1);

end

