within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Models;
model Constant_Nus "Constant Nusselt number"

  extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Models.PartialHeatTransfer_setQ_flows;

  parameter SI.NusseltNumber Nu0 = 7.54 "Constant Nusselt number" annotation(Dialog(group="Heat Transfer Model:"));

  parameter Boolean use_DefaultDimension = true "=false to set characteristic dimension (alpha = Nu*lambda/dimension0)" annotation(Dialog(group="Heat Transfer Model:"));
  parameter SI.Length dimension0 = 0 "Characteristic dimension" annotation(Dialog(group="Heat Transfer Model:",enable=not use_DefaultDimension));

  parameter Boolean use_LambdaState = true "=false to set thermal conductivity (alpha = Nu*lambda0/dimension)" annotation(Dialog(group="Heat Transfer Model:"));
  parameter SI.ThermalConductivity lambda0 = 0 "Thermal conductivity" annotation(Dialog(group="Heat Transfer Model:",enable= not use_LambdaState));

  SI.Length[nHT] Dims "Characteristic length";
  SI.ThermalConductivity[nHT] lambdas "Thermal conductivity";
  SI.NusseltNumber[nHT] Nus "Nusselt number";

equation

  if use_DefaultDimension then
    Dims = dimensions;
  else
    Dims = dimension0*ones(nHT);
  end if;

  if use_LambdaState then
    lambdas =mediums1.lambda;
  else
    lambdas = lambda0*ones(nHT);
  end if;

  Nus = Nu0*ones(nHT);
  alphas = TRANSFORM.Utilities.CharacteristicNumbers.HeatTransferCoeffient(
     Nu=Nus,
     D=Dims,
     lambda=lambdas);

  annotation (defaultComponentName="heatTransfer",
Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Constant_Nus;
