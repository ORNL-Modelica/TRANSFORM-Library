within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Lumped;
model Ideal

  extends PartialIdeal;

equation

  for i in 1:nSurfaces loop
    Ts_wall[i] = T_fluid;
    alphas[i] = Modelica.Constants.inf;
    Nus[i] = Modelica.Constants.inf;
  end for;

  annotation (defaultComponentName="heatTransfer",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Ideal;
