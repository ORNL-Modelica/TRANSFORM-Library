within TRANSFORM.Nuclear.ReactorKinetics.Examples;
model PointKinetics_vs_ApproximateOneGroup
  "Point kinetics model vs a textbook approximate solution using one effective delayed group"
  extends Modelica.Icons.Example;
  Utilities.ErrorAnalysis.UnitTests           unitTests(
    n=1,
    x={Pratio_exp},
    x_reference={Pratio_ref})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

  parameter Real beta = 0.0075;
  parameter Real lambda = 0.08;
  parameter Real rho0 = 0.0025;
  parameter Real LAMBDA = 1e-4;

  Modelica.Blocks.Sources.Constant
                               Teff_Fuel(k=0)
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Modelica.Blocks.Sources.Constant Other_Reactivity(k=0)
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Modelica.Blocks.Sources.Constant
                               Teff_Coolant(k=0)
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Modelica.Blocks.Sources.Constant ControlRod_Reactivity(k=rho0)
    annotation (Placement(transformation(extent={{-100,72},{-80,92}})));
  Modelica.Blocks.Sources.Constant S_external(k=0)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  PointKinetics reactorKinetics(
    nI=1,
    Q_nominal=1e9,
    Lambda=LAMBDA,
    alpha_fuel=0,
    alpha_coolant=0,
    beta_i={beta},
    lambda_i={lambda},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-26,-26},{38,26}})));

  Real Pratio_ref "Reference power to nominal power ratio";
  Real Pratio_exp "Reactor kinetics model power to nominal power ratio";

equation
  Pratio_ref = beta/(beta - rho0)*exp(time*lambda*rho0/(beta - rho0)) - rho0/(beta - rho0)*exp(time*(rho0 - beta)/LAMBDA);

  Pratio_exp = reactorKinetics.Q_total/reactorKinetics.Q_nominal;

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
    experiment(StopTime=1.1, __Dymola_NumberOfIntervals=100),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>Comparison of the full point kinetics equations to the example of an approximate solution using one effective delayed group presented in Figure 6-1 (pg. 244) of Nuclear Reactor Analysis by Duderstadt and Hamilton (1976).</p>
</html>"));
end PointKinetics_vs_ApproximateOneGroup;
