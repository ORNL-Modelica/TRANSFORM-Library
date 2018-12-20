within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface;
model Ideal

  extends PartialIdeal;

equation

  for i in 1:nHT loop
    for j in 1:nSurfaces loop
      Ts_wall[i,j] = Ts_fluid[i];
      alphas[i,j] = Modelica.Constants.inf;
      Nus[i,j] = Modelica.Constants.inf;
    end for;
  end for;

  annotation (defaultComponentName="heatTransfer",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Ideal;
