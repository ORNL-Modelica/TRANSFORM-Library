within TRANSFORM.Media.Fluids.Examples;
model LinearFLiBe_12Th_05U_pT

  extends TRANSFORM.Icons.Example;

  parameter Integer n = 3;
  parameter SI.Temperature[n] Ts = {500+273.15,900+273.15,1350+273.15};
  parameter SI.Pressure[n] ps = fill(1e5,3);

  replaceable package Medium =
      TRANSFORM.Media.Fluids.FLiBe.LinearFLiBe_12Th_05U_pT;

  Medium.BaseProperties mediums[n];

  SI.DynamicViscosity eta[n] = Medium.dynamicViscosity(mediums.state);
  SI.ThermalConductivity lambda[n] = Medium.thermalConductivity(mediums.state);

  SI.Density d_T[n] = TRANSFORM.Media.Fluids.FLiBe.Utilities_12Th_05U.d_T(Ts);

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
end LinearFLiBe_12Th_05U_pT;
