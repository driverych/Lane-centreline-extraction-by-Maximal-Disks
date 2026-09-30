

function [armPtSamples_innr,armPtSamples_outr,armPtNum_innr,armPtNum_outr] = createArmSegment(armStrtPt_innr,armStrtPt_outr,armDir,distResl,armLgth,extLgth)

% The increments in the x and y dircetion
delta_x = distResl.arm.innr * cosd(armDir);
delta_y = distResl.arm.innr * sind(armDir);
unitVect = [delta_x,delta_y];
% Create the arm by accumulating unitVect
armLgth_innr = armLgth;
[armPtSamples_innr,armPtNum_innr] = sampleLinePointsBasedOnUnitVector(armStrtPt_innr,unitVect,armLgth_innr,distResl.arm.innr);

% The increments in the x and y dircetion
delta_x = distResl.arm.outr * cosd(armDir);
delta_y = distResl.arm.outr * sind(armDir);
unitVect = [delta_x,delta_y];
% Create the arm by accumulating unitVect
armLgth_outr = armLgth+extLgth;
[armPtSamples_outr,armPtNum_outr] = sampleLinePointsBasedOnUnitVector(armStrtPt_outr,unitVect,armLgth_outr,distResl.arm.outr);

end