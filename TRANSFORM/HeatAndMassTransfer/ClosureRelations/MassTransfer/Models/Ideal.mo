within TRANSFORM.HeatAndMassTransfer.ClosureRelations.MassTransfer.Models;
model Ideal
  extends PartialIdeal(Ds_ab =     fill(1,nMT, nC));
equation
  alphasM =Modelica.Constants.inf*ones(nMT, nC);
  Shs =Modelica.Constants.inf*ones(nMT, nC);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Ideal;
