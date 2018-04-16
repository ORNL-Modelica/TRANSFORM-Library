within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.SinglePhase.LaminarTurbulent_MSLDetailed;
function dp_DP "calculate pressure loss"

  import Modelica.Constants.pi;
  import Modelica.Math;

  extends Modelica.Icons.Function;

  //input records
  input dp_IN_con IN_con "Input record for function dp_overall_DP"
    annotation (Dialog(group="Constant inputs"));
  input dp_IN_var IN_var "Input record for function dp_overall_DP"
    annotation (Dialog(group="Variable inputs"));
  input SI.MassFlowRate m_flow "Mass flow rate"
    annotation (Dialog(group="Input"));
  input SI.MassFlowRate m_flow_small=0.01
    "Regularization of zero flow if |m_flow| < m_flow_small (dummy if use_m_flow_small = false)";

  //Outputs
  output SI.Pressure DP "Output for function dp_overall_DP";

protected
  Real diameter = 0.5*(IN_con.diameter_a+IN_con.diameter_b) "Average diameter";
  Real crossArea = 0.5*(IN_con.crossArea_a+IN_con.crossArea_b)
    "Average cross area";
  Real roughness = 0.5*(IN_con.roughness_a+IN_con.roughness_b)
    "Average height of surface asperities";

  Real Delta = roughness/diameter "Relative roughness";
  SI.ReynoldsNumber Re1=min(745*Math.exp(if Delta <= 0.0065
       then 1 else 0.0065/Delta), IN_con.Re_turbulent)
    "Re leaving laminar curve";
  SI.ReynoldsNumber Re2=IN_con.Re_turbulent "Re entering turbulent curve";
  SI.DynamicViscosity mu "Upstream viscosity";
  SI.Density rho "Upstream density";
  SI.ReynoldsNumber Re "Reynolds number";
  Real lambda2 "Modified friction coefficient (= lambda*Re^2)";

  function interpolateInRegion2
     input SI.ReynoldsNumber Re;
     input SI.ReynoldsNumber Re1;
     input SI.ReynoldsNumber Re2;
     input Real Delta;
     output Real lambda2;
    // point lg(lambda2(Re1)) with derivative at lg(Re1)
  protected
    Real x1 = Math.log10(Re1);
    Real y1 = Math.log10(64*Re1);
    Real yd1=1;

    // Point lg(lambda2(Re2)) with derivative at lg(Re2)
    Real aux1=(0.5/Math.log(10))*5.74*0.9;
    Real aux2=Delta/3.7 + 5.74/Re2^0.9;
    Real aux3=Math.log10(aux2);
    Real L2=0.25*(Re2/aux3)^2;
    Real aux4=2.51/sqrt(L2) + 0.27*Delta;
    Real aux5=-2*sqrt(L2)*Math.log10(aux4);
    Real x2 =  Math.log10(Re2);
    Real y2 =  Math.log10(L2);
    Real yd2 = 2 + 4*aux1/(aux2*aux3*(Re2)^0.9);

    // Constants: Cubic polynomial between lg(Re1) and lg(Re2)
    Real diff_x=x2 - x1;
    Real m=(y2 - y1)/diff_x;
    Real c2=(3*m - 2*yd1 - yd2)/diff_x;
    Real c3=(yd1 + yd2 - 2*m)/(diff_x*diff_x);
    Real dx;
  algorithm
     dx := Math.log10(Re/Re1);
     lambda2 := 64*Re1*(Re/Re1)^(1 + dx*(c2 + dx*c3));
     annotation(smoothOrder=1);
  end interpolateInRegion2;
algorithm
  // Determine upstream density and upstream viscosity
  rho     :=if m_flow >= 0 then IN_var.rho_a else IN_var.rho_b;
  mu      :=if m_flow >= 0 then IN_var.mu_a else IN_var.mu_b;

  // Determine Re, lambda2 and pressure drop
  Re := diameter*abs(m_flow)/(crossArea*mu);
  lambda2 := if Re <= Re1 then 64*Re else
            (if Re >= Re2 then 0.25*(Re/Math.log10(Delta/3.7 + 5.74/Re^0.9))^2 else
             interpolateInRegion2(Re, Re1, Re2, Delta));
  DP :=IN_con.length*mu*mu/(2*rho*diameter*diameter*diameter)*
       (if m_flow >= 0 then lambda2 else -lambda2);
          annotation (smoothOrder=1, Documentation(info="<html>

</html>"));
end dp_DP;
