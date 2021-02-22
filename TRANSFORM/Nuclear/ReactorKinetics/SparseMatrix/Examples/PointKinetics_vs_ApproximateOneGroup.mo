within TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Examples;
model PointKinetics_vs_ApproximateOneGroup
  "Point kinetics model vs a textbook approximate solution using one effective delayed group"
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  parameter Real Beta = 0.0075;
  parameter Real alpha = 1;
  parameter Real lambda = 0.08;
  parameter Real rho0 = 0.0025;
  parameter Real Lambda = 1e-4;
  TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.PointKinetics_L1_powerBased_sparseMatrix
    kinetics(
    Q_nominal=1e9,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare record Data =
        TRANSFORM.Nuclear.ReactorKinetics.Data.PrecursorGroups.precursorGroups_1_userDefined
        (
        lambdas={lambda},
        alphas={alpha},
        Beta=Beta),
    Lambda_start=Lambda,
    rho_input=rho0,
    toggle_Reactivity=false,
    redeclare model Reactivity =
        TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Reactivity.Isotopes.Lumped.Isotopes_sparseMatrix
        (
        redeclare record Data =
            TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Data.Isotopes.Isotopes_TeIXeU,

        mCs_start=mCs_start_FP,
        use_noGen=true))
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));

  Real Pratio_ref "Reference power to nominal power ratio";
  Real Pratio_exp "Reactor kinetics model power to nominal power ratio";


  parameter Real mCs_start_FP[kinetics.reactivity.data.nC] = {if TRANSFORM.Math.exists(i, kinetics.reactivity.data.actinideIndex) then 1.43e24 else 0  for i in 1:kinetics.reactivity.data.nC};

equation
  Pratio_ref = Beta/(Beta - rho0)*exp(time*Lambda*rho0/(Beta - rho0)) - rho0/(Beta - rho0)*exp(time*(rho0 - Beta)/Lambda);
  Pratio_exp =kinetics.Q_fission/kinetics.Q_nominal;
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    experiment(StopTime=1.1, __Dymola_NumberOfIntervals=100),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>Comparison of the full point kinetics equations to the example of an approximate solution using one effective delayed group presented in Figure 6-1 (pg. 244) of Nuclear Reactor Analysis by Duderstadt and Hamilton (1976).</p>
</html>"));
end PointKinetics_vs_ApproximateOneGroup;
