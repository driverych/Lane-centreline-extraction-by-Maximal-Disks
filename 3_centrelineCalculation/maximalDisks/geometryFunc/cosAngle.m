function cosValue = cosAngle(vector1,vector2)
    x1 = vector1(1);y1 = vector1(2);
    x2 = vector2(1);y2 = vector2(2);
    cosValue = (x1*x2 + y1*y2)/(sqrt(x1^2 + y1^2)+sqrt(x2^2 + y2^2));
end