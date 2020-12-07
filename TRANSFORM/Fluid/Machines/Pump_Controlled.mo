within TRANSFORM.Fluid.Machines;
model Pump_Controlled
  extends BaseClasses.PartialPump_nom;

  parameter String controlType="RPM" annotation (Dialog(group="Inputs Control Setting"),
      choices(
      choice="RPM",
      choice="m_flow",
      choice="pressure_a",
      choice="pressure_b",
      choice="dp"));
  parameter Boolean use_port=false "=true to toggle port for control signal"
    annotation (Dialog(group="Inputs Control Setting"));

  input Modelica.Units.NonSI.AngularVelocity_rpm N_input=N_nominal
    "Set rotational speed" annotation (Dialog(group="Inputs Control Setting",
        enable=if controlType == "RPM" and use_port == false then true else
          false));
  input SI.MassFlowRate m_flow_input=m_flow_nominal
    "Set per pump mass flow rate" annotation (Dialog(group="Inputs Control Setting",
        enable=if controlType == "m_flow" and use_port == false then true else false));
  input SI.Pressure p_input=p_b_start "Set pressure" annotation (Dialog(group="Inputs Control Setting",
        enable=if controlType == "pressure" and use_port == false then true
           else false));
  input SI.PressureDifference dp_input=dp_nominal "Set pressure rise"
    annotation (Dialog(group="Inputs Control Setting", enable=if controlType == "dp"
           and use_port == false then true else false));

  Modelica.Blocks.Interfaces.RealInput inputSignal if  use_port annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,80}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,70})));

protected
  Modelica.Blocks.Interfaces.RealInput inputSignal_int;

equation
  connect(inputSignal_int, inputSignal);
  if not use_port then
    inputSignal_int = 0;
  end if;
  if use_port then
    if controlType == "RPM" then
      N = max(inputSignal_int, 1e-3);
    elseif controlType == "m_flow" then
      m_flow = inputSignal_int;
    elseif controlType == "pressure_a" then
      port_a.p = inputSignal_int;
    elseif controlType == "pressure_b" then
      port_b.p = inputSignal_int;
    elseif controlType == "dp" then
      dp = inputSignal_int;
    end if;
  else
    if controlType == "RPM" then
      N = max(N_input, 1e-3);
    elseif controlType == "m_flow" then
      m_flow = m_flow_input;
    elseif controlType == "pressure_a" then
      port_a.p = p_input;
    elseif controlType == "pressure_b" then
      port_b.p = p_input;
    elseif controlType == "dp" then
      dp = dp_input;
    end if;
  end if;
  annotation (
    defaultComponentName="pump",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Quasidimensionless group (corrected, referred, or non-dimensional) definitions are summarised in Chart 4.2 of Source 1. Additional resource for corrected or referred speed: https://en.wikipedia.org/wiki/Corrected_speed.</p>
<p><br>Sources</p>
<p>1. P. P. WALSH and P. FLETCHER, <i>Gas Turbine Performance</i>, 2. ed., [repr.], Blackwell Science, Oxford (2004). </p>
</html>"));
end Pump_Controlled;
