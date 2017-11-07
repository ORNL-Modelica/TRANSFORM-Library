within TRANSFORM.Media.ExternalMedia.Examples.CoolProp;
model Hydrogen
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  extends ExternalMedia.Test.GenericModels.TestBasePropertiesDynamic(
    redeclare package Medium =
        TRANSFORM.Media.ExternalMedia.CoolProp.Hydrogen,
    Tstart=300,
    hstart=4e5,
    pstart=1e6,
    Kv0=1.00801e-4,
    V=0.1);
equation
  // Inlet equations
  win = 1;
  hin = 5e5;
  // Input variables
  Kv = if time < 50 then Kv0 else Kv0*1.1;
  Q = if time < 1 then 0 else 1e4;
  annotation (experiment(StopTime=80, Tolerance=1e-007),
      experimentSetupOutput(equdistant=false));
end Hydrogen;
