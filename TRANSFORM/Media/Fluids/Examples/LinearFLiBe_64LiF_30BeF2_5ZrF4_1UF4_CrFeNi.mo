within TRANSFORM.Media.Fluids.Examples;
model LinearFLiBe_64LiF_30BeF2_5ZrF4_1UF4_CrFeNi
  extends TRANSFORM.Icons.Example;
  parameter Integer n = 3;
  parameter SI.Temperature[n] Ts = {530+273.15,650+273.15,800+273.15};
  parameter SI.Pressure[n] ps = fill(1e5,3);
  replaceable package Medium =
      TRANSFORM.Media.Fluids.FLiBe.LinearFLiBe_64LiF_30BeF2_5ZrF4_1UF4_CrFeNi;
  Medium.BaseProperties mediums[n];
  SI.DynamicViscosity eta[n] = Medium.dynamicViscosity(mediums.state);
  SI.ThermalConductivity lambda[n] = Medium.thermalConductivity(mediums.state);
  SI.Density d_T[n]=TRANSFORM.Media.Fluids.FLiBe.Utilities_64LiF_30BeF2_5ZrF4_1UF4_CrFeNi.d_T(
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
end LinearFLiBe_64LiF_30BeF2_5ZrF4_1UF4_CrFeNi;
