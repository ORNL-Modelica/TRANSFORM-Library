within TRANSFORM.Nuclear.ReactorKinetics.Examples;
model PointKinetics_Test
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  Modelica.Blocks.Sources.Sine Teff_Fuel(
    amplitude=5,
    freqHz=0.002,
    startTime=1e4,
    offset=1000)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Sources.Sine Teff_Coolant(
    amplitude=10,
    freqHz=0.01,
    startTime=1e4,
    phase=0.5235987755983,
    offset=500)
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Modelica.Blocks.Sources.Constant ControlRod_Reactivity(k=0.0025)
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  TRANSFORM.Nuclear.ReactorKinetics.Kinetics_L1_powerBased kinetics(
    Q_nominal=1e9,
    Lambda_start=1e-3,
    rhos_input={ControlRod_Reactivity.y},
    nFeedback=2,
    alphas_feedback=[-2.5e-5,-20e-5],
    vals_feedback=[Teff_Fuel.y,Teff_Coolant.y],
    vals_feedback_reference=[Teff_Fuel.offset,Teff_Coolant.offset],
    redeclare record Data =
        TRANSFORM.Nuclear.ReactorKinetics.Data.PrecursorGroups.precursorGroups_1_userDefined
        (
        lambdas={0.08},
        alphas={1},
        Beta=0.0075))
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(x={kinetics.Q_fission_total})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    experiment(StopTime=10, __Dymola_NumberOfIntervals=1000),
    __Dymola_experimentSetupOutput);
end PointKinetics_Test;
