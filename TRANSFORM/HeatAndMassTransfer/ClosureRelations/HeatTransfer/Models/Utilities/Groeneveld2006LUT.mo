within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.Utilities;
model Groeneveld2006LUT
  extends Modelica.Blocks.Interfaces.SO;
  parameter Boolean[8] use_Ks=fill(false, 8)
    "=true to turn on correction factor. See info tab for details"
    annotation (Evaluate=true);
  input SI.Length D_hyd=1.0
    "Hydraulic diameter of subchannel. Used in K = 1,3,4,7" annotation (Dialog(
        group="Inputs", enable=if use_Ks[1] or useKs[3] or useKs[4] or useKs[7]
           then true else false));
  input SI.Length D_htr=1.0 "Heater element diameter. Used in K = 2"
    annotation (Dialog(group="Inputs", enable=use_Ks[2]));
  input SI.Length Pitch=1.0
    "Center distance between heating elements. Used in K = 2"
    annotation (Dialog(group="Inputs", enable=use_Ks[2]));
  input SIadd.NonDim K_g=1.0
    "Pressure loss coefficient of spacer. Used in K = 3"
    annotation (Dialog(group="Inputs", enable=use_Ks[3]));
  input SI.Length L_sp=1.0
    "Distance between mid-plane of spacers. Used in K = 3"
    annotation (Dialog(group="Inputs", enable=use_Ks[3]));
  input SI.Length L_htd=1.0 "Heated length. Used in K = 4"
    annotation (Dialog(group="Inputs"));
  input SI.Density rho_lsat=1.0 "Fluid saturation density. Used in K = 4,7,8"
    annotation (Dialog(group="Inputs", enable=if use_Ks[4] or useKs[7] or useKs[
          8] then true else false));
  input SI.Density rho_vsat=1.0 "Vapor saturation density. Used in K = 4,7,8"
    annotation (Dialog(group="Inputs", enable=if use_Ks[4] or useKs[7] or useKs[
          8] then true else false));
  input SI.HeatFlux q_BLA=1.0 "Boiling length average heat flux. Used in K = 5"
    annotation (Dialog(group="Inputs", enable=use_Ks[5]));
  input SI.HeatFlux q_local=1.0 "Local heat flux. Used in K = 5"
    annotation (Dialog(group="Inputs", enable=use_Ks[5]));
  input SI.HeatFlux q_rc_avg=1.0
    "Average R/C flux at a height z. Used in K = 6"
    annotation (Dialog(group="Inputs", enable=use_Ks[6]));
  input SI.HeatFlux q_rc_max=1.0
    "Maximum R/C flux at a height z. Used in K = 6"
    annotation (Dialog(group="Inputs", enable=use_Ks[6]));
  input SIadd.NonDim f_L=1.0 "Friction factor of the channel. Used in K = 7"
    annotation (Dialog(group="Inputs", enable=use_Ks[7]));
  input SI.Acceleration g_n=Modelica.Constants.g_n
    "Gravity coefficient. Used in K = 7"
    annotation (Dialog(group="Inputs", enable=use_Ks[7]));
  // Set by input connectors
  //   input SIadd.NonDim x_abs=noEvent(max(0.0, min(1.0, x_th))) "Absolute quality. Used in table interpolation and  K = 2,4,5,6,7,8" annotation (
  //       Dialog(group="Inputs", enable=if use_Ks[2] or useKs[4] or useKs[5] or
  //           useKs[6] or useKs[7] or useKs[8] then true else false));
  //   input SIadd.MassFlux G=1.0 "Mass flux. Used in table interpolation and K = 3,7,8" annotation (Dialog(group="Inputs",
  //         enable=if use_Ks[3] or useKs[7] or useKs[8] then true else false));
  Modelica.Blocks.Interfaces.RealInput P(unit="Pa")
    "Pressure. Used in table interpolation" annotation (Placement(
        transformation(extent={{-140,20},{-100,60}}), iconTransformation(extent=
           {{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput x_th(unit="1")
    "Thermodynamic quality. Used in table interpolation and in calculation of x_abs for K = 2,4,5,6,7,8"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput G(unit="kg/(m2.s)")
    "Mass flux. Used in table interpolation and K = 3,7,8" annotation (
      Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  SIadd.NonDim x_abs=noEvent(max(0.0, min(1.0, x_th)))
    "Absolute quality. Used in table interpolation and K = 2,4,5,6,7,8";
  SDF.NDTable q(
    nin=3,
    readFromFile=true,
    dataUnit="W/m2",
    scaleUnits={"kg/(m2.s)","1","Pa"},
    interpMethod=SDF.Types.InterpolationMethod.Akima,
    extrapMethod=SDF.Types.ExtrapolationMethod.Linear,
    dataset="/q",
    filename=Modelica.Utilities.Files.loadResource("modelica://TRANSFORM/Resources/data/chf/2006LUT.sdf"))
    "Outputs predicted CHF heat flux [W/m2]"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Real[8] Ks "Correction factors";
  Modelica.Blocks.Math.Abs absG
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
equation
  Ks[1] = if not use_Ks[1] then 1.0 else
    Internal.GroeneveldCorrectionFactors.K_1(D_hyd);
  Ks[2] = if not use_Ks[2] then 1.0 else
    Internal.GroeneveldCorrectionFactors.K_2(
    D_htr,
    Pitch,
    x_abs);
  Ks[3] = if not use_Ks[3] then 1.0 else
    Internal.GroeneveldCorrectionFactors.K_3(
    D_hyd,
    G,
    K_g,
    L_sp);
  Ks[4] = if use_Ks[3] or not use_Ks[4] then 1.0 else
    Internal.GroeneveldCorrectionFactors.K_4(
    D_hyd,
    L_htd,
    rho_lsat,
    rho_vsat,
    x_abs);
  Ks[5] = if not use_Ks[5] then 1.0 else
    Internal.GroeneveldCorrectionFactors.K_5(
    q_BLA,
    q_local,
    x_abs);
  Ks[6] = if not use_Ks[6] then 1.0 else
    Internal.GroeneveldCorrectionFactors.K_6(
    q_rc_avg,
    q_rc_max,
    x_abs);
  Ks[7] = if not use_Ks[7] then 1.0 else
    Internal.GroeneveldCorrectionFactors.K_7(
    D_hyd,
    f_L,
    G,
    rho_lsat,
    rho_vsat,
    x_abs,
    g_n);
  Ks[8] = if not use_Ks[8] then 1.0 else
    Internal.GroeneveldCorrectionFactors.K_8(
    G,
    rho_lsat,
    rho_vsat,
    x_abs);
  y = q.y*Ks[1]*Ks[2]*Ks[3]*Ks[4]*Ks[5]*Ks[6]*Ks[7]*Ks[8];
  connect(x_th, q.u[2]) annotation (Line(points={{-120,0},{-12,0}}, color={0,0,127}));
  connect(P, q.u[3]) annotation (Line(points={{-120,40},{-30,40},{-30,1.33333},{
          -12,1.33333}}, color={0,0,127}));
  connect(G, absG.u)
    annotation (Line(points={{-120,-40},{-62,-40}}, color={0,0,127}));
  connect(absG.y, q.u[1]) annotation (Line(points={{-39,-40},{-30,-40},{-30,
          -1.33333},{-12,-1.33333}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Bitmap(extent={{-98,-98},{98,98}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/CHF.jpg"),
        Text(
          extent={{34,-70},{112,-100}},
          lineColor={0,0,0},
          textString="*Ks"),
        Text(
          extent={{-96,54},{-74,26}},
          lineColor={0,0,0},
          textString="P"),
        Text(
          extent={{-96,14},{-74,-14}},
          lineColor={0,0,0},
          textString="x"),
        Text(
          extent={{-96,-26},{-74,-54}},
          lineColor={0,0,0},
          textString="G")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Prediction of the critical heat flux using the 2006 Groeneveld Look-Up Table as presented in 2006 CHF Look-Up Table, Nuclear Engineering and Design 237, pp. 190-1922.</p>
<p><u><span style=\"font-family: Courier New;\">Correction Factor Definitions</span></u></p>
<p><span style=\"font-family: Courier New;\">K1 &quot;Diameter Effect Factor&quot;</span></p>
<p><span style=\"font-family: Courier New;\">K2 &quot;Bundle Geometry Factor&quot;</span></p>
<p><span style=\"font-family: Courier New;\">K3 &quot;Mid-Plane Spacer Factor&quot;</span></p>
<p><span style=\"font-family: Courier New;\">K4 &quot;Heated Length Factor&quot;</span></p>
<p><span style=\"font-family: Courier New;\">K5 &quot;Axial Flux Distribution Factor&quot;</span></p>
<p><span style=\"font-family: Courier New;\">K6 &quot;Radial/Circumferential (R/C) Flux Distribution Factor&quot;</span></p>
<p><span style=\"font-family: Courier New;\">K7&nbsp;&quot;Flow-Orientation&nbsp;Factor&quot;</span></p>
<p><span style=\"font-family: Courier New;\">K8 &quot;Vertical Low-Flow Factor - A minus sign refers to downward flow&quot;</span></p>
<p><br><span style=\"font-family: Courier New;\">Note: If K(3) is used then K(4) = 1. This is because K(3) already includes the heated length effect. This condition is handled in the code.</span></p>
</html>"));
end Groeneveld2006LUT;
