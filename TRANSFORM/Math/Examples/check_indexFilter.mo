within TRANSFORM.Math.Examples;
model check_indexFilter
  extends TRANSFORM.Icons.Example;
  parameter Integer source[:] = {1,2,4,8,3};
  parameter Integer target[3] = {3,1,8};
  parameter Boolean contained = true;
   Integer y[size(target,1)];
   Integer y1[size(source,1)-size(target,1)];
     TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=5,x=cat(1,y,y1))
       annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
   y =indexFilter(source, target, contained);
   y1 =indexFilter(source, target, not contained);
  annotation (experiment(StopTime=10),__Dymola_experimentSetupOutput);
end check_indexFilter;
