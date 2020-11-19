within TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.NondimensionalCurves;
partial model PartialNonDimCurve
  parameter Real table_h[:,:]
    "Normalized head matrix (first column theta [0,2*pi], second column h)";
  parameter Real table_beta[:,:]
    "Normalized torque matrix (first column theta [0,2*pi], second column beta)";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialNonDimCurve;
