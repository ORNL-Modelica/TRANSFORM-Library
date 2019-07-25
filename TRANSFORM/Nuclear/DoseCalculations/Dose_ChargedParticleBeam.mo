within TRANSFORM.Nuclear.DoseCalculations;
model Dose_ChargedParticleBeam "Dose from charged particle beams"
  input SI.Density d "Tissue density" annotation(Dialog(group="Inputs"));
  input SIadd.NeutronFlux phi "Fluence of parallel beam of monoenergetic charge particles" annotation(Dialog(group="Inputs"));
  input SIadd.StoppingPowerParticle dE_dx "Collisional stopping power" annotation(Dialog(group="Inputs"));
  parameter SIadd.Dose D_start = 0 "Initial dose" annotation(Dialog(tab="Initialization"));
  SIadd.Dose D(start=D_start) "Dose";
equation
  der(D) = -dE_dx*phi/d;
  annotation (defaultComponentName="dose",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Dose_ChargedParticleBeam;
