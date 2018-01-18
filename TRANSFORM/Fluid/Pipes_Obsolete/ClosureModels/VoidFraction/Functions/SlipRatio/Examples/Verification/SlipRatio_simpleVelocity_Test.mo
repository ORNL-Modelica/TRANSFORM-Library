within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.VoidFraction.Functions.SlipRatio.Examples.Verification;
model SlipRatio_simpleVelocity_Test
  extends Modelica.Icons.Example;

  constant Integer n = 10 "Number of data points";
  constant SI.Velocity v_l = 1.0 "Liquid velocity";
  constant SI.Velocity[n] v_v = linspace(0,100*v_l,n) "Vapor velocity";

  Units.NonDim[n] S "Void fraction";
equation
  for i in 1:n loop
    S[i] =S_simpleVelocity(v_l, v_v[i]);
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(__Dymola_NumberOfIntervals=1),
    Documentation(info="<html>
<p>The ratio of the velocities of different phases.</p>
<p>Velocity of the vapor divided by the velocity of the liquid.</p>
<ul>
<li> S = v_v/v_l;</li>
</ul>
</html>"));
end SlipRatio_simpleVelocity_Test;
