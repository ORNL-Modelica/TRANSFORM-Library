within TRANSFORM.Fluid.Valves.BaseClasses.ValveCharacteristics;
function quadratic "Quadratic characteristic"
  extends baseFun;
algorithm
  rc := pos*pos;
end quadratic;
