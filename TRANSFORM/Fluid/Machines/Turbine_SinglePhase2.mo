within TRANSFORM.Fluid.Machines;
model Turbine_SinglePhase2
  extends BaseClasses.PartialTurbine;

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
//   p_ratio = 1;
  eta_is = 0.85;
  eta_mech = 1.0;

  partialArc = 1.0;

  if use_Stodola then
    m_flow = homotopy(Kt*partialArc*sqrt(port_a.p*max(Medium.density(state_a),0.01))*
      Modelica.Fluid.Utilities.regRoot(1 - p_ratio^2), partialArc/
      partialArc_nominal*m_flow_nominal/p_inlet_nominal*port_a.p) "Stodola's law";
  else
    m_flow = homotopy(port_a.p*partialArc*m_flow_nominal/p_inlet_nominal,
      partialArc/partialArc_nominal*m_flow_nominal/p_inlet_nominal*port_a.p);
  end if;

  annotation (defaultComponentName="turbine",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Turbine_SinglePhase2;
