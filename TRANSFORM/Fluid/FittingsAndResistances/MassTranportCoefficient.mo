within TRANSFORM.Fluid.FittingsAndResistances;
model MassTranportCoefficient

  extends BaseClasses.PartialResistance;

  input Real alphaM0(unit="kg/(s.m2.K)")=0
    "Coefficient of mass transfer" annotation (Dialog(group="Inputs"));
  input SI.Area surfaceArea "Mass transfer surface area"  annotation(Dialog(group="Inputs"));

  Medium.ThermodynamicState state_a=
      Medium.setState_phX(port_a.p,
                          noEvent(actualStream(port_a.h_outflow)),
                          noEvent(actualStream(port_a.Xi_outflow)))
                                                                   "Medium properties in port_a";

  Medium.ThermodynamicState state_b=
      Medium.setState_phX(port_b.p,
                          noEvent(actualStream(port_b.h_outflow)),
                          noEvent(actualStream(port_b.Xi_outflow))) "Medium properties in port_b";
equation

  port_a.m_flow = alphaM0*surfaceArea*(Medium.temperature(state_a) - Medium.temperature(state_b));

  annotation (defaultComponentName="resistance",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-36,-56},{38,-64}},
          lineColor={0,0,0},
          textString="alpha*A*(Ta-Tb)")}),
        Diagram(coordinateSystem(preserveAspectRatio=false)));
end MassTranportCoefficient;
