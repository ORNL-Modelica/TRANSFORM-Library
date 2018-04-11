within TRANSFORM.Fluid.FittingsAndResistances;
model ElevationChange "Elevation pressure change (i.e., port_a.p - port_b.p = dp = dheight*d*g_n)"

  extends BaseClasses.PartialResistance;

  input SI.Length dheight=0 "Height change (port_b - port_a)"
    annotation (Dialog(group="Inputs"));

  input SI.Acceleration g_n=Modelica.Constants.g_n "Gravitational acceleration"
    annotation (Dialog(group="Inputs"));

  input SI.Density d = Medium.density(state) "Density" annotation (Dialog(group="Inputs"));

equation

  dp = dheight*d*g_n;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                                                    Text(
          extent={{-30,-50},{30,-70}},
          lineColor={0,0,0},
          textString="dheight")}),                               Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ElevationChange;
