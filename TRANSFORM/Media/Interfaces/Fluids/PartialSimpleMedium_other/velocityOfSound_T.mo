within TRANSFORM.Media.Interfaces.Fluids.PartialSimpleMedium_other;
function velocityOfSound_T
  input Temperature T "Temperature";
  output VelocityOfSound a "Velocity of sound";
algorithm
  a := a_T_coef[1]*T + a_T_coef[2];
  annotation (Inline=true, derivative=velocityOfSound_T_der);
end velocityOfSound_T;
