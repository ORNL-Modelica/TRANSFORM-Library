within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer;
model ConstantNusseltNumber "Constant Nusselt Number"
  extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.BaseClasses.PartialFlowHeatTransfer(
      alphas_start=1000*ones(nHT));
  parameter SI.NusseltNumber[nHT] Nus0 = 7.54*ones(nHT) "Constant Nusselt number";
  parameter Boolean useDimensions = true "=true for default dimensions from model";
  parameter SI.Length[nHT] Dims0=zeros(nHT) "Characteristic length" annotation(Dialog(enable=not useDimensions));
  parameter Boolean useLambdasState = true "=true for lambdas set by mediums state";
  parameter SI.ThermalConductivity[nHT] lambdas0=zeros(nHT) "Thermal conductivity" annotation(Dialog(enable=not useLambdasState));
  Real[nHT] Nus "Nusselt numbers";
  SI.Length[nHT] Dims "Characteristic length";
  Medium.ThermalConductivity[nHT] lambdas "Thermal conductivity";
equation
  if useDimensions then
    Dims = dimensions;
  else
    for i in 1:nHT loop
      Dims[i]=Dims0[i];
    end for;
  end if;
  if useLambdasState then
    lambdas = Medium.thermalConductivity(states);
  else
    for i in 1:nHT loop
      lambdas[i]=lambdas0[i];
    end for;
  end if;
  for i in 1:nHT loop
    Nus[i] = Nus0[i];
    alphas[i] = TRANSFORM.Utilities.CharacteristicNumbers.HeatTransferCoeffient(
       Nu=Nus[i],
       D=Dims[i],
       lambda=lambdas[i]);
  end for;
  Q_flows = {alphas[i]*surfaceAreas[i]*(heatPorts[i].T - Ts[i])*nParallel for i in 1:nHT};
  annotation (Documentation(info="<html>
<p>Heat transfer model for with user specified Nusselt number, characteristic length, and thermal conductivity.</p>
</html>"));
end ConstantNusseltNumber;
