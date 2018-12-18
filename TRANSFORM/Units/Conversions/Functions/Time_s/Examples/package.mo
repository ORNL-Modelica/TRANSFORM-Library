within TRANSFORM.Units.Conversions.Functions.Time_s;
package Examples
  extends TRANSFORM.Icons.ExamplesPackage;

  model check_s

    extends TRANSFORM.Icons.Example;

    parameter SI.Length u=1;

    final parameter Real x_reference[unitTests.n]={1,1};

    Real x[unitTests.n];

    Utilities.ErrorAnalysis.UnitTests unitTests(n=2,x=x, x_reference=x_reference)
      annotation (Placement(transformation(extent={{80,80},{100,100}})));
  equation

    x[1] = to_s(u);
    x[2] = from_s(u);

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end check_s;

  model check_min

    extends TRANSFORM.Icons.Example;

    parameter SI.Length u=1;

    final parameter Real x_reference[unitTests.n]={1/60,60};

    Real x[unitTests.n];

    Utilities.ErrorAnalysis.UnitTests unitTests(n=2,x=x, x_reference=x_reference)
      annotation (Placement(transformation(extent={{80,80},{100,100}})));
  equation

    x[1] = to_min(u);
    x[2] = from_min(u);

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end check_min;

  model check_hr

    extends TRANSFORM.Icons.Example;

    parameter SI.Length u=1;

    final parameter Real x_reference[unitTests.n]={1/3600,3600};

    Real x[unitTests.n];

    Utilities.ErrorAnalysis.UnitTests unitTests(n=2,x=x, x_reference=x_reference)
      annotation (Placement(transformation(extent={{80,80},{100,100}})));
  equation

    x[1] = to_hr(u);
    x[2] = from_hr(u);

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end check_hr;

  model check_day

    extends TRANSFORM.Icons.Example;

    parameter SI.Length u=1;

    final parameter Real x_reference[unitTests.n]={1/(60*60*24),60*60*24};

    Real x[unitTests.n];

    Utilities.ErrorAnalysis.UnitTests unitTests(n=2,x=x, x_reference=x_reference)
      annotation (Placement(transformation(extent={{80,80},{100,100}})));
  equation

    x[1] = to_day(u);
    x[2] = from_day(u);

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end check_day;

  model check_yr

    extends TRANSFORM.Icons.Example;

    parameter SI.Length u=1;

    final parameter Real x_reference[unitTests.n]={1/(60*60*24*365),60*60*24*365};

    Real x[unitTests.n];

    Utilities.ErrorAnalysis.UnitTests unitTests(n=2,x=x, x_reference=x_reference)
      annotation (Placement(transformation(extent={{80,80},{100,100}})));
  equation

    x[1] = to_yr(u);
    x[2] = from_yr(u);

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end check_yr;
end Examples;
