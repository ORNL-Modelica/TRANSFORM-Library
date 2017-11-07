within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Examples;
model variableArea_Test2
  import TRANSFORM;
  extends Modelica.Icons.Example;

  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Cylinder_FD
    Winding(
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
        TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Cylindrical.SolutionMethods.NodeCentered_2D,
    nZ=10)
    annotation (Placement(transformation(extent={{-34,-56},{46,34}})));

  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.BoundaryConditions.Convection_constantArea_2DCyl
    convection_top(
    nNodes=Winding.nR,
    alphas=400*ones(Winding.nR),
    isAxial=false,
    r_inner=Winding.r_inner,
    r_outer=Winding.r_outer) annotation (Placement(transformation(
        extent={{-10,-15},{10,15}},
        rotation=90,
        origin={6,59})));

  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.BoundaryConditions.FixedTemperature_FD
    fixedTemperature_FD2(nNodes=Winding.nR, T(displayUnit="K") = 320*ones(
      Winding.nR))
    annotation (Placement(transformation(extent={{-40,74},{-20,94}})));

  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.BoundaryConditions.Adiabatic_FD
    adiabatic_bottom(nNodes=Winding.nR)
    annotation (Placement(transformation(extent={{-26,-80},{-6,-60}})));

  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.BoundaryConditions.Adiabatic_FD
    adiabatic_outer(nNodes=Winding.nZ)
    annotation (Placement(transformation(extent={{88,-21},{68,-1}})));

  Modelica.Blocks.Sources.Constant const[Winding.nR,Winding.nZ](k=6e5*ones(
        Winding.nR, Winding.nZ))
    annotation (Placement(transformation(extent={{-62,20},{-42,40}})));

  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Interfaces.VariableArea
    variableArea(
    surfaceAreas_Fixed=Winding.solutionMethod.A_inner,
    nFixed=Winding.nZ,
    nVar=Winding.nZ,
    surfaceAreas_Var=cat(
            1,
            Area_1.y,
            Area_2.y))
    annotation (Placement(transformation(extent={{-54,-22},{-34,-2}})));
  Modelica.Blocks.Sources.Ramp Area_1[integer(0.5*variableArea.nVar)](
    each height=0.6/(0.5*variableArea.nVar)*2*Modelica.Constants.pi*0.03*0.01,
    each duration=60,
    each offset=0.2/(0.5*variableArea.nVar)*2*Modelica.Constants.pi*0.03*0.01,
    each startTime=5)
    annotation (Placement(transformation(extent={{-88,-108},{-68,-88}})));
  Modelica.Blocks.Math.Add Area_2[integer(0.5*variableArea.nVar)]
    annotation (Placement(transformation(extent={{-88,-68},{-68,-48}})));
  Modelica.Blocks.Sources.Constant const1[integer(0.5*variableArea.nVar)](each k=
        2/(0.5*variableArea.nVar)*Modelica.Constants.pi*0.03*0.01)
    annotation (Placement(transformation(extent={{-140,-62},{-120,-42}})));
  Modelica.Blocks.Math.Product product[integer(0.5*variableArea.nVar)]
    annotation (Placement(transformation(extent={{-98,-84},{-108,-74}})));
  Modelica.Blocks.Sources.Constant const2[integer(0.5*variableArea.nVar)](each k=
        -1.0)
    annotation (Placement(transformation(extent={{-106,-94},{-98,-86}})));
  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.BoundaryConditions.Convection_FD
    convection_var(
    nNodes=variableArea.nVar,
    Areas=cat(
        1,
        Area_1.y,
        Area_2.y),
    alphas=cat(
            1,
            300*ones(integer(0.5*variableArea.nVar)),
            200*ones(integer(0.5*variableArea.nVar))))
    annotation (Placement(transformation(extent={{-70,-22},{-90,-2}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature[
    variableArea.nVar](each T(displayUnit="degC") = 593.15)
    annotation (Placement(transformation(extent={{-128,-20},{-108,0}})));
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
  connect(const1.y, Area_2.u1) annotation (Line(points={{-119,-52},{-100,-52},{
          -90,-52}}, color={0,0,127}));
  connect(Area_1.y,product. u1) annotation (Line(points={{-67,-98},{-62,-98},{
          -62,-76},{-97,-76}},
                    color={0,0,127}));
  connect(const2.y,product. u2) annotation (Line(points={{-97.6,-90},{-92,-90},
          {-92,-82},{-97,-82}},
                        color={0,0,127}));
  connect(product.y,Area_2. u2) annotation (Line(points={{-108.5,-79},{-114,-79},
          {-114,-64},{-90,-64}},
                        color={0,0,127}));
  connect(convection_var.port_a, variableArea.heatPorts_Var) annotation (Line(
        points={{-69,-12},{-61.5,-12},{-54,-12}}, color={127,0,0}));
  connect(convection_var.port_b, fixedTemperature.port) annotation (Line(points=
         {{-91,-12},{-100,-12},{-100,-10},{-108,-10}}, color={127,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=100, __Dymola_NumberOfIntervals=100),
    __Dymola_experimentSetupOutput);
end variableArea_Test2;
