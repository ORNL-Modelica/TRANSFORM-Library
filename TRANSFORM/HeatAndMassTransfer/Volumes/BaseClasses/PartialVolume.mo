within TRANSFORM.HeatAndMassTransfer.Volumes.BaseClasses;
partial model PartialVolume

  import Modelica.Fluid.Types.Dynamics;

  extends TRANSFORM.Fluid.Interfaces.Records.Visualization_showName;

  replaceable package Material = TRANSFORM.Media.Solids.SS304 constrainedby
    TRANSFORM.Media.Interfaces.Solids.PartialAlloy
                                            "Material properties" annotation (
      choicesAllMatching=true);

  input SI.Volume V "Volume" annotation (Dialog(group="Input Variables"));

  parameter Dynamics energyDynamics=Dynamics.DynamicFreeInitial
    "Formulation of energy balances"
    annotation (Dialog(tab="Initialization", group="Dynamics"));

  parameter SI.Temperature T_start=298.15 "Temperature"
    annotation (Dialog(tab="Initialization", group="Start Value: Temperature"));

  Material.BaseProperties material(T(stateSelect=StateSelect.prefer, start=
          T_start));

  // Total quantities
  SI.Mass m "Mass";
  SI.InternalEnergy U "Internal energy";

  // Energy Balance
  SI.HeatFlowRate Ub
    "Energy source/sinks within volumes (e.g., ohmic heating, external convection)";

initial equation
  if energyDynamics == Dynamics.SteadyStateInitial then
    der(U) = 0;
    //der(T)=0;
  elseif energyDynamics == Dynamics.FixedInitial then
    material.T = T_start;
  end if;

equation

  // Total Quantities
  m = V*material.d;
  U = m*material.u;

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
end PartialVolume;
