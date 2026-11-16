within TRANSFORM.Nuclear.DoseCalculations;
model Dose_AlphaBetaTissue
  "Dose from alpha and low-energy beta emitters distributed in tissue"
  input SItf.SpecificActivity A "Average emitter specific activity [Bq/kg]" annotation(Dialog(group="Inputs"));
  input SI.Energy E_bar "Average particle energy" annotation(Dialog(group="Inputs"));
  parameter SItf.Dose D_start = 0 "Initial dose" annotation(Dialog(tab="Initialization"));
  SItf.Dose D(start=D_start) "Dose";
equation
  der(D) = A*E_bar;
  annotation (defaultComponentName="dose",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Dose_AlphaBetaTissue;
