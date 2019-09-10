within TRANSFORM.Examples.GenericModular_PWR.Examples;
model Test2
  extends Modelica.Icons.Example;
  GenericModule_standAlone PHS
    annotation (Placement(transformation(extent={{-40,-42},{40,38}})));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(
      StopTime=1000,
      __Dymola_NumberOfIntervals=1000,
      __Dymola_Algorithm="Esdirk45a"),
    __Dymola_experimentSetupOutput);
end Test2;
