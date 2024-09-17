within TRANSFORM.HeatExchangers.Components;
model WallAndInsulationHX

  import Modelica.Fluid.Types.Dynamics;
  parameter Integer nV = 1;

  input SI.Length dlengths[nV] "Length" annotation (Dialog(group="Inputs"));
  input SI.Area surfaceAreas[nV] "Surface area" annotation (Dialog(group="Inputs"));
  input SI.Length ths_wall[nV] = fill(0.001, nV) "Wall thickness" annotation (Dialog(group="Inputs"));
  input SI.Length ths_insulation[nV]=fill(0.1, nV) "Insulation thickness"
    annotation (Dialog(group="Inputs"));
  input SI.Temperature Ts_ambient[nV]=fill(293.15, nV) "Ambient temperature of each sectionAmbient temperature"
                          annotation (Dialog(group="Inputs"));
  input SI.CoefficientOfHeatTransfer alphas_ambient[nV]=fill(10,
      nV) "Heat transfer coefficient to ambient" annotation (Dialog(group="Inputs"));

  replaceable package Material_wall = TRANSFORM.Media.Solids.SS316
    constrainedby TRANSFORM.Media.Interfaces.Solids.PartialAlloy
    "Wall material properties" annotation (choicesAllMatching=true);
  replaceable package Material_insulation =
      TRANSFORM.Media.Solids.FiberGlassGeneric constrainedby
    TRANSFORM.Media.Interfaces.Solids.PartialAlloy "Wall material properties"
    annotation (choicesAllMatching=true);
  // Initialization: Wall
  parameter Dynamics energyDynamics_wall=Dynamics.DynamicFreeInitial
    "Formulation of energy balances"
    annotation (Dialog(tab="Initialization: Wall", group="Dynamics"));
  parameter Dynamics energyDynamics_insulation=Dynamics.DynamicFreeInitial
    "Formulation of energy balances"
    annotation (Dialog(tab="Initialization: Wall", group="Dynamics"));
  parameter SI.Temperature T_wall_start[nV]=fill(298.15,nV)
    "Wall temperature" annotation (Dialog(tab="Initialization: Wall", group="Start Value: Temperature"));
  parameter SI.Temperature T_insulation_start[nV]=T_wall_start
    "Insulation temperature" annotation (Dialog(tab="Initialization: Wall",
        group="Start Value: Temperature"));
  input SI.HeatFlowRate Q_gen[nV]=zeros(nV)
    "Wall internal heat generation" annotation (Dialog(group="Inputs"));

  HeatAndMassTransfer.Volumes.SimpleWall_Cylinder insulation[nV](
    length=wall.length,
    r_inner=wall.r_outer,
    each exposeState_a=true,
    redeclare package Material = Material_insulation,
    each energyDynamics=energyDynamics_insulation,
    T_start=T_insulation_start,
    r_outer=ths_insulation + wall.r_outer) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-26})));
  HeatAndMassTransfer.Resistances.Heat.Convection convection[nV](
      surfaceArea=insulation.surfaceArea_outer, alpha=alphas_ambient)
                                                annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90)));
  HeatAndMassTransfer.BoundaryConditions.Heat.Temperature_multi boundary(nPorts=nV,
      use_port=true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,26})));
  Modelica.Blocks.Sources.RealExpression boundaryT[nV](y=Ts_ambient)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,54})));
  HeatAndMassTransfer.Volumes.SimpleWall_Cylinder wall[nV](
    length=dlengths,
    r_inner={surfaceAreas[i]/(dlengths[i]*2*Modelica.Constants.pi) for i in 1:
        nV},
    redeclare package Material = Material_wall,
    each energyDynamics=energyDynamics_wall,
    T_start=T_wall_start,
    r_outer=ths_wall + wall.r_inner,
    Q_gen=Q_gen,
    each exposeState_a=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-56})));

  HeatAndMassTransfer.Interfaces.HeatPort_Flow port[size(wall, 1)] annotation (
      Placement(transformation(rotation=0, extent={{-10,-110},{10,-90}})));


equation
  connect(boundary.port,convection. port_a)
    annotation (Line(points={{0,16},{0,7}},      color={191,0,0}));
  connect(boundaryT.y,boundary. T_ext)
    annotation (Line(points={{0,43},{0,30}},     color={0,0,127}));
  connect(insulation.port_b,convection. port_b)
    annotation (Line(points={{0,-16},{0,-7}},    color={191,0,0}));
  connect(insulation.port_a,wall. port_b)
    annotation (Line(points={{0,-36},{0,-46}},    color={191,0,0}));
  connect(port, wall.port_a)
    annotation (Line(points={{0,-100},{0,-66}}, color={191,0,0}));
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,60},{-30,76},{30,56},{80,72}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Line(
          points={{-80,0},{-30,16},{30,-4},{80,12}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Line(
          points={{-80,-60},{-30,-44},{30,-64},{80,-48}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Ellipse(
          extent={{40,40},{-40,-40}},
          lineColor={0,0,0},
          fillColor={193,162,50},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{30,30},{-30,-30}},
          lineColor={0,0,0},
          fillColor={168,168,168},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{20,20},{-20,-20}},
          lineColor={0,0,0},
          fillColor={184,35,38},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,100},{-60,60}},
          textColor={0,0,0},
          textString="T")}));
end WallAndInsulationHX;
