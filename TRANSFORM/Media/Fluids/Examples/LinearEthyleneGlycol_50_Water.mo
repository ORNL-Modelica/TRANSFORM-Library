within TRANSFORM.Media.Fluids.Examples;
model LinearEthyleneGlycol_50_Water
  extends TRANSFORM.Icons.Example;
  parameter Integer n = 3;
  parameter SI.Temperature[n] Ts = {0+273.15,20+273.15,50+273.15};
  parameter SI.Pressure[n] ps = fill(1e5,3);
  replaceable package Medium =
      TRANSFORM.Media.Fluids.EthyleneGlycol.LinearEthyleneGlycol_50_Water;
  Medium.BaseProperties mediums[n];
  SI.DynamicViscosity eta[n] = Medium.dynamicViscosity(mediums.state);
  SI.ThermalConductivity lambda[n] = Medium.thermalConductivity(mediums.state);
  SI.SpecificHeatCapacity cp[n] = Medium.specificHeatCapacityCp(mediums.state);
  SI.Density d_T[n]=TRANSFORM.Media.Fluids.EthyleneGlycol.Utilities_EthyleneGlycol_50_Water.d_T(
      Ts);
  SI.SpecificHeatCapacity cp_T[n] = TRANSFORM.Media.Fluids.EthyleneGlycol.Utilities_EthyleneGlycol_50_Water.cp_T(Ts);

  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(
    n=3,
    x=cat(1, mediums.d),
    x_reference=cat(1, d_T))
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  mediums.p = ps;
  mediums.T = Ts;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end LinearEthyleneGlycol_50_Water;
