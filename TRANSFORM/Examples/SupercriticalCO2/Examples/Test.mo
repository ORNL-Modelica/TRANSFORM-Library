within TRANSFORM.Examples.SupercriticalCO2.Examples;
model Test
  extends TRANSFORM.Icons.Example;

  SubSystem_Dummy changeMe
    annotation (Placement(transformation(extent={{-40,-42},{40,38}})));

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(
      StopTime=100,
      __Dymola_NumberOfIntervals=100,
      __Dymola_Algorithm="Esdirk45a"),
    __Dymola_experimentSetupOutput);
end Test;
