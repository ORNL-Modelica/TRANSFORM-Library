within TRANSFORM.Units.Conversions.Functions.VolumeFlowRate_m3_s;
package Examples
  extends TRANSFORM.Icons.ExamplesPackage;

  model check_m3_s

    extends TRANSFORM.Icons.Example;

    parameter SI.Length u=1;

    final parameter Real x_reference[unitTests.n]={1,1};

    Real x[unitTests.n];

    Utilities.ErrorAnalysis.UnitTests unitTests(n=2,x=x, x_reference=x_reference)
      annotation (Placement(transformation(extent={{80,80},{100,100}})));
  equation

    x[1] = to_m3_s(u);
    x[2] = from_m3_s(u);

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end check_m3_s;

  model check_gpm

    extends TRANSFORM.Icons.Example;

    parameter SI.Length u=1;

    final parameter Real x_reference[unitTests.n]={15850.372483753,1/15850.372483753};

    Real x[unitTests.n];

    Utilities.ErrorAnalysis.UnitTests unitTests(n=2,x=x, x_reference=x_reference)
      annotation (Placement(transformation(extent={{80,80},{100,100}})));
  equation

    x[1] = to_gpm(u);
    x[2] = from_gpm(u);

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end check_gpm;

end Examples;
