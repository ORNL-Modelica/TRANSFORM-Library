within TRANSFORM.Media.Fluids.Examples;
model LinearNaNO3KNO3_6040mass_pT
  extends TRANSFORM.Icons.Example;
  parameter Integer n = 3;
  parameter SI.Temperature[n] Ts = {300+273.15,450+273.15,600+273.15};
  parameter SI.Pressure[n] ps = fill(1e5,3);
  replaceable package Medium =
      TRANSFORM.Media.Fluids.NaNO3KNO3.LinearNaNO3KNO3_6040mass;
  Medium.BaseProperties mediums[n];
  SI.DynamicViscosity eta[n] = Medium.dynamicViscosity(mediums.state);
  SI.ThermalConductivity lambda[n] = Medium.thermalConductivity(mediums.state);
  SI.SpecificHeatCapacity cp[n] = Medium.specificHeatCapacityCp(mediums.state);

  SI.Density d_T[n]=TRANSFORM.Media.Fluids.NaNO3KNO3.Utilities_NaNO3KNO3_6040mass.d_T(Ts);
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
end LinearNaNO3KNO3_6040mass_pT;
