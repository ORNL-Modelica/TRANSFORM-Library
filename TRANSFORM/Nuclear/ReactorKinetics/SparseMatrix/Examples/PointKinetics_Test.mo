within TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Examples;
model PointKinetics_Test
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  Modelica.Blocks.Sources.Sine Teff_Fuel(
    amplitude=5,
    f=0.002,
    startTime=500,
    offset=1000) annotation (Placement(transformation(extent={{-100,-10},
            {-80,10}})));
  Modelica.Blocks.Sources.Sine Teff_Coolant(
    amplitude=10,
    f=0.01,
    startTime=500,
    phase=0.5235987755983,
    offset=500) annotation (Placement(transformation(extent={{-100,-50},
            {-80,-30}})));
  Modelica.Blocks.Sources.Constant ControlRod_Reactivity(k=0.0025)
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.PointKinetics_L1_powerBased_sparseMatrix
                                                                kinetics(
    Q_nominal=1e9,
    Lambda_start=1e-3,
    nFeedback=2,
    redeclare record Data =
        TRANSFORM.Nuclear.ReactorKinetics.Data.PrecursorGroups.precursorGroups_1_userDefined
        (
        lambdas={0.08},
        alphas={1},
        Beta=0.0075),
    rho_input=ControlRod_Reactivity.y,
    alphas_feedback={-2.5e-5,-20e-5},
    vals_feedback={Teff_Fuel.y,Teff_Coolant.y},
    vals_feedback_reference={Teff_Fuel.offset,Teff_Coolant.offset},
    redeclare record Data_FP =
        TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Data.FissionProducts.fissionProducts_TeIXeU,
    mCs_start_FP=mCs_start_FP,
    toggle_ReactivityFP=false,
    use_noGen=true)
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));

  Utilities.ErrorAnalysis.UnitTests unitTests(x={kinetics.Q_fission})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

      parameter Real mCs_start_FP[kinetics.fissionProducts.data.nC] = {if TRANSFORM.Math.exists(i, kinetics.fissionProducts.data.actinideIndex) then 1.43e24 else 0  for i in 1:kinetics.fissionProducts.data.nC};

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    experiment(
      StopTime=1000,
      __Dymola_NumberOfIntervals=1000,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput);
end PointKinetics_Test;
