within TRANSFORM.Utilities.Visualizers.BaseClasses;
partial model Scaling
  parameter Real min=0;
  parameter Real max=1;
  Real unScaled(min=0, max=1);
  Real scaled=unScaled*(max - min) + min;
end Scaling;
