within TRANSFORM.Fluid.ClosureRelations.Geometry;
package NPS
  partial model PartialNPSrecord
    parameter Modelica.SIunits.Length d_o "Outside diameter";
    parameter Modelica.SIunits.Length th_wall "Wall thickness";
    final parameter Modelica.SIunits.Length dimension = d_o-2*th_wall "Inside diameter";
    final parameter Modelica.SIunits.Length perimeter = Modelica.Constants.pi*dimension "Wetted perimeter";
    final parameter Modelica.SIunits.Area crossArea = Modelica.Constants.pi/4*dimension^2 "Cross area";
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end PartialNPSrecord;

  model NPS_6 "one_eighth"
    extends PartialNPSrecord(
             d_o = 0.01029,
             final th_wall = ths[schedule]);

    parameter Integer schedule = 1 "Pipe schedule" annotation(choices(choice=1 "5s",choice=2 "10s/20",choice=3 "30",choice=4 "40s/40/STD",choice=5 "80s/80/XS"));
    constant Real ths[:] = {0.000889,0.001245,0.001448,0.001727,0.00241};
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end NPS_6;

  model NPS_8 "one_quarter"
    extends PartialNPSrecord(
             d_o = 0.01372,
             final th_wall = ths[schedule]);

    parameter Integer schedule = 1 "Pipe schedule" annotation(choices(choice=1 "5s",choice=2 "10s/20",choice=3 "30",choice=4 "40s/40/STD",choice=5 "80s/80/XS"));
    constant Real ths[:] = {0.001245,0.001651,0.001854,0.002235,0.003023};
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end NPS_8;

  model NPS_10 "three_eighths"
    extends PartialNPSrecord(
             d_o = 0.01715,
             final th_wall = ths[schedule]);

    parameter Integer schedule = 1 "Pipe schedule" annotation(choices(choice=1 "5s",choice=2 "10s/20",choice=3 "30",choice=4 "40s/40/STD",choice=5 "80s/80/XS"));
    constant Real ths[:] = {0.001245,0.001651,0.001854,0.002311,0.003200};
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end NPS_10;

  model NPS_15 "one_half"
    extends PartialNPSrecord(
             d_o = 0.02134,
             final th_wall= ths[schedule]);

    parameter Integer schedule = 1 "Pipe schedule" annotation(choices(choice=1 "5s",choice=2 "10s/20",choice=3 "30",choice=4 "40s/40/STD",choice=5 "80s/80/XS",choice=6 "160",choice=7 "XXS"));
    constant Real ths[:] = {0.001651,0.002108,0.002413,0.002769,0.003734,0.004775,0.007468};
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end NPS_15;

  model NPS_20 "three_quarters"
    extends PartialNPSrecord(
             d_o = 0.02667,
             final th_wall= ths[schedule]);

    parameter Integer schedule = 1 "Pipe schedule" annotation(choices(choice=1 "5s",choice=2 "10s/20",choice=3 "30",choice=4 "40s/40/STD",choice=5 "80s/80/XS",choice=6 "160",choice=7 "XXS"));
    constant Real ths[:] = {0.001651,0.002108,0.002413,0.002870,0.003912,0.005563,0.007823};
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end NPS_20;

  model NPS_25 "one"
    extends PartialNPSrecord(
             d_o = 0.03340,
             final th_wall= ths[schedule]);

    parameter Integer schedule = 1 "Pipe schedule" annotation(choices(choice=1 "5s",choice=2 "10s/20",choice=3 "30",choice=4 "40s/40/STD",choice=5 "80s/80/XS",choice=6 "160",choice=7 "XXS"));
    constant Real ths[:] = {0.001651,0.002769,0.002896,0.003378,0.004547,0.006350,0.009093};
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end NPS_25;

  model NPS_32 "one_and_one_quarter"
    extends PartialNPSrecord(
             d_o = 0.04216,
             final th_wall= ths[schedule]);

    parameter Integer schedule = 1 "Pipe schedule" annotation(choices(choice=1 "5s",choice=2 "10s/20",choice=3 "30",choice=4 "40s/40/STD",choice=5 "80s/80/XS",choice=6 "160",choice=7 "XXS"));
    constant Real ths[:] = {0.001651,0.002769,0.002972,0.003556,0.004851,0.006350,0.009703};
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end NPS_32;

  model NPS_40 "one_and_one_half"
    extends PartialNPSrecord(
             d_o = 0.04826,
             final th_wall= ths[schedule]);

    parameter Integer schedule = 1 "Pipe schedule" annotation(choices(choice=1 "5s",choice=2 "10s/20",choice=3 "30",choice=4 "40s/40/STD",choice=5 "80s/80/XS",choice=6 "160",choice=7 "XXS"));
    constant Real ths[:] = {0.001651,0.002769,0.003175,0.003683,0.005080,0.007137,0.010160};
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end NPS_40;

  model NPS_50 "two"
    extends PartialNPSrecord(
             d_o = 0.06033,
             final th_wall= ths[schedule]);

    parameter Integer schedule = 1 "Pipe schedule" annotation(choices(choice=1 "5s",choice=2 "10s/20",choice=3 "30",choice=4 "40s/40/STD",choice=5 "80s/80/XS",choice=6 "160",choice=7 "XXS"));
    constant Real ths[:] = {0.001651,0.002769,0.003175,0.003912,0.005537,0.008738,0.011074};
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end NPS_50;

  model NPS_65 "two_and_one_half"
    extends PartialNPSrecord(
             d_o = 0.07303,
             final th_wall= ths[schedule]);

    parameter Integer schedule = 1 "Pipe schedule" annotation(choices(choice=1 "5s",choice=2 "10s/20",choice=3 "30",choice=4 "40s/40/STD",choice=5 "80s/80/XS",choice=6 "120",choice=7 "160",choice=8 "XXS"));
    constant Real ths[:] = {0.002108,0.003048,0.004775,0.005156,0.007010,0.007620,0.009525,0.014021};
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end NPS_65;

  model NPS_80 "three"
    extends PartialNPSrecord(
             d_o = 0.08890,
             final th_wall= ths[schedule]);

    parameter Integer schedule = 1 "Pipe schedule" annotation(choices(choice=1 "5s",choice=2 "10s/20",choice=3 "30",choice=4 "40s/40/STD",choice=5 "80s/80/XS",choice=6 "120",choice=7 "160",choice=8 "XXS"));
    constant Real ths[:] = {0.002108,0.003048,0.004775,0.005486,0.007620,0.008890,0.011125,0.015240};
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end NPS_80;

  model NPS_90 "three_and_one_half"
    extends PartialNPSrecord(
             d_o = 0.10160,
             final th_wall= ths[schedule]);

    parameter Integer schedule = 1 "Pipe schedule" annotation(choices(choice=1 "5s",choice=2 "10s/20",choice=3 "30",choice=4 "40s/40/STD",choice=5 "80s/80/XS",choice=6 "XXS"));
    constant Real ths[:] = {0.002108,0.003048,0.004775,0.005740,0.008077,0.016154};
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end NPS_90;

  model NPS_100 "four"
    extends PartialNPSrecord(
             d_o = 0.11430,
             final th_wall= ths[schedule]);

    parameter Integer schedule = 1 "Pipe schedule" annotation(choices(choice=1 "5s",choice=2 "10s/10",choice=3 "30",choice=4 "40s/40/STD",choice=5 "80s/80/XS",choice=6 "120",choice=7 "160",choice=8 "XXS"));
    constant Real ths[:] = {0.002108,0.003048,0.004775,0.006020,0.008560,0.011100,0.013487,0.017120};
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end NPS_100;

  model NPS_115 "four"
    extends PartialNPSrecord(
             d_o = 0.12700,
             final th_wall= ths[schedule]);

    parameter Integer schedule = 1 "Pipe schedule" annotation(choices(choice=1 "40s/40/STD",choice=2 "80s/80/XS",choice=3 "XXS"));
    constant Real ths[:] = {0.006274,0.009017,0.018034};
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end NPS_115;

  model NPS_125 "five"
    extends PartialNPSrecord(
             d_o = 0.14130,
             final th_wall= ths[schedule]);

    parameter Integer schedule = 1 "Pipe schedule" annotation(choices(choice=1 "5s",choice=2 "10s/10",choice=3 "40s/40/STD",choice=4 "80s/80/XS",choice=5 "120",choice=6 "160",choice=7 "XXS"));
    constant Real ths[:] = {0.002769,0.003404,0.006553,0.009525,0.012700,0.015875,0.019050};
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end NPS_125;

  model NPS_150 "six"
    extends PartialNPSrecord(
             d_o = 0.16828,
             final th_wall= ths[schedule]);

    parameter Integer schedule = 1 "Pipe schedule" annotation(choices(choice=1 "5s",choice=2 "10s/10",choice=3 "40s/40/STD",choice=4 "80s/80/XS",choice=5 "120",choice=6 "160",choice=7 "XXS"));
    constant Real ths[:] = {0.002769,0.003404,0.007112,0.010973,0.014275,0.018263,0.021946};
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end NPS_150;

  model NPS_175 "seven"
    extends PartialNPSrecord(
             d_o = 0.19368,
             final th_wall= ths[schedule]);

    parameter Integer schedule = 1 "Pipe schedule" annotation(choices(choice=1 "40s/40/STD",choice=2 "80s/80/XS",choice=3 "XXS"));
    constant Real ths[:] = {0.007645,0.012700,0.022225};
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end NPS_175;

  model NPS_200 "eight"
    extends PartialNPSrecord(
             d_o = 0.21908,
             final th_wall= ths[schedule]);

    parameter Integer schedule = 1 "Pipe schedule" annotation(choices(choice=1 "5s",choice=2 "10s/10",choice=3 "20",choice=4 "30",choice=5 "40s/40/STD",choice=6 "60",choice=7 "80s/80/XS",choice=8 "100",choice=9 "120",choice=10 "140",choice=11 "160",choice=12 "XXS"));
    constant Real ths[:] = {0.002769,0.003759,0.006350,0.00736,0.008179,0.010312,0.012700,0.015062,0.018263,0.020625,0.023012,0.022225};
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end NPS_200;

  model NPS_225 "nine"
    extends PartialNPSrecord(
             d_o = 0.24448,
             final th_wall= ths[schedule]);

    parameter Integer schedule = 1 "Pipe schedule" annotation(choices(choice=1 "40s/40/STD",choice=2 "80s/80/XS"));
    constant Real ths[:] = {0.008687,0.012700};
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end NPS_225;

  model NPS_250 "ten"
    extends PartialNPSrecord(
             d_o = 0.27305,
             final th_wall= ths[schedule]);

    parameter Integer schedule = 1 "Pipe schedule" annotation(choices(choice=1 "5s",choice=2 "10",choice=3 "20",choice=4 "30",choice=5 "40/STD"));
    constant Real ths[:] = {0.003404,0.004191,0.006350,0.007798,0.009271};
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end NPS_250;

  model NPS_300 "twelve"
    extends PartialNPSrecord(
             d_o = 0.32385,
             final th_wall= ths[schedule]);

    parameter Integer schedule = 1 "Pipe schedule" annotation(choices(choice=1 "5s",choice=2 "10",choice=3 "20",choice=4 "30",choice=5 "40/STD"));
    constant Real ths[:] = {0.003962,0.004572,0.006350,0.008382,0.009525};
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end NPS_300;
end NPS;
