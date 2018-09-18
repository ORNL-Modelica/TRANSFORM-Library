within TRANSFORM.Examples.CIET_Facility.Data;
model Data_Basic

  extends TRANSFORM.Icons.Record;

  parameter Integer index_13 = 1 annotation(Dialog(tab="Indices"));
  parameter Integer index_14 = 2 annotation(Dialog(tab="Indices"));
  parameter Integer index_14a = 3 annotation(Dialog(tab="Indices"));
  parameter Integer index_15 = 4 annotation(Dialog(tab="Indices"));
  parameter Integer index_16 = 5 annotation(Dialog(tab="Indices"));
  parameter Integer index_17 = 6 annotation(Dialog(tab="Indices"));
  parameter Integer index_18 = 7 annotation(Dialog(tab="Indices"));

  parameter Integer index_1b = 8 annotation(Dialog(tab="Indices"));
  parameter Integer index_1 = 9 annotation(Dialog(tab="Indices"));
  parameter Integer index_1a = 10 annotation(Dialog(tab="Indices"));
  parameter Integer index_2a = 11 annotation(Dialog(tab="Indices"));
  parameter Integer index_2 = 12 annotation(Dialog(tab="Indices"));
  parameter Integer index_3 = 13 annotation(Dialog(tab="Indices"));
  parameter Integer index_4 = 14 annotation(Dialog(tab="Indices"));
  parameter Integer index_5 = 15 annotation(Dialog(tab="Indices"));
  parameter Integer index_6 = 16 annotation(Dialog(tab="Indices"));
  parameter Integer index_6a = 17 annotation(Dialog(tab="Indices"));
  parameter Integer index_7a = 18 annotation(Dialog(tab="Indices"));
  parameter Integer index_7b = 19 annotation(Dialog(tab="Indices"));
  parameter Integer index_8a = 20 annotation(Dialog(tab="Indices"));
  parameter Integer index_8 = 21 annotation(Dialog(tab="Indices"));
  parameter Integer index_9 = 22 annotation(Dialog(tab="Indices"));
  parameter Integer index_10 = 23 annotation(Dialog(tab="Indices"));
  parameter Integer index_11 = 24 annotation(Dialog(tab="Indices"));
  parameter Integer index_12 = 25 annotation(Dialog(tab="Indices"));


  parameter SI.Length roughness = 1.5e-5;

  parameter SI.Temperature T_cold_primary = 80+273.15;
  parameter SI.Temperature T_hot_primary = 110+273.15;

  parameter SI.MassFlowRate m_flow_primary = 0.18;
  parameter SI.Pressure p_primary=1.0133e5;

  parameter SI.Area tank1_crossArea = 0.25*Modelica.Constants.pi*TRANSFORM.Units.Conversions.Functions.Distance_m.from_inch(12.39)^2;
  parameter SI.Area tank1_length = TRANSFORM.Units.Conversions.Functions.Distance_m.from_inch(11.75);
  Blocks.DataTable pipes(table=[12,1.2732,0,0.0279,0.000611,23.78,145000,140000,
        325,325,0.002768,0.0508; 6,0.6687,90,0.0279,0.000611,2.4,140000,135000,325,
        325,0.002768,0.0508; 1,0.36,90,0.0279,0.000611,99999,135000,135000,325,325,
        0.002768,0.0508; 3,0.35559,-49.369834,0.0279,0.000611,0.8,135000,140000,
        325,325,0.002768,0.0508; 6,0.64452,-90,0.0279,0.000611,1.9,140000,140000,
        325,325,0.002768,0.0508; 1,0.47308,0,0.0279,0.000611,0,140000,141000,325,
        325,0.002768,0.0508; 1,0.1778,-40.005201,0.0279,0.000611,5.15,141000,145000,
        325,325,0.002768,0.0508; 2,0.19686,90,0.0066,0.000364,3.95,145000,141000,
        325,325,0.001905,0.0508; 15,1.6383,90,0.0066,0.000364,0,141000,140000,325,
        325,0.001905,0; 1,0.0889,90,0.0066,0.000364,3.75,140000,138000,325,325,0.001905,
        0.0508; 1,0.33,90,0.0279,0.000611,99999,138000,139000,325,325,0.0010852,
        0.0508; 1,0.14943,90,0.0279,0.000611,1.8,139000,130000,325,325,0.0010852,
        0.0508; 12,1.28268,90,0.0279,0.000611,17.15,130000,120000,325,325,0.0010852,
        0.0508; 2,0.2413,49.743387,0.0279,0.000611,2.4,120000,110000,325,325,0.0010852,
        0.0508; 1,0.7493,0,0.0279,0.000611,0,110000,112000,325,325,0.0010852,0.0508;
        1,0.33,51.526384,0.0279,0.000611,99999,112000,115000,325,325,0.0010852,0.0508;
        1,0.1526,51.526384,0.0279,0.000611,5.05,115000,115000,325,325,0.0010852,
        0.0508; 3,0.33021,-90,0.0119,0.00133,99999,115000,120000,325,325,0.0016,
        0; 11,1.2342,0,0.0119,0.00133,3.9,120000,120000,325,325,0.0016,0; 1,0.22246,
        -90,0.0279,0.000611,3.75,120000,120000,325,325,0.002768,0.0381; 1,0.33,-90,
        0.0279,0.000611,99999,120000,130000,325,325,0.002768,0.0381; 7,0.7112,-42.73211,
        0.0279,0.000611,0.8,130000,140000,325,325,0.002768,0.0381; 22,2.45102,-90,
        0.0279,0.000611,0,140000,141000,325,325,0.002768,0.0381; 4,0.4826,-63.474648,
        0.0279,0.000611,13.23,141000,145000,325,325,0.002768,0.0381; 3,0.33339,0,
        0.0279,0.000611,0,145000,145000,325,325,0.002768,0.0508])
    "# of control volumes, length [m], vertical angle [deg], hydraulic diameter [m], flow area [m2],  form loss (999999 means do not use), p_a_start,p_b_start,T_a_start,T_b_start"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (defaultComponentName="data",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Data_Basic;
