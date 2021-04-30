within TRANSFORM.Chemistry.Thermochimica.BaseClasses;
record ThermochimicaOutput

  SIadd.ExtraProperty C[:];
  Real molesPhases[:];

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end ThermochimicaOutput;
