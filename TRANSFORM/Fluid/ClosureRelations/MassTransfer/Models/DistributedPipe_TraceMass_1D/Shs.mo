within TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D;
model Shs "Specify Sherwood Number (Sh)"

  import TRANSFORM.Math.fillArray_1D;

  extends PartialSinglePhase;

  input Units.SherwoodNumber Sh0[Medium.nC]=fill(7.54,Medium.nC) "Nusselt number"
    annotation (Dialog(group="Inputs"));
  input Units.SherwoodNumber Shs0[nMT,Medium.nC]=fillArray_1D(Sh0,nMT)  "if non-uniform then set"
    annotation (Dialog(group="Inputs"));

  parameter Boolean use_DefaultDimension=true
    "= false to set characteristic dimension else from geometry model"
    annotation (Dialog(group="Inputs"));
  input SI.Length dimension0=0 "Characteristic dimension" annotation (Dialog(
        group="Inputs", enable=not use_DefaultDimension));
  input SI.Length dimensions0[nMT]=fill(dimension0,nMT)
    "if non-uniform then set" annotation (Dialog(group="Inputs",
        enable=not use_DefaultDimension));

  SI.Length[nMT] L_char "Characteristic length";

equation

  if use_DefaultDimension then
    L_char = dimensions;
  else
    L_char = dimensions0;
  end if;

  for i in 1:nMT loop
  Shs[i,:] = Shs0[i,:];
  alphasM[i,:] =Shs[i, :] .*diffusionCoeff[i].D_abs ./ L_char[i];
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Shs;
