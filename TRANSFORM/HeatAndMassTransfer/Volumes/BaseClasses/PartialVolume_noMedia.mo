within TRANSFORM.HeatAndMassTransfer.Volumes.BaseClasses;
partial model PartialVolume_noMedia

  import Modelica.Fluid.Types.Dynamics;

  extends TRANSFORM.Fluid.Interfaces.Records.Visualization_showName;

  input SI.Volume V "Volume" annotation (Dialog(group="Inputs"));

  parameter Dynamics energyDynamics=Dynamics.DynamicFreeInitial
    "Formulation of energy balances"
    annotation (Dialog(tab="Initialization", group="Dynamics"));

  parameter SI.Temperature T_start=298.15 "Temperature"
    annotation (Dialog(tab="Initialization", group="Start Value: Temperature"));
  parameter SI.Temperature T_reference=273.15
    "Reference temperature for zero enthalpy"
    annotation (Dialog(tab="Advanced"));

  input SI.Density d "Density" annotation (Dialog(group="Inputs"));
  input SI.SpecificHeatCapacity cp "Specific heat capacity"
    annotation (Dialog(group="Inputs"));

  SI.Temperature T(stateSelect=StateSelect.prefer, start=T_start) "Temperature";

  // Total quantities
  SI.Mass m "Mass";
  SI.InternalEnergy U "Internal energy";

  // Energy Balance
  SI.HeatFlowRate Ub
    "Energy source/sinks within volumes (e.g., ohmic heating, external convection)";

initial equation
  if energyDynamics == Dynamics.SteadyStateInitial then
    der(U) = 0;
  elseif energyDynamics == Dynamics.FixedInitial then
    T = T_start;
  end if;

equation

  // Total Quantities
  m = d*V;
  U = m*cp*(T - T_reference);

  // Energy Balance
  if energyDynamics == Dynamics.SteadyState then
    0 = Ub;
  else
    der(U) = Ub;
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-149,112},{151,72}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true,showName))}),               Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialVolume_noMedia;
