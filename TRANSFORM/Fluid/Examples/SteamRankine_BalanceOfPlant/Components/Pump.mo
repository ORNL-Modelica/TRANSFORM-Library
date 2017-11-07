within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components;
model Pump

  extends PartialPump;

  parameter Boolean use_N_input=false
    "Get the rotational speed from the input connector";
  parameter Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm
    N_constant=N_nominal "Constant rotational speed"
    annotation (Dialog(enable=not use_N_input));

  Modelica.Blocks.Interfaces.RealInput N_input(unit="rev/min") if   use_N_input
    "Prescribed rotational speed" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100})));

protected
  Modelica.Blocks.Interfaces.RealInput N_internal(unit="rev/min")
    "Needed to connect to conditional connector";

equation

  connect(N_input, N_internal);
  if not use_N_input then
    N_internal = N_constant;
  end if;

  // Set N with a lower limit to avoid singularities at zero speed
  N = max(N_internal, 1e-3);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Pump;
