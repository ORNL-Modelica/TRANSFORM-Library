within TRANSFORM.Nuclear.ReactorKinetics.Functions;
function InitialC_powerBased_powerHistory
  "Determines the initial neutron precursor power-based concentration based on a fission-power history"
  extends TRANSFORM.Icons.UnderConstruction;
  // source equations are weird
  // Source: TRACE Manual eq. 9-22

  input SI.Power[:,2] history "Fission power history up to time=0, [t,Q]";
  input TRANSFORM.Units.InverseTime[:] lambdas
    "Decay constants for each precursor group";
  input TRANSFORM.Units.NonDim[size(lambdas,1)] alphas
    "Normalized precursor fractions [betas = alphas*Beta]";
  input TRANSFORM.Units.NonDim Beta
    "Effective delayed neutron fraction";
  input SI.Time Lambda "Prompt neutron generation time";

  output  SI.Power[size(lambdas,1)] Cs_start;
protected
  Integer nT=size(history,1) "# of time history points";
  Integer nI=size(lambdas,1) "# of delayed-neutron precursors groups";

  Real t[nT] = history[:,1] "Time";
  Real Q[nT] = history[:,2] "Power";


  Real[nT-1] b = {(Q[i+1] - Q[i])/(t[i+1]-t[i]) for i in 1:nT-1};
  Real[nT-1] a = {Q[i]/(b[i]*t[i]) for i in 1:nT-1};
algorithm

  for i in 1:nI loop
    Cs_start[i] :=alphas[i]*Beta/(lambdas[i]*Lambda)*sum({a[j]*(1-exp(-lambdas[i]*(t[j+1]-t[j])))+b[j]/lambdas[i]^2*(lambdas[i]*t[j+1]-1-((lambdas[i]*t[j]-1)*exp(-lambdas[i]*(t[j+1]-t[j])))) for j in 1:nT-1});
  end for;

end InitialC_powerBased_powerHistory;
