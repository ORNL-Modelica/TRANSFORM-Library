within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models;
model Nus "Specify Nusselt Number"

  extends
    TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.PartialSinglePhase;

  input SI.NusseltNumber Nu0=7.54 "Nusselt number"
    annotation (Dialog(group="Input Variables"));
  input SI.NusseltNumber Nus0[nHT]=fill(Nu0, nHT) "if non-uniform then set"
    annotation (Dialog(group="Input Variables"));

  parameter Boolean use_DefaultDimension=true
    "= false to set characteristic dimension else from geometry model"
    annotation (Dialog(group="Input Variables"));
  input SI.Length dimension0=0 "Characteristic dimension" annotation (Dialog(
        group="Input Variables", enable=not use_DefaultDimension));
  input SI.Length dimensions0[nHT]=fill(dimension0, nHT)
    "if non-uniform then set" annotation (Dialog(group="Input Variables",
        enable=not use_DefaultDimension));

  parameter Boolean use_LambdaState=true
    "= false to set thermal conductivity else from film state"
    annotation (Dialog(group="Input Variables"));
  parameter SI.ThermalConductivity lambda0=0 "Thermal conductivity"
    annotation (Dialog(group="Input Variables", enable=not use_LambdaState));
  input SI.ThermalConductivity lambdas0[nHT]=fill(lambda0, nHT)
    "if non-uniform then set"
    annotation (Dialog(group="Input Variables", enable=not use_LambdaState));

  SI.Length[nHT] L_char "Characteristic length";
  SI.ThermalConductivity[nHT] lambdas "Thermal conductivity";

equation

  if use_DefaultDimension then
    L_char = dimensions;
  else
    L_char = dimensions0;
  end if;

  if use_LambdaState then
    lambdas =mediums_film.lambda;
  else
    lambdas = lambdas0;
  end if;

  Nus = Nus0;
  alphas = Nus.*lambdas./L_char;

  annotation (
    defaultComponentName="heatTransfer",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Nus;
