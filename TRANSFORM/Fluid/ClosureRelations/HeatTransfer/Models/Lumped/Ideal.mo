within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Lumped;
model Ideal

  extends PartialIdeal;

equation

  T_fluid = T_wall;
  alpha = Modelica.Constants.inf;
  Nu = Modelica.Constants.inf;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Ideal;
