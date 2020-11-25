within TRANSFORM.Media.Solids.Examples;
model Hastelloy_N_Haynes
  extends TRANSFORM.Icons.Example;
  parameter Integer n = 3;
  parameter SI.Temperature[n] Ts = {300+273.15,500+273.15,700+273.15};
  replaceable package Material =
      TRANSFORM.Media.Solids.Hastelloy_N_Haynes;
  Material.BaseProperties materials[n];
  SI.ThermalConductivity lambda[n] = Material.thermalConductivity(materials.state);
  SI.ThermalConductivity cp[n] = Material.specificHeatCapacityCp(materials.state);
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
end Hastelloy_N_Haynes;
