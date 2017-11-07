within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Examples;
model Winding
  import TRANSFORM;
  extends Modelica.Icons.Example;

  Cylinder_FD Winding(
    r_inner=0.01,
    r_outer=0.02,
    length=0.03,
    use_q_ppp=true,
    Tref(displayUnit="K") = 320,
    redeclare package Material =
        TRANSFORM.Media.Solids.CustomSolids.Lambda_28_5_d_7990_cp_500,
    rs=linspace(
            Winding.r_inner,
            Winding.r_outer,
            Winding.nR),
    zs=linspace(
            0,
            Winding.length,
            Winding.nZ),
    redeclare model SolutionMethod_FD =
        Cylindrical.SolutionMethods.NodeCentered_2D,
    nR=10,
    nZ=20)
    annotation (Placement(transformation(extent={{-34,-56},{46,34}})));

  BoundaryConditions.Convection_constantArea_2DCyl convection_top(
    nNodes=Winding.nR,
    alphas=400*ones(Winding.nR),
    isAxial=false,
    r_inner=Winding.r_inner,
    r_outer=Winding.r_outer) annotation (Placement(transformation(
        extent={{-10,-15},{10,15}},
        rotation=90,
        origin={6,59})));

  BoundaryConditions.FixedTemperature_FD fixedTemperature_FD2(nNodes=
        Winding.nR, T(displayUnit="K") = 320*ones(Winding.nR))
    annotation (Placement(transformation(extent={{-40,74},{-20,94}})));

  BoundaryConditions.Adiabatic_FD adiabatic_bottom(nNodes=Winding.nR)
    annotation (Placement(transformation(extent={{-26,-80},{-6,-60}})));

  BoundaryConditions.Adiabatic_FD adiabatic_outer(nNodes=Winding.nZ)
    annotation (Placement(transformation(extent={{88,-21},{68,-1}})));

  BoundaryConditions.Convection_constantArea_2DCyl convection_inner(
    nNodes=Winding.nZ,
    alphas=400*ones(Winding.nZ),
    isInner=true,
    r_inner=Winding.r_inner,
    r_outer=Winding.r_outer,
    length=Winding.length)
    annotation (Placement(transformation(extent={{-36,-22},{-56,-2}})));

  BoundaryConditions.FixedTemperature_FD fixedTemperature_FD(nNodes=Winding.nZ,
      T(displayUnit="K") = 320*ones(Winding.nZ))
    annotation (Placement(transformation(extent={{-90,-22},{-70,-2}})));

  Modelica.Blocks.Sources.Constant const[Winding.nR,Winding.nZ](k=6e5*ones(
        Winding.nR, Winding.nZ))
    annotation (Placement(transformation(extent={{-62,20},{-42,40}})));

  Utilities.Visualizers.displayReal display(use_port=true)
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));
  Modelica.Blocks.Sources.RealExpression T_max(y=
        TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC(max(
        Winding.solutionMethod.Ts)))
    annotation (Placement(transformation(extent={{32,-86},{48,-74}})));
equation
  connect(convection_top.port_a, Winding.heatPorts_top)
    annotation (Line(points={{6,48},{6,16.45}}, color={127,0,0}));
  connect(fixedTemperature_FD2.port,convection_top. port_b)
    annotation (Line(points={{-20,84},{6,84},{6,70}}, color={191,0,0}));
  connect(Winding.heatPorts_outer, adiabatic_outer.port) annotation (Line(
        points={{29.6,-11},{29.6,-11},{68,-11}}, color={127,0,0}));
  connect(adiabatic_bottom.port, Winding.heatPorts_bottom)
    annotation (Line(points={{-6,-70},{6,-70},{6,-37.55}}, color={191,0,0}));
  connect(const.y, Winding.q_ppp_input)
    annotation (Line(points={{-41,30},{-10,7}},     color={0,0,127}));
  connect(convection_inner.port_a, Winding.heatPorts_inner) annotation (Line(
        points={{-35,-12},{-17.6,-12},{-17.6,-11}}, color={127,0,0}));
  connect(convection_inner.port_b, fixedTemperature_FD.port) annotation (Line(
        points={{-57,-12},{-63.5,-12},{-70,-12}}, color={127,0,0}));
  connect(T_max.y, display.u)
    annotation (Line(points={{48.8,-80},{58.5,-80}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=100, __Dymola_NumberOfIntervals=100),
    __Dymola_experimentSetupOutput);
end Winding;
