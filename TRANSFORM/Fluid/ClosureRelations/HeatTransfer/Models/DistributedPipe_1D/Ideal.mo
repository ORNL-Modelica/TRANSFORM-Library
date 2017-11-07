within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D;
model Ideal

  extends PartialIdeal;

equation

  Ts_fluid = Ts_wall;
  alphas = Modelica.Constants.inf*ones(nHT);
  Nus = Modelica.Constants.inf*ones(nHT);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Ideal;
