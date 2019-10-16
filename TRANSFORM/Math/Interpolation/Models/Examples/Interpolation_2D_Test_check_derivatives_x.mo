within TRANSFORM.Math.Interpolation.Models.Examples;
model Interpolation_2D_Test_check_derivatives_x
  extends TRANSFORM.Icons.Example;
  Math.Interpolation.Models.Interpolation_2D lookupTables_2D(
    tablePath_u1=Modelica.Utilities.Files.loadResource("modelica://TRANSFORM/Resources/data/lookupTables/TestFiles/x.csv"),
    tablePath_u2=Modelica.Utilities.Files.loadResource("modelica://TRANSFORM/Resources/data/lookupTables/TestFiles/y.csv"),
    tablePath_y=Modelica.Utilities.Files.loadResource("modelica://TRANSFORM/Resources/data/lookupTables/TestFiles/z.csv"))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Ramp     ramp(
    height=1e6,
    duration=1,
    offset=102341.14021054539)
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Blocks.Sources.Constant
                               const1(k=1000)
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

Real dy;
equation
  dy = der(lookupTables_2D.y);

  connect(ramp.y, lookupTables_2D.u1) annotation (Line(points={{-39,20},{-26,20},
          {-26,6},{-12,6}}, color={0,0,127}));
  connect(const1.y, lookupTables_2D.u2) annotation (Line(points={{-39,-20},{-26,
          -20},{-26,-6},{-12,-6}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Interpolation_2D_Test_check_derivatives_x;
