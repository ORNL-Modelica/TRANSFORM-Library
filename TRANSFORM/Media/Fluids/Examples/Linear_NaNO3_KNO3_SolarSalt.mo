within TRANSFORM.Media.Fluids.Examples;
model Linear_NaNO3_KNO3_SolarSalt
  extends TRANSFORM.Icons.Example;
  parameter Integer n = 3;
  parameter SI.Temperature[n] Ts = {530+273.15,650+273.15,800+273.15};
  parameter SI.Pressure[n] ps = fill(1e5,3);
  replaceable package Medium =
      TRANSFORM.Media.Fluids.NaNO3KNO3SolarSalt.NaNO3KNO3SolarSalt_pT;
  Medium.BaseProperties mediums[n];
  SI.DynamicViscosity eta[n] = Medium.dynamicViscosity(mediums.state);
  SI.ThermalConductivity lambda[n] = Medium.thermalConductivity(mediums.state);
  SI.Density d_T[n]=TRANSFORM.Media.Fluids.NaNO3KNO3SolarSalt.Utilities_50_50_SolarSalt.d_T(
      Ts);
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
end Linear_NaNO3_KNO3_SolarSalt;
