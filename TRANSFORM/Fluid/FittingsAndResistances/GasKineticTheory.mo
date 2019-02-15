within TRANSFORM.Fluid.FittingsAndResistances;
model GasKineticTheory
  extends BaseClasses.PartialResistance;
  input Real f = 1.0 "Fraction of vapor molecules striking the liquid surface that enter the liquid phase" annotation(Dialog(group="Inputs"));
  input SI.Area surfaceArea "Mass transfer surface area" annotation(Dialog(group="Inputs"));
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
  port_a.m_flow = f*surfaceArea*(Medium.fluidConstants[1].molarMass/(2*pi*Modelica.Constants.R*Medium.temperature(state_a)))^(0.5)*(port_a.p - port_b.p);//Medium.saturationPressure(Medium.temperature(state_b)));
  annotation (defaultComponentName="resistance",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-36,-56},{38,-64}},
          lineColor={0,0,0},
          textString="GasKinetic")}),
        Diagram(coordinateSystem(preserveAspectRatio=false)));
end GasKineticTheory;
