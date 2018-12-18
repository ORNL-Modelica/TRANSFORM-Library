within TRANSFORM.Units.Conversions.Functions.Density_kg_m3;
package Examples
  extends TRANSFORM.Icons.ExamplesPackage;

  model check_kg_m3

    extends TRANSFORM.Icons.Example;

    parameter SI.Length u=1;

    final parameter Real x_reference[unitTests.n]={1,1};

    Real x[unitTests.n];

    Utilities.ErrorAnalysis.UnitTests unitTests(n=2,x=x, x_reference=x_reference)
      annotation (Placement(transformation(extent={{80,80},{100,100}})));
  equation

    x[1] = to_kg_m3(u);
    x[2] = from_kg_m3(u);

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end check_kg_m3;

  model check_g_cm3

    extends TRANSFORM.Icons.Example;

    parameter SI.Length u=1;

    final parameter Real x_reference[unitTests.n]={1/1000,1000};

    Real x[unitTests.n];

    Utilities.ErrorAnalysis.UnitTests unitTests(n=2,x=x, x_reference=x_reference)
      annotation (Placement(transformation(extent={{80,80},{100,100}})));
  equation

    x[1] = to_g_cm3(u);
    x[2] = from_g_cm3(u);

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end check_g_cm3;

  model check_lb_ft3

    extends TRANSFORM.Icons.Example;

    parameter SI.Length u=1;

    final parameter Real x_reference[unitTests.n]={0.062428,1/0.062428};

    Real x[unitTests.n];

    Utilities.ErrorAnalysis.UnitTests unitTests(n=2,x=x, x_reference=x_reference)
      annotation (Placement(transformation(extent={{80,80},{100,100}})));
  equation

    x[1] = to_lb_ft3(u);
    x[2] = from_lb_ft3(u);

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end check_lb_ft3;
end Examples;
