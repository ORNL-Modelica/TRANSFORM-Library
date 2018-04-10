within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Examples;
model variableArea_Test3
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;

  Cylinder_FD Winding(
    r_inner=0.01,
    r_outer=0.02,
    length=0.03,
    use_q_ppp=true,
    Tref(displayUnit="K") = 320,
    redeclare package Material =
        TRANSFORM.Media.Solids.CustomSolids.Lambda_28_5_d_7990_cp_500,
    nR=30,
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
    nZ=2) annotation (Placement(transformation(extent={{-34,-56},{46,34}})));

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

  Modelica.Blocks.Sources.Constant const[Winding.nR,Winding.nZ](k=6e5*ones(
        Winding.nR, Winding.nZ))
    annotation (Placement(transformation(extent={{-62,20},{-42,40}})));

  Interfaces.VariableArea variableArea(
    surfaceAreas_Fixed=Winding.solutionMethod.A_inner,
    nVar=2,
    surfaceAreas_Var={Area_1.y,Area_2.y},
    nFixed=Winding.nZ)
    annotation (Placement(transformation(extent={{-54,-22},{-34,-2}})));
  Modelica.Blocks.Sources.Constant
                               Area_1(k=Modelica.Constants.pi*0.03*0.01)
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection_var[
    variableArea.nVar]
    annotation (Placement(transformation(extent={{-70,-22},{-90,-2}})));
  Modelica.Blocks.Sources.RealExpression hA_var[variableArea.nVar](y={Area_1.y*
        1,Area_2.y*1})
    annotation (Placement(transformation(extent={{-116,6},{-96,26}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature[
    variableArea.nVar](each T(displayUnit="degC") = 593.15)
    annotation (Placement(transformation(extent={{-128,-20},{-108,0}})));
  Modelica.Blocks.Sources.Constant
                               Area_2(k=Modelica.Constants.pi*0.03*0.01)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
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
  connect(variableArea.heatPorts_Fixed, Winding.heatPorts_inner) annotation (
      Line(points={{-34,-12},{-17.6,-12},{-17.6,-11}}, color={127,0,0}));
  connect(convection_var.solid, variableArea.heatPorts_Var)
    annotation (Line(points={{-70,-12},{-54,-12}}, color={191,0,0}));
  connect(hA_var.y, convection_var.Gc)
    annotation (Line(points={{-95,16},{-80,16},{-80,-2}}, color={0,0,127}));
  connect(fixedTemperature.port, convection_var.fluid) annotation (Line(points=
          {{-108,-10},{-100,-10},{-100,-12},{-90,-12}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=100, __Dymola_NumberOfIntervals=100),
    __Dymola_experimentSetupOutput);
end variableArea_Test3;
