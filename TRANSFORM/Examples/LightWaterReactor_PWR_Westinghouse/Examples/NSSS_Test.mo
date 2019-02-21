within TRANSFORM.Examples.LightWaterReactor_PWR_Westinghouse.Examples;
model NSSS_Test
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  SI.SpecificEnthalpy Ts_tube[PHS.steamGenerator.geometry.nV] = PHS.steamGenerator.tube.mediums.T;
  SI.SpecificEnthalpy hs_tube[PHS.steamGenerator.geometry.nV] = PHS.steamGenerator.tube.mediums.h;
  SI.SpecificEnthalpy hs_shell[PHS.steamGenerator.geometry.nV] = PHS.steamGenerator.shell.mediums.h;
  TRANSFORM.Examples.LightWaterReactor_PWR_Westinghouse.NSSS PHS(redeclare
      TRANSFORM.Examples.LightWaterReactor_PWR_Westinghouse.CS_v2 CS)
    annotation (Placement(transformation(extent={{-40,-42},{40,38}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x={PHS.pressurizer.drum2Phase.p,
        PHS.coreSubchannel.kinetics.Q_total})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Fluid.Sources.Boundary_ph sink1(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_p_in=false,
    nPorts=1,
    p=PHS.data.p_shellSide,
    h=PHS.data.h_vsat)
    annotation (Placement(transformation(extent={{69,9},{59,19}})));
  Modelica.Fluid.Sources.Boundary_pT sink2(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_p_in=false,
    nPorts=1,
    T=PHS.data.T_inlet_shell,
    p=PHS.data.p_shellSide - 1e5)
    annotation (Placement(transformation(extent={{69,-23},{59,-13}})));
equation
  connect(PHS.port_b, sink1.ports[1])
    annotation (Line(points={{40,14},{59,14}}, color={0,127,255}));
  connect(sink2.ports[1], PHS.port_a)
    annotation (Line(points={{59,-18},{40,-18}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(
      StopTime=10000,
      __Dymola_NumberOfIntervals=1000,
      __Dymola_Algorithm="Esdirk45a"),
    __Dymola_experimentSetupOutput);
end NSSS_Test;
