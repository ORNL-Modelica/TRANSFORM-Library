within TRANSFORM.Fluid.Machines.Examples.PumpTests;
model PumpImpellerSize
  "Example 14-2: Selection of Pump Impeller Size"
  extends TRANSFORM.Icons.Example;

  package Medium = Modelica.Media.Water.StandardWater;

  parameter SI.Height head_nominal = TRANSFORM.Units.Conversions.Functions.Distance_m.from_ft(24);
  parameter SI.VolumeFlowRate V_flow_nominal = TRANSFORM.Units.Conversions.Functions.VolumeFlowRate_m3_s.from_gpm(370);
  parameter SI.Length diameter_nominal = TRANSFORM.Units.Conversions.Functions.Distance_m.from_in(8.25);
  parameter Modelica.Units.NonSI.AngularVelocity_rpm N_nominal=1160;

  parameter SI.Length diameter = TRANSFORM.Units.Conversions.Functions.Distance_m.from_in(12.75);

  parameter SI.Temperature T_nominal = TRANSFORM.Units.Conversions.Functions.Temperature_K.from_degF(70);
  parameter SI.Pressure p_nominal = 1e5;
  parameter Medium.ThermodynamicState state = Medium.setState_pT(p_nominal,T_nominal);
  parameter SI.Density d_nominal = Medium.density(state);
  parameter SI.PressureDifference dp_nominal = head_nominal*Modelica.Constants.g_n*d_nominal;
  parameter SI.Pressure p_source = p_nominal;
  parameter SI.Pressure p_sink = p_source+dp_nominal;
  parameter SI.MassFlowRate m_flow_nominal = d_nominal*V_flow_nominal;

  parameter Real table_english[:,2] = [8.343828043,531.377404; 16.80676215,459.9351107; 24.60145005,368.1722129;
            31.4017375,222.3206472; 32.45476602,102.723644; 33.16456417,0];
  parameter Real table[:,2] = {{if j == 1 then TRANSFORM.Units.Conversions.Functions.Distance_m.from_ft(table_english[i,j]) else
  TRANSFORM.Units.Conversions.Functions.VolumeFlowRate_m3_s.from_gpm(table_english[i,j])
  for j in 1:2} for i in 1:size(table_english,1)};

  parameter Real table_eta_english[3,2] = [103.614805,0.5; 259.0936365,0.74; 468.1280995,0.5];
  parameter Real table_eta[3,2] = {{if j == 1 then TRANSFORM.Units.Conversions.Functions.VolumeFlowRate_m3_s.from_gpm(table_eta_english[i,j]) else
  table_eta_english[i,j] for j in 1:2} for i in 1:size(table_eta_english,1)};

  BoundaryConditions.Boundary_pT Sink(
    use_p_in=false,
    redeclare package Medium = Medium,
    T=T_nominal,
    p=p_sink,
    nPorts=1) annotation (Placement(transformation(extent={{50,-10},{30,10}},
          rotation=0)));
  BoundaryConditions.Boundary_pT                 Source(
    p=p_source,
    redeclare package Medium = Medium,
    T=T_nominal,
    nPorts=1) annotation (Placement(transformation(extent={{-50,-10},{-30,10}},
                  rotation=0)));
  Pump_Controlled                          pump(
    redeclare package Medium = Medium,
    T_a_start=T_nominal,
    m_flow_start=m_flow_nominal,
    redeclare model EfficiencyChar =
        BaseClasses.PumpCharacteristics.Efficiency.QuadraticCurve_table (
         table=table_eta),
    N_nominal=N_nominal,
    redeclare model FlowChar =
        BaseClasses.PumpCharacteristics.Flow.PerformanceCurve_table (
          table=table),
    p_a_start=p_source,
    p_b_start=p_sink,
    diameter_nominal=diameter_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(Source.ports[1], pump.port_a)
    annotation (Line(points={{-30,0},{-10,0}}, color={0,127,255}));
  connect(pump.port_b, Sink.ports[1])
    annotation (Line(points={{10,0},{30,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Source:</p>
<p>1. Y. A. &Ccedil;ENGEL and J. M. CIMBALA, <i>Fluid Mechanics: Fundamentals and Applications</i>, 2. ed, McGraw-Hill, Higher Education, Boston (2010). </p>
</html>"));
end PumpImpellerSize;
