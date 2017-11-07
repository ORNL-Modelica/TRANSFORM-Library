within TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry;
partial model ConductionIcons

  parameter Integer figure=1 "Index for Icon figure" annotation (choices(
      choice=1 "Plane",
      choice=2 "Cylinder",
      choice=3 "Sphere"));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Bitmap(
          extent={{-100,-100},{100,100}},
          fileName="modelica://TRANSFORM/Resources/Images/Icons/Plane_3D.jpg",
          visible=DynamicSelect(true, if figure == 1 then true else false)),
        Bitmap(
          extent={{-100,-100},{100,100}},
          fileName="modelica://TRANSFORM/Resources/Images/Icons/Cylinder_3Dvertical.jpg",
          visible=DynamicSelect(true, if figure == 2 then true else false)),
        Bitmap(
          extent={{-100,-100},{100,100}},
          fileName="modelica://TRANSFORM/Resources/Images/Icons/Sphere_3D.jpg",
          visible=DynamicSelect(true, if figure == 3 then true else false))}),
        Diagram(coordinateSystem(preserveAspectRatio=false)));
end ConductionIcons;
