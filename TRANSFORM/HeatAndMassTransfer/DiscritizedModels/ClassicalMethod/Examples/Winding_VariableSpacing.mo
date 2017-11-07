within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Examples;
model Winding_VariableSpacing
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
    nR=30,
    nZ=40,
    rs={0.01,0.010571429,0.011142857,0.011714286,0.012285714,0.012857143,0.013428571,
        0.014,0.015,0.015176471,0.015352941,0.015529412,0.015705882,0.015882353,
        0.016058824,0.016235294,0.016411765,0.016588235,0.016764706,0.016941176,
        0.017117647,0.017294118,0.017470588,0.017647059,0.017823529,0.018,0.0185,
        0.019,0.0195,0.02},
    zs={0,0.000714286,0.001428571,0.002142857,0.002857143,0.003571429,0.004285714,
        0.005,0.005714286,0.006428571,0.007142857,0.007857143,0.008571429,0.009285714,
        0.01,0.011,0.011473684,0.011947368,0.012421053,0.012894737,0.013368421,
        0.013842105,0.014315789,0.014789474,0.015263158,0.015736842,0.016210526,
        0.016684211,0.017157895,0.017631579,0.018105263,0.018578947,0.019052632,
        0.019526316,0.02,0.021,0.02325,0.0255,0.02775,0.03},
    redeclare model SolutionMethod_FD =
        Cylindrical.SolutionMethods.NodeCentered_2D)
    annotation (Placement(transformation(extent={{-34,-56},{46,34}})));

  BoundaryConditions.Convection_FD convection_top(
    nNodes=Winding.nR,
    alphas=400*ones(Winding.nR),
    Areas={1.82084e-05,3.79556e-05,4.00072e-05,4.20589e-05,4.41105e-05,4.61622e-05,
        4.82138e-05,6.9644e-05,5.46789e-05,1.68276e-05,1.70233e-05,1.7219e-05,
        1.74146e-05,1.76103e-05,1.7806e-05,1.80017e-05,1.81973e-05,1.8393e-05,
        1.85887e-05,1.87843e-05,1.898e-05,1.91757e-05,1.93713e-05,1.9567e-05,
        1.97627e-05,3.84254e-05,5.81195e-05,5.96903e-05,6.12611e-05,3.12196e-05})
    annotation (Placement(transformation(
        extent={{-9.5,-12},{9.5,12}},
        rotation=90,
        origin={6,58.5})));

  BoundaryConditions.FixedTemperature_FD fixedTemperature_FD2(nNodes=
        Winding.nR, T(displayUnit="K") = 320*ones(Winding.nR))
    annotation (Placement(transformation(extent={{-40,74},{-20,94}})));

  BoundaryConditions.Adiabatic_FD adiabatic_bottom(nNodes=Winding.nR)
    annotation (Placement(transformation(extent={{-26,-80},{-6,-60}})));

  BoundaryConditions.Adiabatic_FD adiabatic_outer(nNodes=Winding.nZ)
    annotation (Placement(transformation(extent={{88,-21},{68,-1}})));

  BoundaryConditions.Convection_FD convection_inner(
    nNodes=Winding.nZ,
    Areas={2.24399e-05,4.48799e-05,4.48799e-05,4.48799e-05,4.48799e-05,4.48799e-05,
        4.48799e-05,4.48799e-05,4.48799e-05,4.48799e-05,4.48799e-05,4.48799e-05,
        4.48799e-05,4.48799e-05,5.38559e-05,4.62972e-05,2.97625e-05,2.97625e-05,
        2.97625e-05,2.97625e-05,2.97625e-05,2.97625e-05,2.97625e-05,2.97625e-05,
        2.97625e-05,2.97625e-05,2.97625e-05,2.97625e-05,2.97625e-05,2.97625e-05,
        2.97625e-05,2.97625e-05,2.97625e-05,2.97625e-05,4.62972e-05,0.000102102,
        0.000141372,0.000141372,0.000141372,7.06858e-05},
    alphas=400*ones(Winding.nZ))
    annotation (Placement(transformation(extent={{-36,-22},{-56,-2}})));

  BoundaryConditions.FixedTemperature_FD fixedTemperature_FD(nNodes=Winding.nZ,
      T(displayUnit="K") = 320*ones(Winding.nZ))
    annotation (Placement(transformation(extent={{-90,-22},{-70,-2}})));

  Modelica.Blocks.Sources.Constant const[Winding.nR,Winding.nZ](k=6e5*ones(
        Winding.nR, Winding.nZ))
    annotation (Placement(transformation(extent={{-62,20},{-42,40}})));

equation
  connect(convection_top.port_a, Winding.heatPorts_top)
    annotation (Line(points={{6,48.05},{6,32},{6,16.45}},
                                                color={127,0,0}));
  connect(fixedTemperature_FD2.port,convection_top. port_b)
    annotation (Line(points={{-20,84},{6,84},{6,68.95}},
                                                      color={191,0,0}));
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
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=100, __Dymola_NumberOfIntervals=100),
    __Dymola_experimentSetupOutput);
end Winding_VariableSpacing;
