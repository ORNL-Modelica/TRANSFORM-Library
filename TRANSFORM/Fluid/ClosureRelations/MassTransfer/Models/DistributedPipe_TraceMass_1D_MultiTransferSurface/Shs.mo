within TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D_MultiTransferSurface;
model Shs "Specify Sherwood Number (Sh)"
  import TRANSFORM.Math.fillArray_2D;
  extends PartialSinglePhase;
  input Units.SherwoodNumber Sh0[nC]=fill(7.54, nC)
    "Sherwood number" annotation (Dialog(group="Inputs"));
  input Units.SherwoodNumber Shs0[nMT,nSurfaces,nC]=fillArray_2D(
      Sh0,
      nMT,
      nSurfaces) "if non-uniform then set"
    annotation (Dialog(group="Inputs"));
  parameter Boolean use_DefaultDimension=true
    "= false to set characteristic dimension else from geometry model"
    annotation (Dialog(group="Inputs"));
  input SI.Length dimension0=0 "Characteristic dimension" annotation (Dialog(
        group="Inputs", enable=not use_DefaultDimension));
  input SI.Length dimensions0[nMT,nSurfaces]=fill(
      dimension0,
      nMT,
      nSurfaces) "if non-uniform then set" annotation (Dialog(group="Inputs",
        enable=not use_DefaultDimension));
  SI.Length[nMT,nSurfaces] L_char "Characteristic length";
equation
  if use_DefaultDimension then
    for i in 1:nMT loop
      for j in 1:nSurfaces loop
        L_char[i, j] = dimensions[i];
      end for;
    end for;
  else
    L_char = dimensions0;
  end if;
  for i in 1:nMT loop
    for j in 1:nSurfaces loop
      Shs[i, j, :] = Shs0[i, j, :];
      alphasM[i, j, :] = Shs[i, j, :] .* diffusionCoeff[i].D_abs ./ L_char[i, j];
    end for;
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Shs;
