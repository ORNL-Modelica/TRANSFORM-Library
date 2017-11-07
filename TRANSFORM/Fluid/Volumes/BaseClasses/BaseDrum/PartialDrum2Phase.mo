within TRANSFORM.Fluid.Volumes.BaseClasses.BaseDrum;
partial model PartialDrum2Phase "partial two phase drum model"

  import Modelica.Fluid.Types;
  import Modelica.Fluid.Types.Dynamics;

  outer Modelica.Fluid.System system "System properties";

  replaceable package Medium = Modelica.Media.Water.StandardWater
    constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium
    "Medium in the component"
     annotation(choicesAllMatching=true);

  /* General */
  parameter SI.Volume V_total "Total volume (liquid + vapor)" annotation(Dialog(group="Geometry"));

  /* Assumptions */
  parameter Boolean allowFlowReversal=system.allowFlowReversal
    "= true to allow flow reversal, false restrics to design direction"
    annotation(Dialog(tab="Assumptions"));
  parameter Types.Dynamics energyDynamics=system.energyDynamics
    "Formulation of energy balance"
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
  parameter Types.Dynamics massDynamics=system.massDynamics
    "Formulation of mass balance"
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));

  /* Initialization */
  parameter TRANSFORM.Units.nonDim Vfrac_liquid_start=0.5
    "Initial fraction of volume in the liquid phase"
    annotation (Dialog(tab="Initialization"));
  parameter SI.Pressure p_start=system.p_start "Pressure start value"
    annotation (Dialog(tab="Initialization"));
  parameter SI.SpecificEnthalpy h_liquid_start=Medium.bubbleEnthalpy(Medium.setSat_p(p_start))
    "Liquid specific enthalpy start value"
    annotation (Dialog(tab="Initialization"));
  parameter SI.SpecificEnthalpy h_vapor_start=Medium.dewEnthalpy(Medium.setSat_p(p_start))
    "Vapour specific enthalpy start value"
    annotation (Dialog(tab="Initialization"));

  SI.Pressure p(start=p_start, stateSelect=StateSelect.prefer)
    "Surface pressure";

  SI.Volume V_vapor(start=(1-Vfrac_liquid_start)*V_total)
    "Volume occupied by vapour";
  SI.Volume V_liquid(start=Vfrac_liquid_start*V_total)
    "Volume occupied by liquid";

  TRANSFORM.Units.nonDim Vfrac_liquid(start=Vfrac_liquid_start,
      stateSelect=StateSelect.prefer)
    "Fractional of total volume occupied by liquid";

  Medium.ThermodynamicState state_liquid = Medium.setState_ph(p,h_liquid)
    "Liquid state";
  SI.Density rho_liquid = Medium.density(state_liquid) "Liquid density";
  SI.SpecificEnthalpy h_liquid(start=h_liquid_start, stateSelect=StateSelect.prefer)
    "Liquid specific enthalpy";
  SI.Temperature T_liquid = Medium.temperature(state_liquid)
    "Liquid temperature";

  Medium.ThermodynamicState state_vapor = Medium.setState_ph(p,h_vapor)
    "Vapor state";
  SI.Density rho_vapor = Medium.density(state_vapor) "Vapor density";
  SI.SpecificEnthalpy h_vapor(start=h_vapor_start, stateSelect=StateSelect.prefer)
    "Vapor specific enthalpy";
  SI.Temperature T_vapor = Medium.temperature(state_vapor) "Vapor temperature";

  Medium.SaturationProperties sat = Medium.setSat_p(p)
    "State vector to compute saturation properties";
  SI.SpecificEnthalpy h_gsat = Medium.dewEnthalpy(sat)
    "Saturated vapor specific enthalpy";
  SI.SpecificEnthalpy h_fsat = Medium.bubbleEnthalpy(sat)
    "Saturated liquid specific enthalpy";
  ThermoPower.AbsoluteTemperature Tsat = sat.Tsat "Saturation temperature";

  SI.Energy U_liquid "Internal energy of liquid";
  SI.Mass m_liquid "Mass of liquid";
  SI.MassFlowRate mb_flow_liquid "Mass flows across liquid boundaries";
  SI.EnthalpyFlowRate Hb_flow_liquid
    "Enthalpy flow across liquid boundaries or energy source/sink";
  SI.HeatFlowRate Qb_flow_liquid
    "Heat flow across liquid boundaries or energy source/sink";
  SI.Power Wb_flow_liquid "Work flow across liquid boundaries or source term";

  SI.Energy U_vapor "Internal energy of vapor";
  SI.Mass m_vapor "Mass of vapor";
  SI.MassFlowRate mb_flow_vapor "Mass flows across vapor boundaries";
  SI.EnthalpyFlowRate Hb_flow_vapor
    "Enthalpy flow across vapor boundaries or energy source/sink";
  SI.HeatFlowRate Qb_flow_vapor
    "Heat flow across vapor boundaries or energy source/sink";
  SI.Power Wb_flow_vapor "Work flow across vapor boundaries or source term";

initial equation

  if energyDynamics == Dynamics.FixedInitial then
    p = p_start;
    h_liquid = h_liquid_start;
    h_vapor = h_vapor_start;
  elseif energyDynamics == Dynamics.SteadyStateInitial then
    der(p) = 0;
    der(h_liquid) = 0;
    der(h_vapor) = 0;
  end if;

  if massDynamics == Dynamics.FixedInitial then
    Vfrac_liquid = Vfrac_liquid_start;
   elseif massDynamics == Dynamics.SteadyStateInitial then
    der(Vfrac_liquid) = 0;
  end if;

