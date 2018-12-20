within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface;
model Nus_DittusBoelter_Simple "Dittus Boelter | Simple | A*Re^B*Pr^C"

  extends PartialSinglePhase;

  input Real A0=0.023 "Multiplication value" annotation (Dialog(group="Inputs"));
  input Real As0[nHT,nSurfaces]=fill(
      A0,
      nHT,
      nSurfaces) "if non-uniform then set" annotation (Dialog(group="Inputs"));

  input Real B0=0.8 "Exponent to Reynolds number"
    annotation (Dialog(group="Inputs"));
  input Real Bs0[nHT,nSurfaces]=fill(
      B0,
      nHT,
      nSurfaces) "if non-uniform then set" annotation (Dialog(group="Inputs"));

  input Real C0=0.4 "Exponent to Prandtl number"
    annotation (Dialog(group="Inputs"));
  input Real Cs0[nHT,nSurfaces]=fill(
      C0,
      nHT,
      nSurfaces) "if non-uniform then set" annotation (Dialog(group="Inputs"));

  input SI.Length[nHT,nSurfaces] L_char=transpose({dimensions for i in 1:
      nSurfaces}) "Characteristic dimension for calculation of alpha"
    annotation (Dialog(group="Inputs"));
  input SI.ThermalConductivity[nHT,nSurfaces] lambda=transpose({mediaProps.lambda
      for i in 1:nSurfaces}) "Thermal conductivity for calculation of alpha"
    annotation (Dialog(group="Inputs"));

equation

  for i in 1:nHT loop
    for j in 1:nSurfaces loop
      Nus[i, j] = As0[i, j]*Res[i]^Bs0[i, j]*Prs[i]^Cs0[i, j];
    end for;
  end for;

  alphas = Nus .* lambda ./ L_char;

  annotation (defaultComponentName="heatTransfer",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Nus_DittusBoelter_Simple;
