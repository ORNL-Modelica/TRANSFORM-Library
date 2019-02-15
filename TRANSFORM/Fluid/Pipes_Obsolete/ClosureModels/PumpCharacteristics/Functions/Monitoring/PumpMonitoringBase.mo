within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PumpCharacteristics.Functions.Monitoring;
partial model PumpMonitoringBase "Interface for pump monitoring"
  outer Modelica.Fluid.System system "System wide properties";
  //
  // Internal interface
  // (not exposed to GUI; needs to be hard coded when using this model
  //
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation(Dialog(tab="Internal Interface",enable=false));
  // Inputs
  input Medium.ThermodynamicState state_in
    "Thermodynamic state of inflow";
  input Medium.ThermodynamicState state "Thermodynamic state in the pump";
end PumpMonitoringBase;
