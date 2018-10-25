within TRANSFORM.Nuclear.DoseCalculations;
model Dose_AlphaBetaTissue
  "Dose from alpha and low-energy beta emitters distributed in tissue"

  input SIadd.SpecificActivity A = 1 "Average emitter specific activity [Bq/kg]";
  input SI.Energy E_bar = 1 "Average particle energy";

  parameter SIadd.Dose D_start = 0 "Initial dose" annotation(Dialog(tab="Initialization"));

  SIadd.Dose D(start=D_start) "Dose";
equation
  der(D) = A*E_bar;

  annotation (defaultComponentName="dose",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Dose_AlphaBetaTissue;
