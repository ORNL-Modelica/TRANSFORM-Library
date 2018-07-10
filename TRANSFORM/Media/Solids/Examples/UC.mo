within TRANSFORM.Media.Solids.Examples;
model UC

  extends TRANSFORM.Icons.Example;

  parameter Integer n = 3;
  parameter SI.Temperature[n] Ts = {298.15,900+273.15,1350+273.15};

  replaceable package Material =
      TRANSFORM.Media.Solids.UC(porosity=0.5);

  Material.BaseProperties materials[n];

  SI.ThermalConductivity lambda[n] = Material.thermalConductivity(materials.state);

  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(
    n=6, x=cat(
        1,
        materials.d,
        lambda))
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  materials.T = Ts;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end UC;
