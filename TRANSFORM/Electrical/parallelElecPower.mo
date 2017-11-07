within TRANSFORM.Electrical;
model parallelElecPower
  "Scale electrical power: simulates parallel flow streams"

  parameter Real nParallel = 1 "port_a.W is divided into nParallel flow streams";

  TRANSFORM.Electrical.Interfaces.ElectricalPowerPort_Flow singleFlow
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  TRANSFORM.Electrical.Interfaces.ElectricalPowerPort_Flow parallelFlow
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-10},{110,10}})));
equation
  // mass balance
  0 =singleFlow.W + parallelFlow.W*nParallel;

  // frequency equation
  singleFlow.f =parallelFlow.f;

  annotation (defaultComponentName="nFlow",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(
            extent={{-100,-100},{100,100}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/nParallel_ElecPower.jpg"),
        Text(
          extent={{-145,-68},{155,-108}},
          lineColor={0,0,0},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end parallelElecPower;
