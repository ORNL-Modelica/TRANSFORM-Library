within TRANSFORM.HeatAndMassTransfer.Examples.ExamplesFrom_NellisAndKlein;
model ConveyorBeltDesign "Example 3.1-1 Design of a conveyor belt pp. 307-309"
  extends Icons.Example;
  Modelica.Blocks.Sources.Constant L(each k=
        Units.Conversions.Functions.Distance_m.from_ft(15)) "conveyor length"
    annotation (Placement(transformation(extent={{-100,84},{-92,92}})));
  Modelica.Blocks.Sources.Constant D(each k=0.1) "diameter"
    annotation (Placement(transformation(extent={{-100,70},{-92,78}})));
  Modelica.Blocks.Sources.Constant alpha(each k=15) "heat transfer coefficient"
    annotation (Placement(transformation(extent={{-54,84},{-46,92}})));
  Modelica.Blocks.Sources.Constant th(each k=0.002) "thickness"
    annotation (Placement(transformation(extent={{-100,56},{-92,64}})));
  Utilities.CharacteristicNumbers.Models.BiotNumber biotNumber(
    alpha=alpha.y,
    L=V.y/As.y,
    lambda=lambda.y)
    annotation (Placement(transformation(extent={{-72,2},{-52,22}})));
  Modelica.Blocks.Sources.RealExpression V(y=Modelica.Constants.pi*0.25*D.y^2*
        th.y) "volume"
    annotation (Placement(transformation(extent={{-40,78},{-20,98}})));
  Modelica.Blocks.Sources.RealExpression As(y=Modelica.Constants.pi*0.25*D.y^2)
    "surface area for heat transfer: ignoring edge"
    annotation (Placement(transformation(extent={{-40,62},{-20,82}})));
  Modelica.Blocks.Sources.Constant lambda(each k=0.35) "thermal conductivity"
    annotation (Placement(transformation(extent={{-68,84},{-60,92}})));
  Modelica.Blocks.Sources.Constant d(each k=1100) "density"
    annotation (Placement(transformation(extent={{-68,70},{-60,78}})));
  Modelica.Blocks.Sources.Constant cp(each k=1900) "heat capacity"
    annotation (Placement(transformation(extent={{-68,56},{-60,64}})));
  Utilities.Visualizers.displayReal display_tau_lumped(use_port=true)
    annotation (Placement(transformation(extent={{-42,-20},{-22,0}})));
  Utilities.Visualizers.displayReal display_biot(use_port=true)
    annotation (Placement(transformation(extent={{-42,2},{-22,22}})));
  Volumes.UnitVolume plasticDisk(
    V=V.y,
    d=d.y,
    cp=cp.y,
    T_start=Tini.k,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{10,-20},{30,-40}})));
  Resistances.Heat.Convection convection(alpha=alpha.y, surfaceArea=As.y)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={20,0})));
  BoundaryConditions.Heat.Temperature boundary(use_port=true) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,30})));
  Modelica.Blocks.Sources.RealExpression T(y=plasticDisk.T) "disk temperature"
    annotation (Placement(transformation(extent={{-82,-70},{-62,-50}})));
  Blocks.TimerTotal             timer
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(threshold=
       Tmax.k)
    annotation (Placement(transformation(extent={{-46,-70},{-26,-50}})));
  Utilities.Visualizers.displayReal display_time(use_port=true)
    "stops changing when T < T_max"
    annotation (Placement(transformation(extent={{28,-70},{48,-50}})));
  Modelica.Blocks.Sources.RealExpression uc(y=L.y/max(0.0001, timer.y))
    "conveyor velocity"
    annotation (Placement(transformation(extent={{-24,-98},{-4,-78}})));
  Utilities.Visualizers.displayReal display_u(use_port=true, precision=4)
    "stops changing when T < T_max"
    annotation (Placement(transformation(extent={{4,-98},{24,-78}})));
  Modelica.Blocks.Sources.Constant Tmax(each k=
        Units.Conversions.Functions.Temperature_K.from_degC(80))
    "maximum acceptable disk temperature"
    annotation (Placement(transformation(extent={{-84,56},{-76,64}})));
  Modelica.Blocks.Sources.Constant Tinf(k=
        Units.Conversions.Functions.Temperature_K.from_degC(20))
    "ambient temperature"
    annotation (Placement(transformation(extent={{-84,70},{-76,78}})));
  Modelica.Blocks.Sources.Constant Tini(each k=
        Units.Conversions.Functions.Temperature_K.from_degC(180))
    "initial plastic disk temperature"
    annotation (Placement(transformation(extent={{-84,84},{-76,92}})));
  Utilities.CharacteristicNumbers.Models.LumpedHeatTimeConstant tau_lumped(
    R=1/(alpha.y*As.y),
    d=d.y,
    cp=cp.y,
    V=V.y) annotation (Placement(transformation(extent={{-72,-20},{-52,0}})));
  Modelica.Blocks.Sources.RealExpression T_boundary(y=Tinf.y)
    annotation (Placement(transformation(extent={{48,30},{28,50}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(n=1, x={plasticDisk.T})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(biotNumber.y, display_biot.u)
    annotation (Line(points={{-51,12},{-43.5,12}}, color={0,0,127}));
  connect(boundary.port, convection.port_b)
    annotation (Line(points={{20,20},{20,7}}, color={191,0,0}));
  connect(convection.port_a, plasticDisk.port)
    annotation (Line(points={{20,-7},{20,-20}},         color={191,0,0}));
  connect(T.y, greaterEqualThreshold.u)
    annotation (Line(points={{-61,-60},{-48,-60}}, color={0,0,127}));
  connect(uc.y, display_u.u)
    annotation (Line(points={{-3,-88},{2.5,-88}}, color={0,0,127}));
  connect(tau_lumped.y, display_tau_lumped.u)
    annotation (Line(points={{-51,-10},{-43.5,-10}}, color={0,0,127}));
  connect(greaterEqualThreshold.y, timer.u)
    annotation (Line(points={{-25,-60},{-12,-60}}, color={255,0,255}));
  connect(timer.y, display_time.u)
    annotation (Line(points={{11,-60},{26.5,-60}}, color={0,0,127}));
  connect(T_boundary.y, boundary.T_ext)
    annotation (Line(points={{27,40},{20,40},{20,34}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{54,-56},{88,-66}},
          lineColor={0,0,0},
          textString="Clock indicating time spent
above required temperature [s]"),
                              Text(
          extent={{30,-84},{64,-94}},
          lineColor={0,0,0},
          textString="Velocity of conveyor belt required to
give enough time for the plastic disk
to cool from Tini to Tmax [m/s]")}),
    experiment(StopTime=500));
end ConveyorBeltDesign;
