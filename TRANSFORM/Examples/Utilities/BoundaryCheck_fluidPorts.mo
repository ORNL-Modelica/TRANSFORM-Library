within TRANSFORM.Examples.Utilities;
model BoundaryCheck_fluidPorts
  parameter Integer n=1 "Number of comparisons";
  parameter TRANSFORM.Examples.Utilities.Record_fluidPorts[n] port1
    "Fluid port 1";
  parameter TRANSFORM.Examples.Utilities.Record_fluidPorts[n] port2
    "Fluid port 2";
  parameter SI.AbsolutePressure[n] tol_p=fill(Modelica.Constants.eps,n)
    "Tolerance for equality: pressure";
  parameter SI.Temperature[n] tol_T=fill(Modelica.Constants.eps,n)
    "Tolerance for equality: temperature";
  parameter SI.SpecificEnthalpy[n] tol_h=fill(Modelica.Constants.eps,n)
    "Tolerance for equality: specific enthalpy";
  parameter SI.MassFlowRate[n] tol_m_flow=fill(Modelica.Constants.eps,n)
    "Tolerance for equality: mass flow rate";
  BoundaryCheck BCcheck_p(
    n=n,
    x1=port1.p,
    x2=port2.p,
    tol=tol_p)
    annotation (Placement(transformation(extent={{-90,-6},{-70,14}})));
  BoundaryCheck BCcheck_T(
    n=n,
    x1=port1.T,
    x2=port2.T,
    tol=tol_T)
    annotation (Placement(transformation(extent={{-40,-6},{-20,14}})));
  BoundaryCheck BCcheck_h(
    n=n,
    x1=port1.h,
    x2=port2.h,
    tol=tol_h) annotation (Placement(transformation(extent={{20,-6},{40,14}})));
  BoundaryCheck BCcheck_m_flow(
    n=n,
    x1=port1.m_flow,
    x2=port2.m_flow,
    tol=tol_m_flow,
    isFlow=fill(true, n))
    annotation (Placement(transformation(extent={{70,-6},{90,14}})));
  annotation (defaultComponentName="BCcheck",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-300,-100},
            {300,100}}), graphics={
        Rectangle(
          extent={{-300,10},{-180,-90}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-288,-2},{-192,-78}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-254,-10},{-254,-14},{-248,-28},{-242,-48},{-240,-50},{-236,-32},
              {-226,-8},{-216,14},{-204,36},{-192,48},{-186,54},{-186,52},{-186,
              38},{-188,24},{-186,8},{-184,2},{-184,0},{-190,-4},{-200,-14},{-212,
              -32},{-222,-52},{-234,-72},{-240,-88},{-242,-82},{-252,-66},{-266,
              -48},{-278,-38},{-282,-36},{-276,-32},{-264,-20},{-254,-10}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid,
          visible=DynamicSelect(false,if BCcheck_p.passedAll then true else false)),
        Polygon(
          points={{-278,-2},{-288,-12},{-250,-40},{-288,-68},{-278,-78},{-240,-50},
              {-202,-78},{-192,-68},{-230,-40},{-192,-12},{-204,-2},{-240,-30},{
              -278,-2}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          visible=DynamicSelect(false,if not BCcheck_p.passedAll then true else false)),
        Text(
          lineColor={0,0,0},
          extent={{-388,60},{-88,100}},
          textString="p"),
        Rectangle(
          extent={{-140,10},{-20,-90}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-128,-2},{-32,-78}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-94,-10},{-94,-14},{-88,-28},{-82,-48},{-80,-50},{-76,-32},{-66,
              -8},{-56,14},{-44,36},{-32,48},{-26,54},{-26,52},{-26,38},{-28,24},
              {-26,8},{-24,2},{-24,0},{-30,-4},{-40,-14},{-52,-32},{-62,-52},{-74,
              -72},{-80,-88},{-82,-82},{-92,-66},{-106,-48},{-118,-38},{-122,-36},
              {-116,-32},{-104,-20},{-94,-10}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid,
          visible=DynamicSelect(false,if BCcheck_T.passedAll then true else false)),
        Polygon(
          points={{-118,-2},{-128,-12},{-90,-40},{-128,-68},{-118,-78},{-80,-50},
              {-42,-78},{-32,-68},{-70,-40},{-32,-12},{-44,-2},{-80,-30},{-118,-2}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          visible=DynamicSelect(false,if not BCcheck_T.passedAll then true else false)),
        Text(
          lineColor={0,0,0},
          extent={{-228,60},{72,100}},
          textString="T"),
        Rectangle(
          extent={{20,10},{140,-90}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{32,-2},{128,-78}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{66,-10},{66,-14},{72,-28},{78,-48},{80,-50},{84,-32},{94,-8},
              {104,14},{116,36},{128,48},{134,54},{134,52},{134,38},{132,24},{134,
              8},{136,2},{136,0},{130,-4},{120,-14},{108,-32},{98,-52},{86,-72},
              {80,-88},{78,-82},{68,-66},{54,-48},{42,-38},{38,-36},{44,-32},{56,
              -20},{66,-10}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid,
          visible=DynamicSelect(false,if BCcheck_h.passedAll then true else false)),
        Polygon(
          points={{42,-2},{32,-12},{70,-40},{32,-68},{42,-78},{80,-50},{118,-78},
              {128,-68},{90,-40},{128,-12},{116,-2},{80,-30},{42,-2}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          visible=DynamicSelect(false,if not BCcheck_h.passedAll then true else false)),
        Text(
          lineColor={0,0,0},
          extent={{-68,60},{232,100}},
          textString="h"),
        Rectangle(
          extent={{180,10},{300,-90}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{192,-2},{288,-78}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{226,-10},{226,-14},{232,-28},{238,-48},{240,-50},{244,-32},{254,
              -8},{264,14},{276,36},{288,48},{294,54},{294,52},{294,38},{292,24},
              {294,8},{296,2},{296,0},{290,-4},{280,-14},{268,-32},{258,-52},{246,
              -72},{240,-88},{238,-82},{228,-66},{214,-48},{202,-38},{198,-36},{
              204,-32},{216,-20},{226,-10}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid,
          visible=DynamicSelect(false,if BCcheck_m_flow.passedAll then true else false)),
        Polygon(
          points={{202,-2},{192,-12},{230,-40},{192,-68},{202,-78},{240,-50},{278,
              -78},{288,-68},{250,-40},{288,-12},{276,-2},{240,-30},{202,-2}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          visible=DynamicSelect(false,if not BCcheck_m_flow.passedAll then true else false)),
        Text(
          lineColor={0,0,0},
          extent={{92,60},{392,100}},
          textString="m_flow"),
        Text(
          lineColor={0,0,255},
          extent={{-140,-140},{160,-100}},
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})));
end BoundaryCheck_fluidPorts;
