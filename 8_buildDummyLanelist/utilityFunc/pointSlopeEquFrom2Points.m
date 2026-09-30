% This function is to calculate line equation(point-slope equation) from
% the given two points
% (y - y1)/(y2 - y1) = (x - x1)/(x2 - x1)
% (y2 - y1)x - (x2 - x1)y + y1(x2 - x1) - x1(y2 - y1) = 0
% y = k*x + b
% k = (y2 - y1)/(x2 - x1), b = y1 - x1(y2 - y1)/(x2 - x1)
function par = pointSlopeEquFrom2Points(point_1,point_2)
    x_1 = point_1(1);y_1 = point_1(2);
    x_2 = point_2(1);y_2 = point_2(2);

    delta_x = x_2 - x_1;
    
    if delta_x == 0
        k = 0;
        b = x_1;
    else
        k = (y_2 - y_1)/(x_2 - x_1);
        b = y_1 - x_1*(y_2 - y_1)/(x_2 - x_1);
    end
    
    par = [k,b];

end