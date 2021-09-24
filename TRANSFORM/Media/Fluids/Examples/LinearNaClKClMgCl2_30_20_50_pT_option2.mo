within TRANSFORM.Media.Fluids.Examples;
model LinearNaClKClMgCl2_30_20_50_pT_option2
  extends TRANSFORM.Icons.Example;
  parameter Integer n = 3;
  parameter SI.Temperature[n] Ts = {800,998,1050};
  parameter SI.Pressure[n] ps = fill(1e5,3);
  replaceable package Medium =
      TRANSFORM.Media.Fluids.NaClKClMgCl2.LinearNaClKClMgCl2_30_20_50_pT_option2;
  Medium.BaseProperties mediums[n];
  SI.DynamicViscosity eta[n] = Medium.dynamicViscosity(mediums.state);
  SI.ThermalConductivity lambda[n] = Medium.thermalConductivity(mediums.state);
  SI.SpecificHeatCapacity cps[n] = Medium.specificHeatCapacityCp(mediums.state);
  SI.Density d_T[n]=TRANSFORM.Media.Fluids.NaClKClMgCl2.Utilities_30_20_50.d_T(
      Ts,option=2);

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
end LinearNaClKClMgCl2_30_20_50_pT_option2;
