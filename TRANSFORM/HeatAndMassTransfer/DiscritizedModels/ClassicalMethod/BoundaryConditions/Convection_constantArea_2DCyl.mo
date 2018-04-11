within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.BoundaryConditions;
model Convection_constantArea_2DCyl
  "Convection boundary condition for finite difference between port_a and port_b for Cylindrical Coordinates"

parameter Integer nNodes(min=2) "# of nodal points";
input Modelica.SIunits.CoefficientOfHeatTransfer alphas[nNodes]
    "Convection heat transfer coefficient";

parameter Boolean isAxial = true
    "Specify the convection axis (axial or radial)"
    annotation(Evaluate=true);

parameter Boolean isVolCentered = false
    "Solution method is volume centered in axial direction"
    annotation(Dialog(enable=isAxial),Evaluate=true);

parameter Boolean isInner = false
    "Indicate appropriate convection edge (inner or outer)"
    annotation(Dialog(enable=isAxial),Evaluate=true);

input Modelica.SIunits.Length r_inner = 1 "Inner radius" annotation(Dialog(group="Inputs",enable = (if not isAxial then true else isInner)));
input Modelica.SIunits.Length r_outer = 1 "Outer radius" annotation(Dialog(group="Inputs",enable=(if not isAxial then true else not isInner)));
input Modelica.SIunits.Length length = 1 "Axial length" annotation(Dialog(group="Inputs",enable=isAxial));

Modelica.SIunits.Area A;
Modelica.SIunits.Area A_node[nNodes];
Modelica.SIunits.Length dxr;
Modelica.SIunits.Length[nNodes] xr;

Modelica.Fluid.Interfaces.HeatPorts_a port_a[nNodes] annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-100,0}), iconTransformation(
        extent={{-40,-10},{40,10}},
        rotation=-90,
        origin={-110,0})));
Modelica.Fluid.Interfaces.HeatPorts_b port_b[nNodes] annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={100,0}), iconTransformation(
        extent={{-40,-10},{40,10}},
        rotation=-90,
        origin={110,0})));

equation
  if isAxial then
    // Calculate the area for convection of each node based on axial condition
    if isInner then
      A = 2*Modelica.Constants.pi*length*r_inner;
    else
      A = 2*Modelica.Constants.pi*length*r_outer;
    end if;

    if isVolCentered then
      dxr = length/(nNodes);
      xr[1:nNodes] = {dxr*(i-1) + dxr/2 for i in 1:nNodes};
      A_node[1:nNodes] = A/nNodes*ones(nNodes);

    else
      dxr = length/(nNodes-1);
      xr[1:nNodes] = {dxr*(i-1) for i in 1:nNodes};
      A_node[1] = 0.5*A/(nNodes-1);
      A_node[2:nNodes-1] = A/(nNodes-1)*ones(nNodes-2);
      A_node[nNodes] = A_node[1];
    end if;
  else
    // Calculate the area for convection of each node based on radial condition
    A = Modelica.Constants.pi*(r_outer^2-r_inner^2);
    dxr = (r_outer-r_inner)/(nNodes-1);

    xr[1:nNodes] = {dxr*(i-1) + r_inner for i in 1:nNodes};
    A_node[1] = Modelica.Constants.pi*xr[1]*dxr;
    A_node[2:nNodes-1] = {2*Modelica.Constants.pi*xr[i]*dxr for i in 2:nNodes-1};
    A_node[nNodes] = Modelica.Constants.pi*xr[end]*dxr;

  end if;

  for i in 1:nNodes loop
    port_a[i].Q_flow + port_b[i].Q_flow = 0 "Conservation of energy";
    port_a[i].Q_flow = alphas[i]*A_node[i]*(port_a[i].T-port_b[i].T)
      "Heat transfer equation";
  end for;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-66,84},{94,-76}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-94,84},{-64,-76}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Text(
          extent={{-154,-86},{146,-126}},
          textString="%name",
          lineColor={0,0,255}),
        Line(points={{96,4},{96,4}},   color={0,127,255}),
        Line(points={{-64,24},{72,24}}, color={191,0,0}),
        Line(points={{-64,-16},{72,-16}}, color={191,0,0}),
        Line(points={{-38,84},{-38,-76}}, color={0,127,255}),
        Line(points={{2,84},{2,-76}}, color={0,127,255}),
        Line(points={{36,84},{36,-76}}, color={0,127,255}),
        Line(points={{72,84},{72,-76}}, color={0,127,255}),
        Line(points={{-38,-76},{-48,-56}}, color={0,127,255}),
        Line(points={{-38,-76},{-28,-56}}, color={0,127,255}),
        Line(points={{2,-76},{-8,-56}}, color={0,127,255}),
        Line(points={{2,-76},{12,-56}}, color={0,127,255}),
        Line(points={{36,-76},{26,-56}}, color={0,127,255}),
        Line(points={{36,-76},{46,-56}}, color={0,127,255}),
        Line(points={{72,-76},{62,-56}}, color={0,127,255}),
        Line(points={{72,-76},{82,-56}}, color={0,127,255}),
        Line(points={{52,-26},{72,-16}}, color={191,0,0}),
        Line(points={{52,-6},{72,-16}},  color={191,0,0}),
        Line(points={{52,14},{72,24}}, color={191,0,0}),
        Line(points={{52,34},{72,24}}, color={191,0,0})}), Icon(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-64,84},{96,-76}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-92,84},{-62,-76}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Text(
          extent={{-152,-86},{148,-126}},
          textString="%name",
          lineColor={0,0,255}),
        Line(points={{98,4},{98,4}},   color={0,127,255}),
        Line(points={{-62,24},{74,24}}, color={191,0,0}),
        Line(points={{-62,-16},{74,-16}}, color={191,0,0}),
        Line(points={{-36,84},{-36,-76}}, color={0,127,255}),
        Line(points={{4,84},{4,-76}}, color={0,127,255}),
        Line(points={{38,84},{38,-76}}, color={0,127,255}),
        Line(points={{74,84},{74,-76}}, color={0,127,255}),
        Line(points={{-36,-76},{-46,-56}}, color={0,127,255}),
        Line(points={{-36,-76},{-26,-56}}, color={0,127,255}),
        Line(points={{4,-76},{-6,-56}}, color={0,127,255}),
        Line(points={{4,-76},{14,-56}}, color={0,127,255}),
        Line(points={{38,-76},{28,-56}}, color={0,127,255}),
        Line(points={{38,-76},{48,-56}}, color={0,127,255}),
        Line(points={{74,-76},{64,-56}}, color={0,127,255}),
        Line(points={{74,-76},{84,-56}}, color={0,127,255}),
        Line(points={{54,-26},{74,-16}}, color={191,0,0}),
        Line(points={{54,-6},{74,-16}},  color={191,0,0}),
        Line(points={{54,14},{74,24}}, color={191,0,0}),
        Line(points={{54,34},{74,24}}, color={191,0,0})}),
    Documentation(info="<html>
<p>This component is a necessary for the moment until a more appropriate solution to generalize usage of solution methods is found.</p>
</html>"));
end Convection_constantArea_2DCyl;
