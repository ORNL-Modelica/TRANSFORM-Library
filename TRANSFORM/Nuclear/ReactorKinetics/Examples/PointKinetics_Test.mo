within TRANSFORM.Nuclear.ReactorKinetics.Examples;
model PointKinetics_Test
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Sine Teff_Fuel(
    amplitude=5,
    offset=reactorKinetics.Teffref_fuel,
    freqHz=0.002,
    startTime=1e4)
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Modelica.Blocks.Sources.Constant Other_Reactivity(k=0)
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Modelica.Blocks.Sources.Sine Teff_Coolant(
    amplitude=10,
    freqHz=0.01,
    startTime=1e4,
    offset=reactorKinetics.Teffref_coolant,
    phase=0.5235987755983)
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Modelica.Blocks.Sources.Constant ControlRod_Reactivity(k=0.0025)
    annotation (Placement(transformation(extent={{-100,72},{-80,92}})));
  Modelica.Blocks.Sources.Constant S_external(k=0)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  PointKinetics reactorKinetics(
    nI=1,
    beta_i={0.0075},
    lambda_i={0.08},
    Q_nominal=1e9,
    Lambda=1e-3)
    annotation (Placement(transformation(extent={{-26,-26},{38,26}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(x={reactorKinetics.Q_total})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(ControlRod_Reactivity.y, reactorKinetics.Reactivity_CR_in)
    annotation (Line(points={{-79,82},{-58,82},{-58,22.8313},{-22.72,22.8313}},
        color={0,0,127}));
  connect(Other_Reactivity.y, reactorKinetics.Reactivity_Other_in) annotation (
      Line(points={{-79,40},{-60,40},{-60,11.4563},{-22.72,11.4563}}, color={0,0,
          127}));
  connect(S_external.y, reactorKinetics.S_external_in) annotation (Line(points={
          {-79,0},{-22.72,0},{-22.72,0.08125}}, color={0,0,127}));
  connect(Teff_Fuel.y, reactorKinetics.Teff_fuel_in) annotation (Line(points={{-79,-40},
          {-60,-40},{-60,-11.4563},{-22.72,-11.4563}},      color={0,0,127}));
  connect(Teff_Coolant.y, reactorKinetics.Teff_coolant_in) annotation (Line(
        points={{-79,-80},{-58,-80},{-58,-22.6687},{-22.72,-22.6687}}, color={0,
          0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    experiment(StopTime=10, __Dymola_NumberOfIntervals=1000),
    __Dymola_experimentSetupOutput);
end PointKinetics_Test;
