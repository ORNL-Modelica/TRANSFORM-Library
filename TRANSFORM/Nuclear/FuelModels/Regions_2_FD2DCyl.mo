within TRANSFORM.Nuclear.FuelModels;
model Regions_2_FD2DCyl
  "2D Cylindrical Finite Difference model with two solid media regions"

  parameter Real nParallel=1 "# of parallel components";

  replaceable package Material_1 =
      TRANSFORM.Media.Interfaces.Solids.PartialAlloy
                                              "Region 1 material"
  annotation (choicesAllMatching=true);
  replaceable package Material_2 =
      TRANSFORM.Media.Interfaces.Solids.PartialAlloy
                                              "Region 2 material"
  annotation (choicesAllMatching=true);

  parameter Integer nZ=4 "# of discrete axial volumes";
  parameter Integer nR_1=3 "# nodes in region 1 radial direction";
  parameter Integer nR_2=3 "# nodes in region 2 radial direction";

  input SI.Length length "Length of axial dimension"
    annotation (Dialog(group="Input Variables"));
  input SI.Length zs[nZ]=linspace(
      0.5*length/nZ,
      length*(1 - 0.5/nZ),
      nZ) "Axial positions" annotation (Dialog(group="Input Variables"));
  input SI.Length r_1_inner = 0 "Inner radius of region 1"
    annotation (Dialog(group="Input Variables"));
  input SI.Length r_1_outer = 0.01 "Outer radius of region 1"
    annotation (Dialog(group="Input Variables"));
  input SI.Length r_2_outer = r_1_outer + 0.001 "Outer radius of region 2"
    annotation (Dialog(group="Input Variables"));
  input SI.Length rs_1[nR_1]=linspace(
      r_1_inner,
      r_1_outer,
      nR_1) "Region 1 radial positions"
    annotation (Dialog(group="Input Variables"));
  input SI.Length rs_2[nR_2]=linspace(
      r_1_outer,
      r_2_outer,
      nR_2) "Region 2 radial positions"
    annotation (Dialog(group="Input Variables"));

  /* Assumptions */
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Formulation of energy balances" annotation(Dialog(tab="Advanced",group="Dynamics"));

  /* Initialization */
  parameter SI.Temperature T_start_1=Material_1.T_default
    annotation (Dialog(tab="Initialization"));
  parameter SI.Temperature T_start_2=Material_2.T_default
    annotation (Dialog(tab="Initialization"));
  parameter SI.Temperature Ts_start_1[nR_1,nZ]=fill(
      T_start_1,
      nR_1,
      nZ) annotation (Dialog(tab="Initialization"));
  parameter SI.Temperature Ts_start_2[nR_2,nZ]=[{Ts_start_1[end, :]};
      fill(
      T_start_2,
      nR_2 - 1,
      nZ)] annotation (Dialog(tab="Initialization"));

  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Cylinder_FD
    region_1(
    use_q_ppp=true,
    Tref(displayUnit="K") = T_start_1,
    length=length,
    nR=nR_1,
    nZ=nZ,
    redeclare package Material = Material_1,
    energyDynamics=energyDynamics,
    r_outer=r_1_outer,
    rs=rs_1,
    zs=zs,
    Ts_start=Ts_start_1,
    redeclare model SolutionMethod_FD =
        HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Cylindrical.SolutionMethods.AxVolCentered_2D)
    annotation (Placement(transformation(extent={{-53,-17},{-21,17}})));

  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.BoundaryConditions.Adiabatic_FD
    adiabatic_FD(nNodes=region_1.nR) annotation (Placement(transformation(
        extent={{-5,-4},{5,4}},
        rotation=-90,
        origin={-37,22})));
  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.BoundaryConditions.Adiabatic_FD
    adiabatic_FD1(nNodes=region_1.nR) annotation (Placement(transformation(
        extent={{-5,-4},{5,4}},
        rotation=90,
        origin={-37,-22})));

  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.BoundaryConditions.Adiabatic_FD
    adiabatic_FD6(nNodes=region_1.nZ)
    annotation (Placement(transformation(extent={{-62,-4},{-52,4}})));
  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Interfaces.AxPowTOAxVolHeat
    PtoQConv(
    r_inner=region_1.r_inner,
    r_outer=region_1.r_outer,
    length=region_1.length,
    nR=region_1.nR,
    nZ=region_1.nZ,
    nParallel=nParallel) annotation (Placement(transformation(
        extent={{-15,-13},{15,13}},
        rotation=0,
        origin={-73,30})));
  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Interfaces.ScalePower
    scalePower(nNodes=region_1.nZ, nParallel=nParallel)
    annotation (Placement(transformation(extent={{60,-7},{80,7}})));
  Modelica.Blocks.Interfaces.RealInput           Power_in[size(PtoQConv.Power_in,
    1)] "Input Axial Power Distribution (volume approach)" annotation (
      Placement(transformation(extent={{-140,10},{-100,50}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  Modelica.Fluid.Interfaces.HeatPorts_b heatPorts_b[region_1.nZ]
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={100,0}), iconTransformation(
        extent={{-35,-10},{35,10}},
        rotation=-90,
        origin={102,1})));

  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.BoundaryConditions.Adiabatic_FD
    adiabatic_FD2(nNodes=region_2.nR)
                                     annotation (Placement(transformation(
        extent={{-5,-4},{5,4}},
        rotation=-90,
        origin={-1,22})));
  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Cylinder_FD
    region_2(
    length=length,
    nZ=nZ,
    energyDynamics=energyDynamics,
    zs=zs,
    nR=nR_2,
    r_inner=r_1_outer,
    r_outer=r_2_outer,
    rs=rs_2,
    Tref(displayUnit="K") = T_start_2,
    Ts_start=Ts_start_2,
    redeclare model SolutionMethod_FD =
        HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Cylindrical.SolutionMethods.AxVolCentered_2D,
    use_q_ppp=false,
    redeclare package Material = Material_2)
    annotation (Placement(transformation(extent={{-17,-17},{15,17}})));

  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.BoundaryConditions.Adiabatic_FD
    adiabatic_FD3(nNodes=region_2.nR) annotation (Placement(transformation(
        extent={{-5,-4},{5,4}},
        rotation=90,
        origin={-1,-22})));
equation
  connect(adiabatic_FD6.port, region_1.heatPorts_inner)
    annotation (Line(points={{-52,0},{-46.44,0}}, color={191,0,0}));
  connect(adiabatic_FD.port, region_1.heatPorts_top)
    annotation (Line(points={{-37,17},{-37,10.37}}, color={191,0,0}));
  connect(adiabatic_FD1.port, region_1.heatPorts_bottom)
    annotation (Line(points={{-37,-17},{-37,-10.03}}, color={191,0,0}));
  connect(PtoQConv.q_ppp, region_1.q_ppp_input)
    annotation (Line(points={{-56.5,30},{-43.4,6.8}}, color={0,0,127}));
  connect(Power_in, PtoQConv.Power_in)
    annotation (Line(points={{-120,30},{-91,30}}, color={0,0,127}));
  connect(scalePower.heatPorts_b, heatPorts_b)
    annotation (Line(points={{80,8.88178e-016},{90,8.88178e-016},{90,0},{100,0}},
                                              color={127,0,0}));
  connect(adiabatic_FD2.port, region_2.heatPorts_top)
    annotation (Line(points={{-1,17},{-1,14.5},{-1,10.37}}, color={191,0,0}));
  connect(adiabatic_FD3.port, region_2.heatPorts_bottom) annotation (Line(
        points={{-1,-17},{-1,-13.5},{-1,-10.03}}, color={191,0,0}));
  connect(region_1.heatPorts_outer, region_2.heatPorts_inner)
    annotation (Line(points={{-27.56,0},{-10.44,0}}, color={127,0,0}));
  connect(region_2.heatPorts_outer, scalePower.heatPorts_a)
    annotation (Line(points={{8.44,0},{34.22,0},{60,0}}, color={127,0,0}));
  annotation (defaultComponentName="fuelModel",
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-149,142},{151,102}},
          lineColor={0,0,255},
          textString="%name"),
        Ellipse(
          extent={{-100,100},{100,-100}},
          fillPattern=FillPattern.Solid,
          fillColor={135,135,135},
          pattern=LinePattern.None),
        Ellipse(
          extent={{-90,90},{90,-90}},
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0})}));
end Regions_2_FD2DCyl;
