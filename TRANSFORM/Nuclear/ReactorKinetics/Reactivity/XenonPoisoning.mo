within TRANSFORM.Nuclear.ReactorKinetics.Reactivity;
model XenonPoisoning

  parameter SI.DecayConstant lambda_xenon = 0.0753/60^2 "Xenon decay constant";
  parameter SI.DecayConstant lambda_iodine = 0.1035/60^2 "Xenon decay constant";

  parameter SI.Modelica.Blocks.Interfaces.RealInput
                                       reactorPower
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Interfaces.RealOutput reactivity
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  der(N_iodine) = - lambda_iodine * N_iodine + gamma_iodine * sigma_fission * phi_neutron;
  der(N_xenon)   = - lambda_xenon_effective * N_xenon + gamma_xenon * sigma_fission * phi_neutron + lambda_iodine * N_iodine;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end XenonPoisoning;