equation

  /* Total Quantities */
  // === Liquid ===
  m_liquid = V_liquid*rho_liquid;
  U_liquid = m_liquid*Medium.specificInternalEnergy(state_liquid);

  // === Vapor ===
  m_vapor = V_vapor*rho_vapor;
  U_vapor = m_vapor*Medium.specificInternalEnergy(state_vapor);

  /* Volume Balance Equations */
  V_total = V_liquid + V_vapor;
  Vfrac_liquid = V_liquid/V_total;

  /* Mass Conservation Equations */
  // === Liquid ===
  if massDynamics == Dynamics.SteadyState then
    0 = mb_flow_liquid;
  else
    der(m_liquid) = mb_flow_liquid;
  end if;

  // === Vapor ===
  if massDynamics == Dynamics.SteadyState then
    0 = mb_flow_vapor;
  else
    der(m_vapor) = mb_flow_vapor;
  end if;

  /* Energy Conservation Equations */
  // === Liquid ===
  if energyDynamics == Dynamics.SteadyState then
    0 = Hb_flow_liquid + Qb_flow_liquid + Wb_flow_liquid;
  else
    der(U_liquid) = Hb_flow_liquid + Qb_flow_liquid + Wb_flow_liquid;
  end if;

  // === Vapor ===
  if energyDynamics == Dynamics.SteadyState then
    0 = Hb_flow_vapor + Qb_flow_vapor + Wb_flow_vapor;
  else
    der(U_vapor) = Hb_flow_vapor + Qb_flow_vapor + Wb_flow_vapor;
  end if;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
         graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-99,1},{99,-99}},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-66,46},{-60,38}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-82,72},{-76,64}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-16,54},{-10,46}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-28,84},{-22,76}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{20,36},{26,28}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-38,28},{-32,20}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{64,66},{70,58}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{24,74},{30,66}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{66,34},{72,26}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-72,-16},{-66,-24}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-36,-40},{-30,-48}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-72,-44},{-66,-52}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{14,-32},{20,-40}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{64,-48},{70,-56}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{48,-12},{54,-20}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{32,-64},{38,-72}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-12,-14},{-6,-22}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-52,-68},{-46,-76}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0})}),
    Documentation(info="<html>
<p>Spray stream is assumed to be saturated liquid. This means there is no equation for condensing due to spray.... this was causing solver problems... Should be addressed.</p>
<p><br>This model describes the cylindrical drum of a drum boiler, without assuming thermodynamic equilibrium between the liquid and vapour holdups. Connectors are provided for surgePort inlet, steamPort outlet, downcomer outlet, riser inlet, and blowdown outlet. </p>
<p>The model is based on dynamic mass and energy balance equations of the liquid volume and vapour volume inside the drum. Mass and energy tranfer between the two phases is provided by bulk condensation and surface condensation of the vapour phase, and by bulk boiling of the liquid phase. Additional energy transfer can take place at the surface if the steamPort is superheated. </p>
<p>The riser flowrate is separated before entering the drum, at the vapour pressure. The (saturated) liquid fraction goes into the liquid volume; the (wet) vapour fraction goes into the vapour volume, vith a steamPort quality depending on the liquid/vapour density ratio and on the <code><span style=\"font-family: Courier New,courier;\">avr</span></code> parameter. </p>
<p>The enthalpy of the liquid going to the downcomer is computed by assuming that a fraction of the total mass flowrate (<code><span style=\"font-family: Courier New,courier;\">afd</span></code>) comes directly from the surgePort inlet. The pressure at the downcomer connector is equal to the vapour pressure plus the liquid head. </p>
<p>The metal wall dynamics is taken into account, assuming uniform temperature. Heat transfer takes place between the metal wall and the liquid phase, vapour phase, and external atmosphere, the corresponding heat transfer coefficients being <code><span style=\"font-family: Courier New,courier;\">gl</span></code>, <code><span style=\"font-family: Courier New,courier;\">gv</span></code>, and <code><span style=\"font-family: Courier New,courier;\">gext</span></code>. </p>
<p>The drum level is referenced to the centreline. </p>
<p>The start values of drum pressure, liquid specific enthalpy, vapour specific enthalpy, and metal wall temperature can be specified by setting the parameters <code><span style=\"font-family: Courier New,courier;\">p_start</span></code>, <code><span style=\"font-family: Courier New,courier;\">h_liquid_start</span></code>, <code><span style=\"font-family: Courier New,courier;\">h_vapor_start</span></code>, <code><span style=\"font-family: Courier New,courier;\">Tmstart</span></code> </p>
<h4>Modelling options</h4>
<p>The following options are available to specify the orientation of the cylindrical drum: </p>
<ul>
<li><code><span style=\"font-family: Courier New,courier;\">DrumOrientation = 0</span></code>: horizontal axis. </li>
<li><code><span style=\"font-family: Courier New,courier;\">DrumOrientation = 1</span></code>: vertical axis. </li>
</ul>
</html>",
        revisions="<htm_liquid>
<ul>
<li><i>30 May 2005</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Initialisation support added.</li>
<li><i>16 Dec 2004</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Standard medium definition added.</li>
<li><i>5 Jul 2004</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Adapted to Modelica.Media.</li>
<li><i>1 Feb 2004</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Improved equations for drum geometry.</li>
<li><i>1 Oct 2003</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       First release.</li>
</ul>
"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end PartialDrum2Phase;
