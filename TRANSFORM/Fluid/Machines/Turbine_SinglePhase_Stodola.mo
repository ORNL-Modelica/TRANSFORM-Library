within TRANSFORM.Fluid.Machines;
model Turbine_SinglePhase_Stodola
  extends BaseClasses.PartialTurbine(eta_is=1.0,eta_mech=1.0);

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

  Modelica.Blocks.Interfaces.RealInput partialArc annotation (Placement(
        transformation(extent={{-60,-50},{-40,-30}}, rotation=0),
        iconTransformation(extent={{-60,-50},{-40,-30}})));

Real p_ratio "port_b.p/port_a.p pressure ratio";

initial equation
  if use_NominalInlet then
    if use_T_nominal then
      Kt = m_flow_nominal/(sqrt(T_nominal/Modelica.Constants.R)*
        Modelica.Fluid.Utilities.regRoot2(1 - (p_outlet_nominal/p_inlet_nominal)
        ^2));
    else
      Kt = m_flow_nominal/(sqrt(p_inlet_nominal*d_nominal)*
        Modelica.Fluid.Utilities.regRoot2(1 - (p_outlet_nominal/p_inlet_nominal)
        ^2));
    end if;
  else
    Kt = Kt_constant;
  end if;

equation
  p_ratio = port_b.p/port_a.p;
  if cardinality(partialArc) == 0 then
    partialArc = 1.0 "Default value if not connected";
  end if;

  if use_Stodola then
    m_flow = homotopy(Kt*partialArc*sqrt(port_a.p*max(Medium.density(state_a), 0.01))
      *Modelica.Fluid.Utilities.regRoot(1 - p_ratio^2), partialArc/
      partialArc_nominal*m_flow_nominal/p_inlet_nominal*port_a.p);
  else
    m_flow = homotopy(port_a.p*partialArc*m_flow_nominal/p_inlet_nominal,
      partialArc/partialArc_nominal*m_flow_nominal/p_inlet_nominal*port_a.p);
  end if;

  annotation (
    defaultComponentName="turbine",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Stodola method applies an &quot;ellipse law&quot; to the behavior of a multistage turbine. It is often used in steam turbine practice but can also be used in single phase, however, this approach is most suited for high pressure ratios.</p>
<p>Equation 4.32 of Source 1 or http://www.thermopedia.com/content/1222/</p>
<p>m_flow*sqrt(T_inlet)/p_inlet = k*sqrt(1-(p_outlet/p_inlet)^2)</p>
<p>Note: k has been multiplied by the constant sqrt(R) where R is gas constant.</p>
<p>Source</p>
<p>1. S. L. DIXON, <i>Fluid mechanics and thermodynamics of turbomachinery</i>, 4. ed. in SI/metric units, Butterworth-Heinemann, Boston, Mass. (1998). </p>
</html>"));
end Turbine_SinglePhase_Stodola;
