within TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics;
function PumpTripCoastdown
  input Real x "Initial flow rate";
  input SI.Time t "Time since pump trip";
  input SI.Time t_half "Time to reach half of initial flow rate";
  output Real y "Flow rate";
algorithm
  y :=x/(1 + t/t_half);

  annotation (Documentation(info="<html>
<p>Sumner, T., Fanning, T. H., &quot;Versatile Test Reactor Pump Coastdown Assessment,&quot; Proceeding of the American Nuclear Society, ANS, November, 2020.</p>
</html>"));
end PumpTripCoastdown;
