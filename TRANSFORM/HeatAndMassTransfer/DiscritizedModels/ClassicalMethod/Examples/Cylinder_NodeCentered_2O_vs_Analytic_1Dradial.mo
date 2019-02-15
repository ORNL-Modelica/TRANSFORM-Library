within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Examples;
model Cylinder_NodeCentered_2O_vs_Analytic_1Dradial
  "Cylindrical node centered 2O component vs the 1D radial analytic solution"
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  Utilities.ErrorAnalysis.Errors_AbsRelRMSold summary_Error(
    n=nRadial,
    x_1=cylinder.solutionMethod.Ts[:, 2],
    x_2=T_analytic)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  parameter Integer nRadial = 50 "Radial nodes";
  parameter TRANSFORM.Units.VolumetricHeatGenerationRate q_ppp=1e6
    "Volumetric heat generation";
  parameter SI.Length r_o = 1 "Outer radius of cylinder";
  parameter SI.Temperature T_surface = 373.15 "Surface temperature";
  package Material = TRANSFORM.Media.Solids.SS316 "Material properties";
  SI.Temperature[nRadial] T_analytic "Analytic Temperature";
  SI.Length[nRadial] r = linspace(0,r_o,nRadial) "Radial position";
  Cylinder_FD cylinder(
    use_q_ppp=true,
    redeclare model SolutionMethod_FD =
        Cylindrical.SolutionMethods.NodeCentered_2D,
    r_outer=r_o,
    nR=nRadial,
    Tref(displayUnit="K") = T_surface,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    redeclare package Material = Material,
    length=1) annotation (Placement(transformation(extent={{-40,-56},{40,34}})));
  BoundaryConditions.Adiabatic_FD adiabatic_bottom(nNodes=cylinder.nR)
    annotation (Placement(transformation(extent={{-26,-80},{-6,-60}})));
  Modelica.Blocks.Sources.Constant const[cylinder.nR,cylinder.nZ](k=q_ppp*ones(
        cylinder.nR, cylinder.nZ))
    annotation (Placement(transformation(extent={{-62,20},{-42,40}})));
  BoundaryConditions.Adiabatic_FD adiabatic_centerline(nNodes=cylinder.nZ)
    annotation (Placement(transformation(extent={{-68,-20},{-48,0}})));
  BoundaryConditions.Adiabatic_FD adiabatic_top(nNodes=cylinder.nR)
    annotation (Placement(transformation(extent={{-28,40},{-8,60}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature[
    cylinder.nZ](each T=T_surface)
    annotation (Placement(transformation(extent={{70,-20},{50,0}})));
equation
  for i in 1:nRadial loop
    T_analytic[i] =q_ppp*r_o^2/(4*
      TRANSFORM.Media.Solids.SS316.thermalConductivity_T(T=T_analytic[i]))*(1
       - r[i]^2/r_o^2) + T_surface;
  end for;
  connect(adiabatic_bottom.port, cylinder.heatPorts_bottom)
    annotation (Line(points={{-6,-70},{0,-70},{0,-37.55}}, color={191,0,0}));
  connect(const.y, cylinder.q_ppp_input)
    annotation (Line(points={{-41,30},{-16,7}}, color={0,0,127}));
  connect(adiabatic_centerline.port, cylinder.heatPorts_inner) annotation (Line(
        points={{-48,-10},{-23.6,-10},{-23.6,-11}}, color={191,0,0}));
  connect(adiabatic_top.port, cylinder.heatPorts_top)
    annotation (Line(points={{-8,50},{0,50},{0,16.45}}, color={191,0,0}));
  connect(fixedTemperature.port, cylinder.heatPorts_outer) annotation (Line(
        points={{50,-10},{23.6,-10},{23.6,-11}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(__Dymola_NumberOfIntervals=100),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>Comparison of the Cylindrical node centered 2O solution to the exact 1-D radial conduction solution.</p>
<p><img src=\"modelica://TRANSFORM/Resources/Images/equations/equation-vVDvxiHp.png\" alt=\"T(r) = q_ppp*r_o^2/(4*lambda)*(1-r^2/r_o^2) + T_surface\"/></p>
</html>"));
end Cylinder_NodeCentered_2O_vs_Analytic_1Dradial;
