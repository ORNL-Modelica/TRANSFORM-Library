within TRANSFORM.Units.Conversions.Functions.Frequency_Hz;
package Examples
  extends TRANSFORM.Icons.ExamplesPackage;

  model check_Hz

    extends TRANSFORM.Icons.Example;

    parameter SI.Length u=1;

    final parameter Real x_reference[unitTests.n]={1,1};

    Real x[unitTests.n];

    Utilities.ErrorAnalysis.UnitTests unitTests(n=2,x=x, x_reference=x_reference)
      annotation (Placement(transformation(extent={{80,80},{100,100}})));
  equation

    x[1] = to_Hz(u);
    x[2] = from_Hz(u);

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end check_Hz;
end Examples;
