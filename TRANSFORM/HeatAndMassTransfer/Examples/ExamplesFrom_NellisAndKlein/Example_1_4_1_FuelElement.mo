within TRANSFORM.HeatAndMassTransfer.Examples.ExamplesFrom_NellisAndKlein;
model Example_1_4_1_FuelElement
  "Part a) Plot the temperature distribution in the fuel and cladding | Figure 2"
  import TRANSFORM;
  extends Icons.Example;
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow Adiabatic(
      Q_flow=0) "Adiabatic boundary condition at sphere center"
    annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature
    T_gas_infinite(T(displayUnit="degC") = 773.15)
    annotation (Placement(transformation(extent={{90,-10},{70,10}})));
  DiscritizedModels.Conduction_1D fuel(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Sphere_1D_r (
          r_outer=r_fuel.y, nR=nNodes_1_fuel.k),
    redeclare package Material =
        TRANSFORM.Media.Solids.CustomSolids.Lambda_1_d_7990_cp_500,
    redeclare model InternalHeatModel =
        DiscritizedModels.BaseClasses.Dimensions_1.VolumetricHeatGeneration (
          q_ppps={q_ppp0.y*Modelica.Math.exp(-1*fuel.geometry.rs[i]/r_fuel.y)
            for i in 1:nNodes_1_fuel.k}))
    annotation (Placement(transformation(extent={{-38,-10},{-18,10}})));
  Modelica.Blocks.Sources.Constant r_fuel(each k=0.05) "radius of fuel"
    annotation (Placement(transformation(extent={{-100,70},{-92,78}})));
  Modelica.Blocks.Sources.IntegerConstant nNodes_1_fuel(k=50)
    annotation (Placement(transformation(extent={{-100,84},{-92,92}})));
  DiscritizedModels.Conduction_1D clad(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Sphere_1D_r (
        nR=nNodes_1_clad.k,
        r_inner=r_fuel.y,
        r_outer=r_clad.y),
    exposeState_b1=false,
    redeclare package Material =
        TRANSFORM.Media.Solids.CustomSolids.Lambda_300_d_7990_cp_500)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.IntegerConstant nNodes_1_clad(k=10)
    annotation (Placement(transformation(extent={{-86,84},{-78,92}})));
  UserInteraction.Outputs.SpatialPlot FuelCladTemperature(
    x=TRANSFORM.Units.Conversions.Functions.Distance_m.to_cm(cat(
        1,
        {0},
        fuel.geometry.rs,
        clad.geometry.rs,
        {r_clad.y})),
    maxX=7,
    minY=520,
    maxY=660,
    y=TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC(cat(
        1,
        {Adiabatic.port.T},
        fuel.materials.T,
        clad.materials.T,
        {convection.port_a.T})))
    "X - Axial Location (cm) | T - Temperature (C)"
    annotation (Placement(transformation(extent={{4,-78},{58,-24}})));
  Modelica.Blocks.Sources.Constant q_ppp0(k=5e5)
    "Center volumetric heat generation"
    annotation (Placement(transformation(extent={{-100,42},{-92,50}})));
  Modelica.Blocks.Sources.Constant r_clad(each k=0.07)
    "radius of cladding"
    annotation (Placement(transformation(extent={{-100,56},{-92,64}})));
  Resistances.Heat.Convection convection(alpha=100, surfaceArea=clad.geometry.crossAreas_1
        [end]) annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  UserInteraction.Outputs.SpatialPlot FuelTemperature(
    minY=520,
    maxY=660,
    x=TRANSFORM.Units.Conversions.Functions.Distance_m.to_cm(cat(
        1,
        {0},
        fuel.geometry.rs,
        {r_fuel.y})),
    maxX=5,
    y=TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC(cat(
        1,
        {Adiabatic.port.T},
        fuel.materials.T,
        {clad.port_a1.T}))) "X - Axial Location (cm) | T - Temperature (C)"
    annotation (Placement(transformation(extent={{-58,-78},{-4,-24}})));
  Utilities.Visualizers.displayReal display(val=
        TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC(max(fuel.materials.T)))
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=3, x={Adiabatic.port.T,
        fuel.materials[25].T,clad.materials[5].T})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(convection.port_b, T_gas_infinite.port)
    annotation (Line(points={{47,0},{70,0}}, color={191,0,0}));
  connect(Adiabatic.port, fuel.port_a1)
    annotation (Line(points={{-68,0},{-53,0},{-38,0}}, color={191,0,0}));
  connect(fuel.port_b1, clad.port_a1)
    annotation (Line(points={{-18,0},{-18,0},{0,0}},color={191,0,0}));
  connect(clad.port_b1, convection.port_a)
    annotation (Line(points={{20,0},{33,0}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Text(
          extent={{-84,-36},{-56,-42}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textString="Fuel T_max C")}),
    experiment(__Dymola_NumberOfIntervals=100),
    Documentation(info="<html>
</html>"));
end Example_1_4_1_FuelElement;
