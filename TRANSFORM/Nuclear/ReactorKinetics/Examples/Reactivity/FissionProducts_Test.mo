within TRANSFORM.Nuclear.ReactorKinetics.Examples.Reactivity;
model FissionProducts_Test
  import TRANSFORM;

  extends TRANSFORM.Icons.Example;

  Utilities.ErrorAnalysis.UnitTests unitTests(n=3, x=fissionProducts.mCs[1, :])
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  TRANSFORM.Nuclear.ReactorKinetics.Reactivity.FissionProducts_withDecayHeat
    fissionProducts(traceDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      redeclare record Data =
        TRANSFORM.Nuclear.ReactorKinetics.Data.FissionProducts.fissionProducts_TeIXe_U235)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end FissionProducts_Test;
