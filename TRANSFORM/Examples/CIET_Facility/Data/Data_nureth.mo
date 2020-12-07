within TRANSFORM.Examples.CIET_Facility.Data;
model Data_nureth

  extends TRANSFORM.Icons.Record;

  parameter Integer index_1 = 1 annotation(Dialog(tab="Indices"));
  parameter Integer index_2 = 2 annotation(Dialog(tab="Indices"));
  parameter Integer index_3 = 3 annotation(Dialog(tab="Indices"));
  parameter Integer index_4 = 4 annotation(Dialog(tab="Indices"));
  parameter Integer index_5 = 5 annotation(Dialog(tab="Indices"));
  parameter Integer index_6 = 6 annotation(Dialog(tab="Indices"));
  parameter Integer index_7 = 7 annotation(Dialog(tab="Indices"));
  parameter Integer index_8 = 8 annotation(Dialog(tab="Indices"));
  parameter Integer index_9 = 9 annotation(Dialog(tab="Indices"));
  parameter Integer index_10 = 10 annotation(Dialog(tab="Indices"));
  parameter Integer index_11 = 11 annotation(Dialog(tab="Indices"));
  parameter Integer index_12 = 12 annotation(Dialog(tab="Indices"));
  parameter Integer index_13 = 13 annotation(Dialog(tab="Indices"));
  parameter Integer index_14 = 14 annotation(Dialog(tab="Indices"));
  parameter Integer index_15 = 15 annotation(Dialog(tab="Indices"));
  parameter Integer index_16 = 16 annotation(Dialog(tab="Indices"));

  parameter Modelica.Units.SI.Length roughness=1.5e-5;

  parameter Modelica.Units.SI.Temperature T_cold_primary=80 + 273.15;
  parameter Modelica.Units.SI.Temperature T_hot_primary=101 + 273.15;

  parameter Modelica.Units.SI.MassFlowRate m_flow_primary=0.18;
  parameter Modelica.Units.SI.Pressure p_primary=1.0133e5;

  parameter Modelica.Units.SI.Area tank1_crossArea=0.25*Modelica.Constants.pi*
      0.0254*(12.39)^2;
  parameter Modelica.Units.SI.Area tank1_length=0.0254*(11.75);

  parameter Modelica.Units.SI.Temperature T_ambient=294.770;//was 298.15 294.770;
  parameter Modelica.Units.SI.Temperature T_ctah=80 + 273.15;

  Blocks.DataTable pipes(table=[10,2.01780,33.6888,0.0278638,0.0006097763,
        5.6,1.50E+05,1.50E+05,325,325,0.00304546,0.0508; 3,0.69868,
        59.4146,0.0278638,0.0006097763,2.4,1.49E+05,1.49E+05,325,325,
        0.0083058,0.0508; 5,1.08683,-58.6196,0.0278638,0.0006097763,1.9,
        1.47E+05,1.47E+05,325,325,0.0027686,0.0508; 2,0.37846,0.0000,
        0.0278638,0.0006097763,1.2,1.46E+05,1.46E+05,325,325,0.00304546,
        0.0508; 2,0.46783,-36.2463,0.0146701002,0.001049940481,1.6,
        1.44E+05,1.44E+05,325,325,0.0083058,0.0508; 8,1.67640,-90.0000,
        0.0146701002,0.001049940481,100,1.43E+05,1.43E+05,325,325,
        0.001905,0.0508; 2,0.35458,60.0866,0.0146701002,0.001049940481,
        1.7,1.41E+05,1.41E+05,325,325,0.0083058,0.0508; 8,1.71374,74.7368,
        0.0278638,0.0006097763,1.0,1.40E+05,1.40E+05,325,325,0.00290703,
        0.0508; 2,0.31750,0.0000,0.0278638,0.0006097763,1.7,1.38E+05,
        1.38E+05,325,325,0.00304546,0.0508; 4,0.76806,45.6060,0.0278638,
        0.0006097763,0.7,1.37E+05,1.37E+05,325,325,0.00332232,0.0508; 24,
        9.49452,1.8857,0.0118364,0.0001100345693,100,1.36E+05,1.36E+05,
        325,325,0.0008636,0.0508; 7,1.43176,-52.7679,0.0278638,
        0.0006097763,1.6,1.34E+05,1.34E+05,325,325,0.00332232,0.0508; 13,
        2.56108,-90.0000,0.0278638,0.0006097763,0.4,1.33E+05,1.33E+05,325,
        325,0.00304546,0.0508; 2,0.48083,-40.8421,0.0278638,0.0006097763,
        0.4,1.32E+05,1.32E+05,325,325,0.00290703,0.0508; 4,0.73790,0.0000,
        0.0278638,0.0006097763,1.4,1.30E+05,1.30E+05,325,325,0.00318389,
        0.0508; 6,1.15161,64.4937,0.0278638,0.0006097763,0.0,1.29E+05,
        1.29E+05,325,325,0.0027686,0.0508])
    "# of control volumes, length [m], vertical angle [deg], hydraulic diameter [m], flow area [m2],  form loss (999999 means do not use), p_a_start,p_b_start,T_a_start,T_b_start,Wall thick, Insulation thick"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (defaultComponentName="data",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Data_nureth;
