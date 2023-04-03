within TRANSFORM.Utilities.Visualizers.BaseClasses;
partial model ScalingXYVectors
  parameter Real minX=0;
  parameter Real maxX=1;
  parameter Real minY=0;
  parameter Real maxY=1;
  input Real scaledX[:] = {1};
  input Real scaledY[size(scaledX, 1)];
  Real unScaledX[size(scaledX, 1)](min=0, max=1);
  Real unScaledY[size(scaledX, 1)](min=0, max=1);
equation
  scaledX = unScaledX*(maxX - minX) + fill(minX, size(scaledX, 1));
  scaledY = unScaledY*(maxY - minY) + fill(minY, size(scaledY, 1));
end ScalingXYVectors;
