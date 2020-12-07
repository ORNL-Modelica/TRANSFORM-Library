within TRANSFORM.HeatAndMassTransfer.Examples.ExamplesFrom_NellisAndKlein;
model SensorInOscillatingTemperatureEnvironment
  "Example 3.1-2 Sensor in an oscillating temperature environment pp. 310-316"
  extends Icons.Example;
  Modelica.Blocks.Sources.Constant D_s(each k=0.001) "sensor diameter"
    annotation (Placement(transformation(extent={{-100,84},{-92,92}})));
  Modelica.Blocks.Sources.Constant alpha(each k=500)
                                                    "heat transfer coefficient"
    annotation (Placement(transformation(extent={{-54,70},{-46,78}})));
  Modelica.Blocks.Sources.Constant th_c(each k=100e-6) "coating thickness"
    annotation (Placement(transformation(extent={{-100,70},{-92,78}})));
  Modelica.Blocks.Sources.RealExpression V_s(y=Modelica.Constants.pi*D_s.y^3/6)
    "volume" annotation (Placement(transformation(extent={{-26,78},{-6,98}})));
  Modelica.Blocks.Sources.RealExpression A_s(y=Modelica.Constants.pi*D_s.y^2)
    "sensor surface area for heat transfer"
    annotation (Placement(transformation(extent={{-26,62},{-6,82}})));
  Modelica.Blocks.Sources.Constant lambda_s(each k=50)
    "sensor thermal conductivity"
    annotation (Placement(transformation(extent={{-68,84},{-60,92}})));
  Modelica.Blocks.Sources.Constant d_s(each k=16000) "sensor density"
    annotation (Placement(transformation(extent={{-68,70},{-60,78}})));
  Modelica.Blocks.Sources.Constant cp_s(each k=150) "sensor heat capacity"
    annotation (Placement(transformation(extent={{-40,84},{-32,92}})));
  Utilities.Visualizers.displayReal display_tau_lumped(use_port=true)
    annotation (Placement(transformation(extent={{-2,-42},{18,-22}})));
  Utilities.Visualizers.displayReal display_biot(use_port=true, precision=4)
    annotation (Placement(transformation(extent={{-2,-20},{18,0}})));
  Modelica.Blocks.Sources.Constant Tini(each k=
        Units.Conversions.Functions.Temperature_K.from_degC(260))
    "initial plastic disk temperature"
    annotation (Placement(transformation(extent={{-84,84},{-76,92}})));
  Modelica.Blocks.Sources.Sine Tinf(
    f=0.5,
    offset=Units.Conversions.Functions.Temperature_K.from_degC(320),
    amplitude=50) "ambient temperature"
    annotation (Placement(transformation(extent={{-84,70},{-76,78}})));
  Modelica.Blocks.Sources.Constant lambda_c(each k=0.2)
    "coating thermal conductivity"
    annotation (Placement(transformation(extent={{-54,84},{-46,92}})));
  Resistances.Heat.Convection Rconv(alpha=alpha.y, surfaceArea=A_c.y)
    annotation (Placement(transformation(extent={{6,10},{26,30}})));
  Resistances.Heat.Sphere Rcond_coating(
    lambda=lambda_c.y,
    r_in=0.5*D_s.y,
    r_out=0.5*D_s.y + th_c.y)
    annotation (Placement(transformation(extent={{-26,10},{-6,30}})));
  BoundaryConditions.Heat.Temperature fluid(use_port=true) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={50,20})));
  Utilities.CharacteristicNumbers.Models.LumpedHeatTimeConstant tau_lumped(
    V=V_s.y,
    R=Rcond_coating.R + Rconv.R,
    d=d_s.y,
    cp=cp_s.y)
    annotation (Placement(transformation(extent={{-32,-42},{-12,-22}})));
  Utilities.CharacteristicNumbers.Models.BiotNumber_general biotNumber(
    R_conv=Rcond_coating.R + Rconv.R,
    L=V_s.y/A_s.y,
    lambda=lambda_s.y,
    surfaceArea=A_s.y)
    annotation (Placement(transformation(extent={{-32,-20},{-12,0}})));
  Modelica.Blocks.Sources.RealExpression A_c(y=4*Modelica.Constants.pi*(0.5*D_s.y
         + th_c.y)^2) "coating surface area for heat transfer"
    annotation (Placement(transformation(extent={{4,62},{24,82}})));
  Volumes.UnitVolume sensor(
    V=V_s.y,
    d=d_s.y,
    cp=cp_s.y,
    T_start=Tini.k,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-50,20})));
  Modelica.Blocks.Sources.RealExpression T_boundary(y=Tinf.y)
    annotation (Placement(transformation(extent={{80,10},{60,30}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(n=1, x={sensor.T})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(Rcond_coating.port_b, Rconv.port_a)
    annotation (Line(points={{-9,20},{-9,20},{9,20}},     color={191,0,0}));
  connect(tau_lumped.y, display_tau_lumped.u)
    annotation (Line(points={{-11,-32},{-3.5,-32}}, color={0,0,127}));
  connect(biotNumber.y, display_biot.u)
    annotation (Line(points={{-11,-10},{-3.5,-10}}, color={0,0,127}));
  connect(sensor.port, Rcond_coating.port_a)
    annotation (Line(points={{-40,20},{-40,20},{-23,20}}, color={191,0,0}));
  connect(Rconv.port_b, fluid.port)
    annotation (Line(points={{23,20},{23,20},{40,20}}, color={191,0,0}));
  connect(fluid.T_ext, T_boundary.y)
    annotation (Line(points={{54,20},{59,20},{59,20}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=10, __Dymola_NumberOfIntervals=100));
end SensorInOscillatingTemperatureEnvironment;
