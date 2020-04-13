within TRANSFORM.Electrical.Batteries;
model SimpleBattery "Simple battery based on block controller logic"
  parameter TRANSFORM.Units.NonDim capacityFrac_start=1.0
    "Initial capacity as a fraction of usable capacity (capacity_max-capacity_min)"
    annotation (Dialog(tab="Initialization"));
  parameter SI.Conversions.NonSIunits.Energy_Wh capacity_max=100e6
    "Maximum storage capacity";
  parameter SI.Conversions.NonSIunits.Energy_Wh capacity_min=0
    "Minimum storage capacity";
  parameter SI.Power chargePower_max=Modelica.Constants.inf
    "Maximum charge power";
  parameter SI.Power chargePower_min=0 "Minimum charge power";
  parameter SI.Power dischargePower_max=Modelica.Constants.inf
    "Maximum discharge power";
  parameter SI.Power dischargePower_min=0 "Minimum discharge power";
  final parameter SI.Conversions.NonSIunits.Energy_Wh capacity_usable=
      capacity_max - capacity_min "Maximum usable capacity";
  final parameter SI.Energy E_start=SI.Conversions.from_Wh(capacity_usable)*
      capacityFrac_start + E_min "Start energy";
  final parameter SI.Energy E_max=SI.Conversions.from_Wh(capacity_max)
    "Maximum storable energy";
  final parameter SI.Energy E_min=SI.Conversions.from_Wh(capacity_min)
    "Minimum storable energy";
  SI.Energy E "Total energy stored";
  SI.Power W "Charge/discharge power";
  SI.Frequency f "Electrical frequency";
  Modelica.Blocks.Interfaces.RealInput W_setpoint(unit="W")
    "Demanded power input/output" annotation (Placement(transformation(extent={{
            -126,-18},{-90,18}}, rotation=0), iconTransformation(extent={{-126,-18},
            {-90,18}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold
    annotation (Placement(transformation(extent={{-66,-6},{-54,6}})));
  Modelica.Blocks.Logical.Switch W_limited(y(unit="W"))
    "Charge/discharge power after limiting operations"
    annotation (Placement(transformation(extent={{48,-6},{60,6}})));
  Modelica.Blocks.Logical.GreaterThreshold charge_min_greater(threshold=
        chargePower_min)
    annotation (Placement(transformation(extent={{-52,26},{-40,38}})));
  Modelica.Blocks.Logical.LessEqualThreshold charge_max_less(threshold=
        chargePower_max)
    annotation (Placement(transformation(extent={{-60,60},{-48,72}})));
  Modelica.Blocks.Logical.Switch charge_switch
    annotation (Placement(transformation(extent={{-6,26},{6,38}})));
  Modelica.Blocks.Sources.Constant chargeZero(k=0)
    annotation (Placement(transformation(extent={{-28,12},{-18,22}})));
  Modelica.Blocks.Logical.Switch charge_max_switch
    annotation (Placement(transformation(extent={{-36,60},{-24,72}})));
  Modelica.Blocks.Sources.Constant charge_max(k=chargePower_max)
    annotation (Placement(transformation(extent={{-60,44},{-50,54}})));
  Modelica.Blocks.Logical.GreaterThreshold discharge_min_greater(threshold=
        dischargePower_min)
    annotation (Placement(transformation(extent={{-40,-66},{-28,-54}})));
  Modelica.Blocks.Logical.Switch discharge_switch
    annotation (Placement(transformation(extent={{20,-46},{32,-34}})));
  Modelica.Blocks.Logical.LessEqualThreshold discharge_max_less(threshold=
        dischargePower_max)
    annotation (Placement(transformation(extent={{-40,-26},{-28,-14}})));
  Modelica.Blocks.Logical.Switch discharge_max_switch
    annotation (Placement(transformation(extent={{-16,-26},{-4,-14}})));
  Modelica.Blocks.Math.Abs abs
    annotation (Placement(transformation(extent={{-80,-40},{-68,-28}})));
  Modelica.Blocks.Sources.Constant dischargeZero(k=0)
    annotation (Placement(transformation(extent={{0,-60},{10,-50}})));
  Modelica.Blocks.Sources.Constant discharge_max(k=-dischargePower_max)
    annotation (Placement(transformation(extent={{-40,-44},{-30,-34}})));
public
  Modelica.Blocks.Continuous.LimIntegrator E_total(
    outMax=E_max,
    outMin=E_min,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=E_start) "total stored energy of battery"
    annotation (Placement(transformation(extent={{68,-6},{80,6}})));
  TRANSFORM.Electrical.Interfaces.ElectricalPowerPort_Flow port
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation
  E = E_total.y;
  der(E) = W;
  f = port.f;
  W=port.W;
  connect(W_setpoint, greaterThreshold.u)
    annotation (Line(points={{-108,0},{-88,0},{-67.2,0}}, color={0,0,127}));
  connect(greaterThreshold.y, W_limited.u2) annotation (Line(points={{-53.4,0},{
          -53.4,0},{46.8,0}}, color={255,0,255}));
  connect(charge_min_greater.y, charge_switch.u2) annotation (Line(points={{-39.4,
          32},{-39.4,32},{-7.2,32}}, color={255,0,255}));
  connect(chargeZero.y, charge_switch.u3) annotation (Line(points={{-17.5,17},{-14,
          17},{-14,27.2},{-7.2,27.2}}, color={0,0,127}));
  connect(charge_min_greater.u, greaterThreshold.u) annotation (Line(points={{-53.2,
          32},{-86,32},{-86,0},{-67.2,0}}, color={0,0,127}));
  connect(charge_max.y, charge_max_switch.u3) annotation (Line(points={{-49.5,49},
          {-42,49},{-42,61.2},{-37.2,61.2}}, color={0,0,127}));
  connect(charge_max_less.y, charge_max_switch.u2)
    annotation (Line(points={{-47.4,66},{-37.2,66}}, color={255,0,255}));
  connect(discharge_min_greater.y, discharge_switch.u2) annotation (Line(points=
         {{-27.4,-60},{-28,-60},{-6,-60},{-6,-40},{18.8,-40}}, color={255,0,255}));
  connect(discharge_max_less.y, discharge_max_switch.u2) annotation (Line(
        points={{-27.4,-20},{-27.4,-20},{-17.2,-20}}, color={255,0,255}));
  connect(abs.y, discharge_min_greater.u) annotation (Line(points={{-67.4,-34},{
          -60,-34},{-60,-60},{-41.2,-60}}, color={0,0,127}));
  connect(abs.u, greaterThreshold.u) annotation (Line(points={{-81.2,-34},{-86,-34},
          {-86,0},{-67.2,0}}, color={0,0,127}));
  connect(dischargeZero.y, discharge_switch.u3) annotation (Line(points={{10.5,-55},
          {12,-55},{12,-44.8},{18.8,-44.8}}, color={0,0,127}));
  connect(discharge_max.y, discharge_max_switch.u3) annotation (Line(points={{-29.5,
          -39},{-24,-39},{-24,-24.8},{-17.2,-24.8}}, color={0,0,127}));
  connect(discharge_max_less.u, discharge_min_greater.u) annotation (Line(
        points={{-41.2,-20},{-60,-20},{-60,-60},{-41.2,-60}}, color={0,0,127}));
  connect(discharge_max_switch.u1, greaterThreshold.u) annotation (Line(points={
          {-17.2,-15.2},{-24,-15.2},{-24,-10},{-86,-10},{-86,0},{-67.2,0}},
        color={0,0,127}));
  connect(discharge_max_switch.y, discharge_switch.u1) annotation (Line(points={
          {-3.4,-20},{12,-20},{12,-35.2},{18.8,-35.2}}, color={0,0,127}));
  connect(charge_max_switch.u1, greaterThreshold.u) annotation (Line(points={{-37.2,
          70.8},{-42,70.8},{-42,74},{-86,74},{-86,0},{-67.2,0}}, color={0,0,127}));
  connect(charge_max_less.u, greaterThreshold.u) annotation (Line(points={{-61.2,
          66},{-86,66},{-86,0},{-67.2,0}}, color={0,0,127}));
  connect(charge_max_switch.y, charge_switch.u1) annotation (Line(points={{-23.4,
          66},{-14,66},{-14,36.8},{-7.2,36.8}}, color={0,0,127}));
  connect(discharge_switch.y, W_limited.u3) annotation (Line(points={{32.6,-40},
          {40,-40},{40,-4.8},{46.8,-4.8}}, color={0,0,127}));
  connect(charge_switch.y, W_limited.u1) annotation (Line(points={{6.6,32},{40,32},
          {40,4.8},{46.8,4.8}}, color={0,0,127}));
  connect(W_limited.y, E_total.u)
    annotation (Line(points={{60.6,0},{66.8,0}}, color={0,0,127}));
  annotation (
    defaultComponentName="battery",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,52},{40,-50}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Sphere),
        Rectangle(
          extent={{80,20},{100,-20}},
          lineColor={0,0,127},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{40,52},{80,-50}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,128,0}),
        Line(points={{50,30},{70,30}}, color={0,0,127}),
        Line(points={{60,20},{60,40}}, color={0,0,127}),
        Line(points={{60,-40},{60,-20}}, color={0,0,127})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>A simple, logical battery which stores and discharges electricity.</p>
<p><br>The input signal (W_setpoint) drives the battery attempt to charge or discharge.</p>
<p>- W_setpoint = Negative | Mode = Discharge (port.W = negative)</p>
<p>- W_setpoint = Positive | Mode = Charge (port.W = positive)</p>
</html>"));
end SimpleBattery;
