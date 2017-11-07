within TRANSFORM.HeatExchangers.BellDelaware_STHX.BaseClasses.HeatTransfer;
model BellDelaware
  "BellDelaware: Single phase (oil/water)  correlation for flow in the shell side of a STHX"

  extends
    TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.PartialHeatTransfer_setT;

  import Modelica.Math.exp;
  import Modelica.Constants.pi;

  parameter Boolean isGas = false "true if Medium is a gas";
  parameter Real np = 0
    "Gas specific exponential correction factor (e.g., air = 0; N2 = 0.12)";

  parameter Boolean toggleEndChannel = false
    "=true for end channel; false for center channel";

  parameter Boolean toggleStaggered = true
    "true = staggered grid type; false = in-line";

  parameter SI.Length d_B "Diameter of holes in baffles";
  parameter SI.Length d_o "Outer diameter of tubes";

  parameter SI.Length D_i "Inside shell diameter";
  parameter SI.Length D_l "Baffle Diameter";
  parameter SI.Length DB "Tube bundle diameter";

  parameter SI.Length H "Height of baffle cut";
  parameter SI.Length s1 "Tube to tube pitch parallel to baffel edge";
  parameter SI.Length s2 "Tube to tube pitch perpindicular to baffel edge";
  parameter SI.Length S "Baffle spacing between baffles";
  parameter SI.Length S_E
    "Baffle spacing between the heat exchanger sheets and adjacent baffles";
  parameter SI.Length e1 "Space between tubes and shell";

  parameter Real nes "# of shortest connections connecting neighboring tubes";
  parameter Real n_W "# of tubes in both the upper and lower window";
  parameter Real n_T "Total # of tubes (including blind and support)";
  parameter Real n_MR "# of  main resistances in cross flow path";
  parameter Real n_s "# of pairs of sealing strips";

  Real a = s1/d_o;
  Real b = s2/d_o;
  Real c = ((a/2)^2 + b^2)^(0.5);

  SI.Length e = (if toggleStaggered then
                    (if b >= 0.5*(2*a+1)^(0.5) then (a - 1)*d_o else (c - 1)*d_o)
                 else (a - 1)*d_o);

  SI.Length L_E = 2*e1 + e*nes;
  SI.Area A_E = if toggleEndChannel then S*L_E else S_E*L_E;
  SI.Area   A_f = if toggleEndChannel then D_i*S_E else D_i*S;

  SI.Area A_B = if e<(D_i-DB) then S*(D_i-DB-e) else 0;

  Real R_B = A_B/A_E;
  Real R_S = n_s/n_MR;

  SI.ReynoldsNumber[nHT] Res_psil;
  Real[nHT] beta;
  Real[nHT] f_B;
  Real[nHT] f_w;
  Real[nHT] f_P;
  Real[nHT] Prs_w;
  SI.NusseltNumber[nHT] Nus_llam;
  SI.NusseltNumber[nHT] Nus_lturb;
  SI.NusseltNumber[nHT] Nus_l0;
  SI.NusseltNumber[nHT] Nus_bundle0;
  SI.NusseltNumber[nHT] Nus_bundle;

  Real gamma = 2*Modelica.Math.acos(1 - 2*H/D_l)*180/pi;

  SI.Area A_GTB = (n_T-n_W/2)*pi*(d_B^2-d_o^2)/4;
  SI.Area A_GSB = pi/4*(D_i^2-D_l^2)*(360-gamma)/360;
  SI.Area A_SG = A_GTB + A_GSB;
  Real R_L = A_SG/A_E;
  Real R_G = n_W/n_T;

  Real f_L = if A_SG < 1e-6 then 1 else 0.4*A_GTB/A_SG + (1-0.4*A_GTB/A_SG)*exp(-1.5*R_L);
  Real f_G = 1-R_G+0.524*R_G^(0.32);
  Real psi = if b >= 1 then 1-pi/(4*a) else 1-pi/(4*a*b);
  Real f_A = if toggleStaggered then 1+2/(3*b) else 1+0.7*(b/a-0.3)/(psi^(1.5)*(b/a+0.7)^2);
  Real f_N = 1;

  SI.Length ll = pi/2*d_o;
  SI.Velocity[nHT] w;
  Medium.ThermodynamicState[nHT] states_w;
  SI.Pressure[nHT] Ps = Medium.pressure(states);
equation

for i in 1:nHT loop

  w[i] = abs(m_flows[i])/(ds[i]*A_f);

  states_w[i] = Medium.setState_pTX(Ps[i],heatPorts[i].T);
  Prs_w[i] = Medium.prandtlNumber(states_w[i]);

  Res_psil[i] = ds[i]*ll*w[i]/(psi*mus[i]);

  beta[i] = noEvent(if Res_psil[i] < 100 then 1.5 else 1.35);
  f_B[i] = if R_S < 0.5 then exp(-beta[i]*R_B*(1 - (2*R_S)^(1/3))) else 1;

  f_w[i] = f_L*f_G*f_B[i];

  if not isGas then
  f_P[i] = if Prs[i]/Prs_w[i] > 1.0 then (Prs[i]/Prs_w[i])^(0.25) else (Prs[i]/Prs_w[i])^(0.11);
  else
  f_P[i] = (Ts[i]/heatPorts[i].T)^np;
  end if;

  Nus_llam[i] = 0.664*Res_psil[i]^(0.5)*Prs[i]^(1/3);
  Nus_lturb[i] = noEvent(if Res_psil[i] < 0.001 then 0 else 0.037*Res_psil[i]^(0.8)*Prs[i]/(1+2.443*Res_psil[i]^(-0.1)*(Prs[i]^(2/3)-1)));
  Nus_l0[i] = 0.3 + (Nus_llam[i]^2 + Nus_lturb[i]^2)^(0.5);

  Nus_bundle0[i] = f_A*Nus_l0[i];

  Nus_bundle[i] = f_N*f_P[i]*Nus_bundle0[i];

  Nus[i] = f_w[i]*Nus_bundle[i];

  alphas[i] = TRANSFORM.Utilities.CharacteristicNumbers.HeatTransferCoeffient(
      Nu=Nus[i],
      D=ll,
      lambda=lambdas[i]);
end for;
  annotation (Documentation(info="<html>
<p>The Lyon-Martinelli heat transfer correlation is for flow of liquid metal in circular tubes with contant heat flux along the tube wall.</p>
<p>The correlation was taken from the following textbook:</p>
<p style=\"margin-left: 30px;\">M.&nbsp;M.&nbsp;Wakil</p>
<p style=\"margin-left: 30px;\">Nuclear&nbsp;Heat&nbsp;Transport&nbsp;1993</p>
<p style=\"margin-left: 30px;\">eq.&nbsp;10-2&nbsp;pg.&nbsp;268</p>
<p>and is reported valid for:</p>
<ul>
<li>liquid metal coolant</li>
<li>flow in circular tubes</li>
<li>constant heat flux along tube wall</li>
</ul>
</html>"));
end BellDelaware;
