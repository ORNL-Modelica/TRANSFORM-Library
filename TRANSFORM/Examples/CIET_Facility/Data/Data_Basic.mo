within TRANSFORM.Examples.CIET_Facility.Data;
model Data_Basic

  extends TRANSFORM.Icons.Record;

  parameter Integer index_1b = 1 annotation(Dialog(tab="Indices"));
  parameter Integer index_1 = 2 annotation(Dialog(tab="Indices"));
  parameter Integer index_1a = 3 annotation(Dialog(tab="Indices"));
  parameter Integer index_2a = 4 annotation(Dialog(tab="Indices"));
  parameter Integer index_2 = 5 annotation(Dialog(tab="Indices"));
  parameter Integer index_3 = 6 annotation(Dialog(tab="Indices"));
  parameter Integer index_4 = 7 annotation(Dialog(tab="Indices"));
  parameter Integer index_5 = 8 annotation(Dialog(tab="Indices"));
  parameter Integer index_6a = 9 annotation(Dialog(tab="Indices"));
  parameter Integer index_6 = 10 annotation(Dialog(tab="Indices"));
  parameter Integer index_7a = 11 annotation(Dialog(tab="Indices"));
  parameter Integer index_7b = 12 annotation(Dialog(tab="Indices"));
  parameter Integer index_8a = 13 annotation(Dialog(tab="Indices"));
  parameter Integer index_8 = 14 annotation(Dialog(tab="Indices"));
  parameter Integer index_9 = 15 annotation(Dialog(tab="Indices"));
  parameter Integer index_10 = 16 annotation(Dialog(tab="Indices"));
  parameter Integer index_11 = 17 annotation(Dialog(tab="Indices"));
  parameter Integer index_12 = 18 annotation(Dialog(tab="Indices"));
  parameter Integer index_13 = 19 annotation(Dialog(tab="Indices"));
  parameter Integer index_14 = 20 annotation(Dialog(tab="Indices"));
  parameter Integer index_14a = 21 annotation(Dialog(tab="Indices"));
  parameter Integer index_15 = 22 annotation(Dialog(tab="Indices"));
  parameter Integer index_16 = 23 annotation(Dialog(tab="Indices"));
  parameter Integer index_17 = 24 annotation(Dialog(tab="Indices"));
  parameter Integer index_19 = 25 annotation(Dialog(tab="Indices"));
  parameter Integer index_20 = 26 annotation(Dialog(tab="Indices"));
  parameter Integer index_21 = 27 annotation(Dialog(tab="Indices"));
  parameter Integer index_21a = 28 annotation(Dialog(tab="Indices"));
  parameter Integer index_22 = 29 annotation(Dialog(tab="Indices"));
  parameter Integer index_23a = 30 annotation(Dialog(tab="Indices"));
  parameter Integer index_23 = 31 annotation(Dialog(tab="Indices"));
  parameter Integer index_24 = 32 annotation(Dialog(tab="Indices"));
  parameter Integer index_25a = 33 annotation(Dialog(tab="Indices"));
  parameter Integer index_25 = 34 annotation(Dialog(tab="Indices"));
  parameter Integer index_26 = 35 annotation(Dialog(tab="Indices"));
  parameter Integer index_18 = 36 annotation(Dialog(tab="Indices"));
  parameter Integer index_30a = 37 annotation(Dialog(tab="Indices"));
  parameter Integer index_30 = 38 annotation(Dialog(tab="Indices"));
  parameter Integer index_30b = 39 annotation(Dialog(tab="Indices"));
  parameter Integer index_31a = 40 annotation(Dialog(tab="Indices"));
  parameter Integer index_31 = 41 annotation(Dialog(tab="Indices"));
  parameter Integer index_32 = 42 annotation(Dialog(tab="Indices"));
  parameter Integer index_33 = 43 annotation(Dialog(tab="Indices"));
  parameter Integer index_34 = 44 annotation(Dialog(tab="Indices"));
  parameter Integer index_35a = 45 annotation(Dialog(tab="Indices"));
  parameter Integer index_35b = 46 annotation(Dialog(tab="Indices"));
  parameter Integer index_36a = 47 annotation(Dialog(tab="Indices"));
  parameter Integer index_36 = 48 annotation(Dialog(tab="Indices"));
  parameter Integer index_37 = 49 annotation(Dialog(tab="Indices"));
  parameter Integer index_37a = 50 annotation(Dialog(tab="Indices"));
  parameter Integer index_38 = 51 annotation(Dialog(tab="Indices"));
  parameter Integer index_39 = 52 annotation(Dialog(tab="Indices"));

  parameter SI.Length roughness = 1.5e-5;

  parameter SI.Temperature T_cold_primary = 80+273.15;
  parameter SI.Temperature T_hot_primary = 110+273.15;

  parameter SI.MassFlowRate m_flow_primary = 0.18;
  parameter SI.Pressure p_primary=1.0133e5;

  parameter Real[:,:] branches=[2,0.19685,90,0.0066,0.000364,3.95; 15,1.6383,
        90,0.0066,0.000364,0; 1,0.0889,90,0.0066,0.000364,3.75; 1,0.149425,90,0.0279,
        0.000611,1.8; 1,0.33,90,0.0279,0.000611,999999; 12,1.2827,90,0.0279,0.000611,
        3.15; 2,0.2413,49.743387,0.0279,0.000611,2.4; 1,0.7493,0,0.0279,0.000611,
        0; 1,0.1526,51.526384,0.0279,0.000611,5.05; 1,0.33,51.526384,0.0279,0.000611,
        999999; 3,0.3302,-90,0.0119,0.00133,3.9; 11,1.2342,0,0.0119,0.00133,999999;
        2,0.22245,-90,0.0279,0.000611,3.75; 1,0.33,-90,0.0279,0.000611,999999; 7,
        0.7112,-42.73211,0.0279,0.000611,0.8; 22,2.4511,-90,0.0279,0.000611,0.45;
        4,0.4826,-63.47465,0.0279,0.000611,2.4; 3,0.333375,0,0.0279,0.000611,21.65;
        12,1.273175,0,0.0279,0.000611,12.95; 6,0.6687,90,0.0279,0.000611,2.4; 1,
        0.36,90,0.0279,0.000611,999999; 3,0.3556,-49.36983,0.0279,0.000611,0.8;
        6,0.644525,-90,0.0279,0.000611,1.9; 1,0.473075,0,0.0279,0.000611,0; 2,0.219075,
        -31.44898,0.0279,0.000611,7.5; 3,0.33655,0,0.0279,0.000611,0; 5,0.487725,
        90,0.0279,0.000611,4.4; 1,0.36,90,0.0279,0.000611,999999; 6,0.69215,90,0.0279,
        0.000611,9.95; 1,0.0891,90,0.0279,0.000611,1.35; 1,0.33,90,0.0279,0.000611,
        999999; 11,1.18745,90,0.00565,0.000943,23.9; 2,0.22245,90,0.0279,0.000611,
        1.35; 1,0.33,90,0.0279,0.000611,999999; 2,0.2159,52.571994,0.0279,0.000611,
        1.75; 1,0.1778,-40.0052,0.0279,0.000611,5.15; 1,0.111125,90,0.00693,0.000718,
        0; 11,1.18745,90,0.00693,0.000718,3.3; 2,0.18415,90,0.00693,0.000718,0;
        1,0.143075,90,0.0279,0.000611,1.35; 1,0.33,90,0.0279,0.000611,999999; 2,
        0.238125,54.422897,0.0279,0.000611,0.8; 28,3.0099,90,0.0279,0.000611,2.75;
        5,0.55245,0,0.0279,0.000611,4.25; 11,1.148475,0,0.0119,0.00133,999999; 4,
        0.415925,-90,0.0119,0.00133,5.8; 2,0.2034,-58.99728,0.0279,0.000611,3.75;
        1,0.33,-58.99728,0.0279,0.000611,999999; 16,1.7736,-90,0.0279,0.000611,0;
        1,0.36,-90,0.0279,0.000611,999999; 3,0.33655,-52.41533,0.0279,0.000611,0.8;
        18,1.91135,-80.64882,0.0279,0.000611,2.65] "# of control volumes, length [m], vertical angle [deg], hydraulic diameter [m], flow area [m2],  form loss (999999 means do not use)";

  parameter SI.Area tank1_crossArea = 0.25*Modelica.Constants.pi*TRANSFORM.Units.Conversions.Functions.Distance_m.from_inch(12.39)^2;
  parameter SI.Area tank1_length = TRANSFORM.Units.Conversions.Functions.Distance_m.from_inch(11.75);
  annotation (defaultComponentName="data",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Data_Basic;
