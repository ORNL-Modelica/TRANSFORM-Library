within TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D;
model Ideal

  extends PartialIdeal;

equation

  Cs_fluid = Cs_wall;
  alphasM = Modelica.Constants.inf*ones(nMT,Medium.nC);
  Shs = Modelica.Constants.inf*ones(nMT,Medium.nC);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Ideal;
