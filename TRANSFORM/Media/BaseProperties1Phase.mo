within TRANSFORM.Media;
model BaseProperties1Phase
   replaceable package Medium = Modelica.Media.Air.MoistAir
    constrainedby Modelica.Media.Interfaces.PartialMedium
                                                     "Medium in component"
    annotation(choicesAllMatching=true);
  input Medium.ThermodynamicState state "Medium state" annotation(Dialog(group="Inputs"));

//   extends MediaProps;

   SI.SpecificEnthalpy h "Fluid specific enthalpy";
   SI.Density d "Fluid density";
   SI.Temperature T "Fluid temperature";
   SI.Pressure p "Fluid pressure";
   Medium.DynamicViscosity mu "Dynamic viscosity";
   Medium.ThermalConductivity lambda "Thermal conductivity";
   Medium.SpecificHeatCapacity cp "Specific heat capacity";
equation
     h = Medium.specificEnthalpy(state);
     d = Medium.density(state);
     T = Medium.temperature(state);
     p = Medium.pressure(state);
     mu=Medium.dynamicViscosity(state);
     lambda=Medium.thermalConductivity(state);
     cp=Medium.specificHeatCapacityCp(state);
  annotation (defaultComponentName="mediaProps",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-48,20},{46,-12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}),                       Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BaseProperties1Phase;
