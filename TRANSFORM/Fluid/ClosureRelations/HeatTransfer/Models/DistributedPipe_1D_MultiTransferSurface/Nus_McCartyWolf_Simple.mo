within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface;
model Nus_McCartyWolf_Simple
  "McCarthy-Wolf | Simple | A*E*Re^B*Pr^C*(Tw/Tb)^D"

  extends PartialSinglePhase;

  input Real A0=0.025 "Multiplication value" annotation (Dialog(group="Inputs"));
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

  input Real D0=0.4 "Exponent to Temperature ratio"
    annotation (Dialog(group="Inputs"));
  input Real Ds0[nHT,nSurfaces]=fill(
      D0,
      nHT,
      nSurfaces) "if non-uniform then set" annotation (Dialog(group="Inputs"));
  input Real E0=1.06 "Entrance effect"
    annotation (Dialog(group="Inputs"));
  input Real Es0[nHT,nSurfaces]=fill(
      E0,
      nHT,
      nSurfaces) "if non-uniform then set" annotation (Dialog(group="Inputs"));

  input SI.Length[nHT,nSurfaces] L_char=transpose({dimensions for i in 1:
      nSurfaces}) "Characteristic dimension for calculation of alpha"
    annotation (Dialog(group="Inputs"));
  input SI.ThermalConductivity[nHT,nSurfaces] lambda=transpose({mediaProps.lambda
      for i in 1:nSurfaces}) "Thermal conductivity for calculation of alpha"
    annotation (Dialog(group="Inputs"));
  input SI.Temperature[nHT, nSurfaces] T_bulk=transpose({mediaProps.T
      for i in 1:nSurfaces}) "Bulk temperature"
    annotation (Dialog(group="Inputs"));
 //   input SI.Temperature[nHT, nSurfaces] T_wall=transpose({heatPorts[:,i].T
 //     for i in 1:nSurfaces}) "Wall temperature"
 //   annotation (Dialog(group="Inputs"));

equation

  for i in 1:nHT loop
    for j in 1:nSurfaces loop
      Nus[i, j] = As0[i, j]*Res[i]^Bs0[i, j]*Prs[i]^Cs0[i, j]*(T_bulk[i, j]/Ts_wall[i, j])^Ds0[i, j]*Es0[i, j];
    end for;
  end for;

  alphas = Nus .* lambda ./ L_char;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Nus_McCartyWolf_Simple;
