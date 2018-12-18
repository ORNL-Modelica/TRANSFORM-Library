within TRANSFORM.Units.Conversions.Functions.Concentration_mol_m3;
package Examples
  extends TRANSFORM.Icons.ExamplesPackage;

  model check_mol_m3

    extends TRANSFORM.Icons.Example;

    parameter SI.Length u=1;

    final parameter Real x_reference[unitTests.n]={1,1};

    Real x[unitTests.n];

    Utilities.ErrorAnalysis.UnitTests unitTests(n=2,x=x, x_reference=x_reference)
      annotation (Placement(transformation(extent={{80,80},{100,100}})));
  equation

    x[1] = to_mol_m3(u);
    x[2] = from_mol_m3(u);

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end check_mol_m3;

  model check_mol_L

    extends TRANSFORM.Icons.Example;

    parameter SI.Length u=1;

    final parameter Real x_reference[unitTests.n]={1/1000,1000};

    Real x[unitTests.n];

    Utilities.ErrorAnalysis.UnitTests unitTests(n=2,x=x, x_reference=x_reference)
      annotation (Placement(transformation(extent={{80,80},{100,100}})));
  equation

    x[1] = to_mol_L(u);
    x[2] = from_mol_L(u);

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end check_mol_L;
end Examples;
