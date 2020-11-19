within TRANSFORM.Fluid.Machines;
model SteamTurbine
  "Steam turbine: Includes options for Stodola's ellipse law, multiple units, etc."
  extends TRANSFORM.Fluid.Machines.BaseClasses.SteamTurbineBase;
  parameter Real partialArc_nominal=1 "Nominal partial arc";
  parameter SI.MassFlowRate m_flow_nominal=m_flow_start "Nominal mass flowrate";
  // Nominal Inlet Parameters for Kt
  parameter Boolean use_Stodola=true
    "=true to use Stodola's law, i.e., infinite stages per unit"
    annotation (Dialog(group="Stodola's Law Coefficient"));
  parameter SI.Area Kt_constant=0.01 "Constant coefficient of Stodola's law"
    annotation (Dialog(group="Stodola's Law Coefficient", enable=if not
          use_NominalInlet and use_Stodola then true else false));
  parameter Boolean use_NominalInlet=true
    "=true then Kt is calculated from nominal inlet conditions"
    annotation (Dialog(group="Stodola's Law Coefficient", enable=use_Stodola));
  parameter SI.Pressure p_inlet_nominal=p_a_start "Nominal inlet pressure";
  parameter SI.Pressure p_outlet_nominal=p_b_start "Nominal outlet pressure"
    annotation (Dialog(group="Stodola's Law Coefficient", enable=if
          use_NominalInlet and use_Stodola then true else false));
  parameter Boolean use_T_nominal=true
    "=true then use temperature for Kt else density" annotation (Dialog(group="Stodola's Law Coefficient",
        enable=if use_NominalInlet and use_Stodola then true else false));
  parameter SI.Temperature T_nominal=T_a_start "Nominal inlet temperature"
    annotation (Dialog(group="Stodola's Law Coefficient", enable=if
          use_NominalInlet and use_T_nominal and use_Stodola then true else false));
  parameter SI.Density d_nominal=Medium.density(Medium.setState_pTX(
      p_inlet_nominal,
      T_nominal,
      Medium.reference_X)) "Nominal inlet density" annotation (Dialog(group="Stodola's Law Coefficient",
        enable=if use_NominalInlet and not use_T_nominal and use_Stodola then true
           else false));
  final parameter SI.Area Kt(fixed=false) "Flow area coefficient";
initial equation
  if use_NominalInlet then
    //     Kt = m_flow_nom*sqrt(p_inlet/Medium.density_pT(p_inlet,T_nom))/
    //          sqrt(p_inlet^2-p_outlet^2);
    if use_T_nominal then
      Kt = m_flow_nominal/(sqrt(p_inlet_nominal*Medium.density(
        Medium.setState_pTX(
        p_inlet_nominal,
        T_nominal,
        Medium.reference_X)))*Modelica.Fluid.Utilities.regRoot2(1 - (
        p_outlet_nominal/p_inlet_nominal)^2));
    else
      Kt = m_flow_nominal/(sqrt(p_inlet_nominal*d_nominal)*
        Modelica.Fluid.Utilities.regRoot2(1 - (p_outlet_nominal/p_inlet_nominal)
        ^2));
    end if;
  else
    Kt = Kt_constant;
  end if;
equation
  if use_Stodola then
    m_flow = homotopy(Kt*partialArc*sqrt(p_in*Medium.density(state_a))*
      Modelica.Fluid.Utilities.regRoot(1 - p_ratio^2), partialArc/
      partialArc_nominal*m_flow_nominal/p_inlet_nominal*p_in) "Stodola's law";
  else
    m_flow = homotopy(portHP.p*partialArc*m_flow_nominal/p_inlet_nominal,
      partialArc/partialArc_nominal*m_flow_nominal/p_inlet_nominal*p_in);
  end if;
  annotation (defaultComponentName="steamTurbine", Documentation(info="<html>
<p>This model extends <code>SteamTurbineBase</code> by adding the actual performance characteristics: </p>
<ul>
<li>Stodola&apos;s law with an optional correction due to degradation using Baumann&apos;s formula</li>
<li>Constant isentropic efficiency </li>
</ul>
<p>The inlet flowrate is also proportional to the <code>partialArc</code> signal if the corresponding connector is wired. In this case, it is assumed that the flow rate is reduced by partial arc admission, not by throttling (i.e., no loss of thermodynamic efficiency occurs). To simulate throttling, insert a valve model before the turbine inlet. </p>
<p>Parameter use_NominalInlet decides if the flow area coefficient is given as a parameter Kt or calculated from nominal values at an operating point. The flow area coefficient Kt, defined at design conditions by Kt = m_flow*sqrt(R*T)/sqrt(p1^2 - p2^2), can be interpreted as effective turbine flow area. </p>
<h4>Isentropic efficiency</h4>
<p>By default is the isentropic efficiency a parmeter equal to eta_is_nom. But if use_Baumann is true the efficiency is degraded if the fluid enters the two-phase region according to Baumans formula: eta_is = eta_is_nom*(1 - a_Baumann*(1 - x)), where a_Baumann is a parameter and x is the inlet steam quality.</p>
<h4>Assumptions</h4>
<p>Stodola&apos;s law (infinite number of stages) </p>
<p>Constant isentropic efficiency with an optional efficiency degradation using Baumann&apos;s formula </p>
<p>No energy or mass storage</p>
<p>No shaft inertia. If needed, connect a Modelica.Mechanics.Rotational.Components.Inertia model to one of the shaft connectors. </p>
<h4>References</h4>
<p>Cooke, D. H., &apos;On Prediction of Off-Design Multistage Turbine Pressures by Stodola&apos;s Ellipse,&apos;</p>
<p>J. Eng. Gas Turbines Power, Volume 107, Issue 3, pp. 596, 1985.</p>
</html>", revisions="<html>
</html>"));
end SteamTurbine;
