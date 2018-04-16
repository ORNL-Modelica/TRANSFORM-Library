within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Lumped;
model Nus "Specify Nusselt Number (Nu)"

  extends PartialSinglePhase;

  input SI.NusseltNumber Nu0=7.54 "Nusselt number"
    annotation (Dialog(group="Inputs"));

  parameter Boolean use_DefaultDimension=true
    "= false to set characteristic dimension else from geometry model"
    annotation (Dialog(group="Inputs"));
  input SI.Length dimension0=0 "Characteristic dimension" annotation (Dialog(
        group="Inputs", enable=not use_DefaultDimension));

  parameter Boolean use_LambdaState=true
    "= false to set thermal conductivity else from film state"
    annotation (Dialog(group="Inputs"));
  parameter SI.ThermalConductivity lambda0=0 "Thermal conductivity"
    annotation (Dialog(group="Inputs", enable=not use_LambdaState));

  SI.Length L_char "Characteristic length";
  SI.ThermalConductivity lambda "Thermal conductivity";

equation

  if use_DefaultDimension then
    L_char =dimension;
  else
    L_char = dimension0;
  end if;

  if use_LambdaState then
    lambda =mediaProps.lambda;
  else
    lambda = lambda0;
  end if;

  Nu = Nu0;
  alpha = Nu .* lambda ./ L_char;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Nus;
