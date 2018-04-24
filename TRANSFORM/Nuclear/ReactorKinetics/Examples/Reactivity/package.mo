within TRANSFORM.Nuclear.ReactorKinetics.Examples;
package Reactivity
  extends TRANSFORM.Icons.ExamplesPackage;

  model FissionProducts_Test
    import TRANSFORM;

    extends TRANSFORM.Icons.Example;

    TRANSFORM.Nuclear.ReactorKinetics.Reactivity.FissionProducts fissionProducts(
      nC=data.nC,
      nFS=data.nFS,
      parents=data.parents,
      sigmaA=data.sigmaA_thermal,
      lambda=data.lambdas,
      w_decay=data.w_decay,
      wG_decay=data.wG_decay,
      fissionYield=data.fissionYield_t,
      traceDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    TRANSFORM.Nuclear.ReactorKinetics.Data.FissionProducts.fissionProducts_TeIXe_U235
      data annotation (Placement(transformation(extent={{-10,30},{10,50}})));
    Utilities.ErrorAnalysis.UnitTests unitTests(n=3, x=fissionProducts.mCs[1, :])
      annotation (Placement(transformation(extent={{80,80},{100,100}})));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end FissionProducts_Test;
end Reactivity;
