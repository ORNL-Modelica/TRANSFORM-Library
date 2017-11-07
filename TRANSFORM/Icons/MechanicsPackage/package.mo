within TRANSFORM.Icons;
package MechanicsPackage
  extends TRANSFORM.Icons.Package;

  annotation (Icon(graphics={
      Rectangle(
        origin={10.6,73.3333},
        lineColor={64,64,64},
        fillColor={192,192,192},
        fillPattern=FillPattern.HorizontalCylinder,
        extent={{-4.6,-93.3333},{41.4,-53.3333}}),
      Ellipse(
        origin={11,56},
        extent={{-90.0,-60.0},{-80.0,-50.0}}),
      Line(
        origin={11,56},
        points={{-85.0,-55.0},{-60.0,-21.0}},
        thickness=0.5),
      Ellipse(
        origin={11,56},
        extent={{-65.0,-26.0},{-55.0,-16.0}}),
      Line(
        origin={11,56},
        points={{-60.0,-21.0},{9.0,-55.0}},
        thickness=0.5),
      Ellipse(
        origin={11,56},
        fillPattern=FillPattern.Solid,
        extent={{4.0,-60.0},{14.0,-50.0}}),
      Line(
        origin={11,56},
        points={{-10.0,-26.0},{72.0,-26.0},{72.0,-86.0},{-10.0,-86.0}})}));
end MechanicsPackage;
