within TRANSFORM.Examples.MoltenSaltReactor.Components.Examples;
model DRACS_Test
  "Standalone DRACS driven by a fixed 2 MW heat input at the drain tank thimble wall"
  extends TRANSFORM.Icons.Example;
  TRANSFORM.Examples.MoltenSaltReactor.Components.DRACS DRACS
    annotation (Placement(transformation(extent={{-40,-20},{0,20}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow q1(Q_flow=2e6)
    annotation (Placement(transformation(extent={{50,0},{30,20}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow q2(Q_flow=0)
    annotation (Placement(transformation(extent={{50,-40},{30,-20}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=5, x={DRACS.riser_DRACS.port_a.m_flow,
        DRACS.thimble_outer_drainTank.material.T,DRACS.thimbles_drainTank_fluid.mediums[1].T,
        DRACS.waterTank.state_liquid.T,DRACS.waterTank.port_a.m_flow})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(q1.port, DRACS.port_thimbleWall[1]) annotation (Line(points={{30,10},
          {10,10},{10,-12},{0,-12}}, color={191,0,0}));
  connect(q2.port, DRACS.port_thimbleWall[2]) annotation (Line(points={{30,-30},
          {10,-30},{10,-12},{0,-12}}, color={191,0,0}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=4000, __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<p>Unit test for <a href=\"modelica://TRANSFORM.Examples.MoltenSaltReactor.Components.DRACS\">DRACS</a> on its own,
outside the full plant model. A fixed heat flow of 2 MW, about what the full
<a href=\"modelica://TRANSFORM.Examples.MoltenSaltReactor.MSDR_noBOP\">MSDR_noBOP</a> plant delivers to the DRACS,
enters the first thimble wall port (<code>q1</code>); the second port (<code>q2</code>) receives no heat.
The test tracks the natural circulation flow in the riser, the thimble wall and NaK temperatures, and the
water tank temperature and flow.</p>
</html>"));
end DRACS_Test;
