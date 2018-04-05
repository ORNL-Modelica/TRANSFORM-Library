within TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D_MultiTransferSurface;
model Ideal

  extends PartialIdeal;

equation

  for i in 1:nMT loop
    for j in 1:nSurfaces loop
      Cs_wall[i, j, :] = Cs_fluid[i, :];
      alphasM[i, j, :] = Modelica.Constants.inf*ones(nC);
      Shs[i, j, :] = Modelica.Constants.inf*ones(nC);
    end for;
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Ideal;
