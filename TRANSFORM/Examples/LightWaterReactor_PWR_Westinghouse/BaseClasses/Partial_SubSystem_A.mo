within TRANSFORM.Examples.LightWaterReactor_PWR_Westinghouse.BaseClasses;
partial model Partial_SubSystem_A
  extends Partial_SubSystem;
  extends Record_SubSystem_A;
  import Modelica.Constants;
   Fluid.Interfaces.FluidPort_State      port_a(redeclare package Medium =
         Medium, m_flow(min=if allowFlowReversal then -Constants.inf else 0))
     "Fluid connector a (positive design flow direction is from port_a to port_b)"
     annotation (Placement(transformation(extent={{90,-50},{110,-30}}),
         iconTransformation(extent={{90,-50},{110,-30}})));
   Fluid.Interfaces.FluidPort_Flow       port_b(redeclare package Medium =
         Medium, m_flow(max=if allowFlowReversal then +Constants.inf else 0))
     "Fluid connector b (positive design flow direction is from port_a to port_b)"
     annotation (Placement(transformation(extent={{90,30},{110,50}}),
        iconTransformation(extent={{90,30},{110,50}})));
  annotation (
    defaultComponentName="PHS",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            140}})));
end Partial_SubSystem_A;
