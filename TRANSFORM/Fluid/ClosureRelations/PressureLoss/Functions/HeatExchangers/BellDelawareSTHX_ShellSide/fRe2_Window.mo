within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.HeatExchangers.BellDelawareSTHX_ShellSide;
function fRe2_Window

  input Boolean toggleStaggered "true = staggered grid type; false = in-line";
  input SI.Length d_B "Diameter of holes in baffles";
  input SI.Length d_o "Outer diameter of tubes";

  input SI.Length D_i "Inside shell diameter";
  input SI.Length D_l "Baffle Diameter";

  input SI.Length H "Height of baffle cut";
  input SI.Length s1 "Tube to tube pitch parallel to baffel edge";
  input SI.Length s2 "Tube to tube pitch perpindicular to baffel edge";
  input SI.Length S "Baffle spacing between baffles";
  input SI.Length e1 "Space between tubes and shell";

  input Real nes "# of shortest connections connecting neighboring tubes";
  input Real n_RW "# of tube rows in a window section";
  input Real n_W "# of tubes in both the upper and lower window";
  input Real n_T "Total # of tubes (including blind and support)";

  input SI.DynamicViscosity mu "Upstream dynamic viscosity";
  input SI.DynamicViscosity mu_w "Viscosity of fluid at average wall temperature";
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

  Real gamma = 2*Modelica.Math.acos(1 - 2*H/D_l)*180/pi;

  Real n_MRWtemp = 0.8*H/s2;
  Real n_MRW = if n_MRWtemp > 2*n_RW then 2*n_RW else n_MRWtemp;

  SI.Area A_WT = pi/4*D_i^2*gamma/360 - (D_l-2*H)*D_l/4*Modelica.Math.sin(gamma/2*pi/180);
  SI.Area A_T = pi/4*d_o^2*n_W/2;
  SI.Area A_W = A_WT-A_T;

  SI.Length U_W = pi*D_i*gamma/360+pi*d_o*n_W/2;
  SI.Length d_g = 4*A_W/U_W;

  Real f_L=
    Internal.f_L_baffact(
      gamma,
      D_l,
      D_i,
      d_B,
      d_o,
      n_T,
      n_W,
      A_E);

  Real f_zL;
  Real f_zt;
  Real f_z;
  Real f_lam;
  Real f_turb;

  SI.ReynoldsNumber Re "Reynolds number";

algorithm

  Re := d_o*abs(m_flow)/(mu*sqrt(A_E*A_W));

  (f_zL,f_zt) :=
    Internal.f_LeakFactors(
    Re,
    a,
    b,
    mu,
    mu_w);

  f_z :=if Re < 100 then f_zL else f_zt;

  f_lam :=56*d_o/(e*Re)*n_MRW + 52*d_o/(d_g*Re)*(S/d_g) + 2;
  f_turb :=0.6*n_MRW + 2;

  fRe2 := Re*Re*sqrt(f_lam*f_lam+f_turb*f_turb)*f_z*f_L;

end fRe2_Window;
