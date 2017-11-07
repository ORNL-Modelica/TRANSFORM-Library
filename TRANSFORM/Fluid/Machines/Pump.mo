within TRANSFORM.Fluid.Machines;
model Pump "Centrifugal pump with ideally controlled speed"
  extends TRANSFORM.Fluid.Machines.BaseClasses.PartialPump;

  parameter String controlType="RPM" annotation (Dialog(group=
          "Input Variables: Control Setting"), choices(
      choice="RPM",
      choice="m_flow",
      choice="pressure"));
  parameter Boolean use_port=false "=true to toggle port for control signal"
    annotation (Dialog(group="Input Variables: Control Setting"));

  input SI.Conversions.NonSIunits.AngularVelocity_rpm N_input=N_nominal
    "Set rotational speed" annotation (Dialog(group=
          "Input Variables: Control Setting", enable=if controlType == "RPM"
           and use_port == false then true else false));
  input SI.MassFlowRate m_flow_input=m_flow_nominal "Set mass flow rate"
    annotation (Dialog(group="Input Variables: Control Setting", enable=if
          controlType == "m_flow" and use_port == false then true else false));
  input SI.Pressure p_input=p_a_start + dp_nominal "Set pressure" annotation (
      Dialog(group="Input Variables: Control Setting", enable=if controlType
           == "pressure" and use_port == false then true else false));

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
    elseif controlType == "pressure" then
      if exposeState_a and not exposeState_b then
        dp = port_b.p - inputSignal_int;
      elseif not exposeState_a and exposeState_b then
        dp = inputSignal_int - port_a.p;
      else
        assert(false,
          "Pressure control requires either exposeState_a or exposeState_b to be true but not both.");
      end if;
    end if;
  else
    if controlType == "RPM" then
      N = max(N_input, 1e-3);
    elseif controlType == "m_flow" then
      m_flow = m_flow_input;
    elseif controlType == "pressure" then
      if exposeState_a and not exposeState_b then
        dp = port_b.p - p_input;
      elseif not exposeState_a and exposeState_b then
        dp = p_input - port_a.p;
      else
        assert(false,
          "Pressure control requires either exposeState_a or exposeState_b to be true but not both.");
      end if;
    end if;
  end if;
  annotation (defaultComponentName="pump", Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}})));
end Pump;
