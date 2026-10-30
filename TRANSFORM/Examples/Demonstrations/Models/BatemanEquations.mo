within TRANSFORM.Examples.Demonstrations.Models;
model BatemanEquations
  parameter Integer n = 4 "Number of isotopes in decay chain";
  input SIadd.InverseTime[n] lambdas = {0.01,0.05,0.05,0.01} "Decay constant for isotope i" annotation(Dialog(group="Inputs"));
  input SI.Area[n] sigmas = {0.4,0.3,0.2,0.1} "Yield cross-section for isotope i generation" annotation(Dialog(group="Inputs"));
  input Real phi = 1 "Flux" annotation(Dialog(group="Inputs"));
  parameter Real[n] Ns_start = {500,100,300,200} "Initial number of atoms for isotope i" annotation(Dialog(tab="Initialization"));
  Real[n] Nbs "Sources and sinks for isotope i";
  Real[n] Ns(start=Ns_start) "Atoms of isotope i";
initial equation
  Ns = Ns_start;
equation
  der(Ns) = Nbs;
  Nbs[1] = phi*sigmas[1] - lambdas[1]*Ns[1];
  for i in 2:n loop
    Nbs[i] = phi*sigmas[i] - lambdas[i]*Ns[i] + lambdas[i-1]*Ns[i-1];
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Bitmap(extent={{-100,-100},{100,100}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/BatemanEquations.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1000, __Dymola_NumberOfIntervals=1000));
end BatemanEquations;
