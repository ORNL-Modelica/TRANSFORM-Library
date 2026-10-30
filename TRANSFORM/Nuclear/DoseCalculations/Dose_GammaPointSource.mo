within TRANSFORM.Nuclear.DoseCalculations;
model Dose_GammaPointSource "Dose from point source of gamma rays"
  input SI.Length r "Distance from source" annotation(Dialog(group="Inputs"));
  input SIadd.InverseTime C "Source activity [Bq]" annotation(Dialog(group="Inputs"));
  input SI.Energy E "Particle energy" annotation(Dialog(group="Inputs"));
  input SI.MassAttenuationCoefficient mu_rho = 0.0027 "Mass energy-absorption coefficient" annotation(Dialog(group="Inputs"));
  parameter SIadd.Dose D_start = 0 "Initial dose" annotation(Dialog(tab="Initialization"));
  SIadd.Dose D(start=D_start) "Dose";
equation
  der(D) = C*E*mu_rho/(4*Modelica.Constants.pi*r^2);
  annotation (defaultComponentName="dose",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Dose_GammaPointSource;
