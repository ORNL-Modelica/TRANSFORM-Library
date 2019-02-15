within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models;
model Ideal
  extends
    TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.PartialIdeal;
equation
  alphas =Modelica.Constants.inf*ones(nHT);
  Nus =Modelica.Constants.inf*ones(nHT);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Ideal;
