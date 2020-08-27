within TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.HomologousSets;
partial model PartialHomoSet
  parameter Real table_BAN[:,:]
  "Normal Torque beta/alpha^2 vs v/alpha";
  parameter Real table_BVN[:,:]
  "Normal Torque beta/v^2 vs alpha/v";
  parameter Real table_BAD[:,:]
  "Dissipation Torque beta/alpha^2 vs v/alpha";
  parameter Real table_BVD[:,:]
  "Dissipation Torque beta/v^2 vs alpha/v";
  parameter Real table_BAT[:,:]
  "Turbine Torque beta/alpha^2 vs v/alpha";
  parameter Real table_BVT[:,:]
  "Turbine Torque beta/v^2 vs alpha/v";
  parameter Real table_BAR[:,:]
  "Reverse Torque beta/alpha^2 vs v/alpha";
  parameter Real table_BVR[:,:]
  "Reverse Torque beta/v^2 vs alpha/v";
  parameter Real table_HAN[:,:]
  "Normal Head h/alpha^2 vs v/alpha";
  parameter Real table_HVN[:,:]
  "Normal Head h/v^2 vs alpha/v";
  parameter Real table_HAD[:,:]
  "Dissipation Head h/alpha^2 vs v/alpha";
  parameter Real table_HVD[:,:]
  "Dissipation Head h/v^2 vs alpha/v";
  parameter Real table_HAT[:,:]
  "Turbine Head h/alpha^2 vs v/alpha";
  parameter Real table_HVT[:,:]
  "Turbine Head h/v^2 vs alpha/v";
  parameter Real table_HAR[:,:]
  "Reverse Head h/alpha^2 vs v/alpha";
  parameter Real table_HVR[:,:]
  "Reverse Head h/v^2 vs alpha/v";
  parameter Real tCCF=1.0
  "Torque curve correction factor";
  parameter Real hCCF=1.0
  "Head curve correction factor";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialHomoSet;
