within TRANSFORM.HeatAndMassTransfer.Volumes;
model UnitVolume_withMedia
  import Modelica.Fluid.Types.Dynamics;
  extends TRANSFORM.Fluid.Interfaces.Records.Visualization_showName;
  parameter Real nParallel=1 "Number of parallel components";
  replaceable package Material =
    TRANSFORM.Media.Interfaces.Solids.PartialAlloy
    "Material properties" annotation (choicesAllMatching=true);
  parameter Dynamics energyDynamics=Dynamics.DynamicFreeInitial
    "Formulation of energy balances"
    annotation (Dialog(tab="Initialization", group="Dynamics"));
  parameter SI.Temperature T_start = 298.15 "Temperature"
    annotation(Dialog(tab = "Initialization",group="Start Value: Temperature"));
  parameter SI.Density d_reference=Material.density(Material.setState_T(T_start))
    "Reference density of mass reference for constant volumes"
    annotation (Dialog(tab="Advanced"));
  input SI.Volume V "Volume" annotation(Dialog(group="Inputs"));
  input SI.HeatFlowRate Q_gen = 0 "Internal heat generation" annotation(Dialog(group="Inputs"));
  SI.InternalEnergy U "Internal energy";
  SI.Mass m "Mass";
  SI.Mass delta_m "Change in mass of constant volume";
  Material.BaseProperties material(T(stateSelect=StateSelect.prefer,
        start=T_start));
  Interfaces.HeatPort_State port "Heat flow across boundary"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
initial equation
  if energyDynamics == Dynamics.SteadyStateInitial then
    der(U) = 0;
  elseif energyDynamics == Dynamics.FixedInitial then
    material.T = T_start;
  end if;
equation
  // Total Quantities
  m = V*d_reference;
  delta_m = m - V*material.d;
  U = V*material.d*material.u;
  // Energy Balance
  if energyDynamics == Dynamics.SteadyState then
    0 =port.Q_flow/nParallel + Q_gen;
  else
    der(U) =port.Q_flow/nParallel + Q_gen;
  end if;
  // Port Definitions
  port.T = material.T;
  annotation (defaultComponentName="volume",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Polygon(
          points={{0,77},{-20,73},{-40,67},{-52,53},{-58,45},{-68,35},{-72,23},
            {-76,9},{-78,-5},{-76,-21},{-76,-33},{-76,-43},{-70,-55},{-64,-63},
            {-48,-67},{-30,-73},{-18,-73},{-2,-75},{8,-79},{22,-79},{32,-77},
            {42,-71},{54,-65},{56,-63},{66,-51},{68,-43},{70,-41},{72,-25},{
            76,-11},{78,-3},{78,13},{74,25},{66,35},{54,43},{44,51},{36,67},{
            26,75},{0,77}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-58,45},{-68,35},{-72,23},{-76,9},{-78,-5},{-76,-21},{-76,
            -33},{-76,-43},{-70,-55},{-64,-63},{-48,-67},{-30,-73},{-18,-73},
            {-2,-75},{8,-79},{22,-79},{32,-77},{42,-71},{54,-65},{42,-67},{40,
            -67},{30,-69},{20,-71},{18,-71},{10,-71},{2,-67},{-12,-63},{-22,
            -63},{-30,-61},{-40,-55},{-50,-45},{-56,-33},{-58,-25},{-58,-15},
            {-60,-3},{-60,5},{-60,17},{-58,27},{-56,29},{-52,37},{-48,45},{
            -44,55},{-40,67},{-58,45}},
          lineColor={0,0,0},
          fillColor={160,160,164},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,112},{151,72}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true,showName))}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Interface and base class for a solid volume able to store energy. The following boundary flow and source terms are part of the energy balance and must be specified in an extending class: </p>
<ul>
<li>Qb_flow: heat flow rate across boundary</li>
<li>Q_gen: internal heat generation, e.g. q_ppp*Volume</li>
</ul>
<p>The component volume, V, is an input that needs to be set in the extending class to complete the model. </p>
</html>"));
end UnitVolume_withMedia;
