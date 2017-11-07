within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface;
model Nus "Specify Nusselt Number (Nu)"

  extends PartialSinglePhase;

  input SI.NusseltNumber Nu0=7.54 "Nusselt number"
    annotation (Dialog(group="Input Variables"));
  input SI.NusseltNumber Nus0[nHT,nSurfaces]=fill(
      Nu0,
      nHT,
      nSurfaces) "if non-uniform then set"
    annotation (Dialog(group="Input Variables"));

  parameter Boolean use_DefaultDimension=true
    "= false to set characteristic dimension else from geometry model"
    annotation (Dialog(group="Input Variables"));
  input SI.Length dimension0=0 "Characteristic dimension" annotation (Dialog(
        group="Input Variables", enable=not use_DefaultDimension));
  input SI.Length dimensions0[nHT,nSurfaces]=fill(
      dimension0,
      nHT,
      nSurfaces) "if non-uniform then set" annotation (Dialog(group=
          "Input Variables", enable=not use_DefaultDimension));

  parameter Boolean use_LambdaState=true
    "= false to set thermal conductivity else from film state"
    annotation (Dialog(group="Input Variables"));
  parameter SI.ThermalConductivity lambda0=0 "Thermal conductivity"
    annotation (Dialog(group="Input Variables", enable=not use_LambdaState));
  input SI.ThermalConductivity lambdas0[nHT,nSurfaces]=fill(
      lambda0,
      nHT,
      nSurfaces) "if non-uniform then set"
    annotation (Dialog(group="Input Variables", enable=not use_LambdaState));

  SI.Length[nHT,nSurfaces] L_char "Characteristic length";
  SI.ThermalConductivity[nHT,nSurfaces] lambdas "Thermal conductivity";

equation

  if use_DefaultDimension then
    for i in 1:nHT loop
      for j in 1:nSurfaces loop
        L_char[i, j] = dimensions[i];
      end for;
    end for;
  else
    L_char = dimensions0;
  end if;

  if use_LambdaState then
  for i in 1:nHT loop
    for j in 1:nSurfaces loop
    lambdas[i,j] =mediaProps[i].lambda;
      end for;
    end for;
  else
    lambdas = lambdas0;
  end if;

  Nus = Nus0;
  alphas = Nus .* lambdas ./ L_char;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Nus;
