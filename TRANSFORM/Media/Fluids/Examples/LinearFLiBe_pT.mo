within TRANSFORM.Media.Fluids.Examples;
model LinearFLiBe_pT

  extends TRANSFORM.Icons.Example;

  parameter Integer n = 3;
  parameter SI.Temperature[n] Ts = {500+273.15,900+273.15,1350+273.15};
  parameter SI.Pressure[n] ps = fill(1e5,3);

  replaceable package Medium =
      TRANSFORM.Media.Fluids.FLiBe.LinearFLiBe_pT;

  Medium.BaseProperties mediums[n];

  SI.DynamicViscosity eta[n] = Medium.dynamicViscosity(mediums.state);
  SI.ThermalConductivity lambda[n] = Medium.thermalConductivity(mediums.state);

  SI.Density d_exp[n] = {2.0354e3,1.84e3,1.6203e3};
  SI.DynamicViscosity eta_exp[n] = {1.4918e-2,2.848e-3,1.1726e-3};
  SI.ThermalConductivity lambda_exp[n] = {1.0166,1.2166,1.4416};

  SI.Density d_T[n] = TRANSFORM.Media.Fluids.FLiBe.Utilities.d_T(Ts);

  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(
    n=9,
    x=cat(
        1,
        mediums.d,
        eta,
        lambda),
    x_reference=cat(
        1,
        d_exp,
        eta_exp,
        lambda_exp))
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  mediums.p = ps;
  mediums.T = Ts;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end LinearFLiBe_pT;
