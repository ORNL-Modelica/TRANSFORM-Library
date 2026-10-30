within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.HeatExchangers.BellDelawareSTHX_ShellSide;
function fRe2_EndCross
  input Boolean toggleStaggered "true = staggered grid type; false = in-line";
  input SI.Length d_o "Outer diameter of tubes";
  input SI.Length D_i "Inside shell diameter";
  input SI.Length DB "Tube bundle diameter";
  input SI.Length s1 "Tube to tube pitch parallel to baffel edge";
  input SI.Length s2 "Tube to tube pitch perpindicular to baffel edge";
  input SI.Length S "Baffle spacing between baffles";
  input SI.Length S_E
    "Baffle spacing between the heat exchanger sheets and adjacent baffles";
  input SI.Length e1 "Space between tubes and shell";
  input Real nes "# of shortest connections connecting neighboring tubes";
  input Real n_MR "# of  main resistances in cross flow path";
  input Real n_MRE "# of main resistances in end cross flow path";
  input Real n_s "# of pairs of sealing strips";
  input SI.DynamicViscosity mu "Upstream dynamic viscosity";
  input SI.DynamicViscosity mu_w "Dynamic viscosity of fluid at average wall temperature";
  input SI.MassFlowRate m_flow "Mass flow rate";
  output Units.NonDim fRe2 "Modified friction coefficient (= f*Re^2)";
protected
  Real a = s1/d_o;
  Real b = s2/d_o;
  Real c = ((a/2)^2 + b^2)^(0.5);
  SI.Length e = (if toggleStaggered then
                  (if b >= 0.5*(2*a+1)^(0.5) then (a - 1)*d_o else (c - 1)*d_o)
               else (a - 1)*d_o);
  SI.Length L_E = 2*e1 + e*nes;
  SI.Area A_E = S*L_E;
  SI.Area A_B = if e<(D_i-DB) then S*(D_i-DB-e) else 0;
  Real R_B = A_B/A_E;
  Real R_S = n_s/n_MR;
  Real beta;
  Real f_B;
  Real f_zL;
  Real f_zt;
  Real epsilon;
  SI.ReynoldsNumber Re "Reynolds number";
algorithm
  Re := d_o*abs(m_flow)/(mu*A_E)*(S/S_E);
  beta :=if Re < 100 then 4.5 else 3.7;
  if R_S == 0 then
    f_B :=exp(-beta*R_B);
  elseif R_S < 0.5 then
    f_B := exp(-beta*R_B*(1 - (2*R_S)^(1/3)));
  else
    f_B := 1;
  end if;
  (f_zL,f_zt) :=
    Internal.f_LeakFactors(
      Re,
      a,
      b,
      mu,
      mu_w);
  (epsilon) :=
    Internal.DragCoeff(
      toggleStaggered,
      Re,
      a,
      b,
      c,
      f_zL,
      f_zt);
  fRe2 := Re*Re*epsilon*n_MRE*f_B;
end fRe2_EndCross;
