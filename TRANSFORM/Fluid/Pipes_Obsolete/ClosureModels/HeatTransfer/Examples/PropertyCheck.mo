within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Examples;
model PropertyCheck
  replaceable package Medium=Modelica.Media.Water.StandardWater;

  parameter Integer n=10;
  parameter SI.Pressure p = 1e5;
  parameter SI.SpecificEnthalpy hin = 1e5;
  parameter SI.SpecificEnthalpy dhin[n] = {0,0,0,0,2.5e5,2.5e5,2.5e5,2.5e5,2.5e5,2.5e5};

  SI.SpecificEnthalpy h[n];
  Medium.ThermodynamicState states[n];
  Medium.SaturationProperties sat[n] "Properties of saturated fluid";
  Medium.ThermodynamicState bubble[n] "Bubble point state";
  SI.DynamicViscosity mu_fsat[n];
equation
  for i in 1:n loop
    h[i] = hin + dhin[i];
    states[i]=Medium.setState_ph(p,h[i]);
    sat[i] = Medium.setSat_p(states[i].p);

    bubble[i] = Medium.setBubbleState(sat[i], 1);

    mu_fsat[i] = Medium.dynamicViscosity(bubble[i]);
  end for;

end PropertyCheck;
