within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Lumped;
model Constant_NusseltNumber_Lumped "Constant Nusselt Number"

  extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Lumped.BaseClasses.PartialLumpedHeatTransfer;

  parameter SI.NusseltNumber Nu0 = 7.54 "Constant Nusselt number";

  parameter Boolean useDimension = true "=true for default dimension from model";
  parameter SI.Length dimension0 = 0 "Characteristic length" annotation(Dialog(enable=not useDimensions));

  parameter Boolean useLambdaState = true "=true for lambda set by medium state";
  parameter SI.ThermalConductivity lambda0 = 0 "Thermal conductivity" annotation(Dialog(enable=not useLambdasState));

  SI.CoefficientOfHeatTransfer alpha "Coefficient of heat transfer";
  SI.NusseltNumber Nu "Nusselt number";
  SI.Length Dim "Characteristic length";
  SI.ThermalConductivity lambda "Thermal conductivity";

equation

  if useDimension then
    Dim = dimension;
  else
    Dim = dimension0;
  end if;

  if useLambdaState then
    lambda = medium2.lambda;
  else
    lambda = lambda0;
  end if;

  Nu = Nu0;
  alpha = TRANSFORM.Utilities.CharacteristicNumbers.HeatTransferCoeffient(
     Nu=Nu,
     D=Dim,
     lambda=lambda);

  Q_flow=alpha*surfaceArea*(T_wall - state.T)*nParallel;

end Constant_NusseltNumber_Lumped;
