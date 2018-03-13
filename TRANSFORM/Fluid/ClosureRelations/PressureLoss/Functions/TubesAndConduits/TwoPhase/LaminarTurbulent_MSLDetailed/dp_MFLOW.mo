within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.TwoPhase.LaminarTurbulent_MSLDetailed;
function dp_MFLOW "calculate mass flow rate"

  import Modelica.Constants.pi;
  import Modelica.Math;

  extends Modelica.Icons.Function;

  //input records
  input dp_IN_con IN_con "Input record for function dp_overall_MFLOW"
    annotation (Dialog(group="Constant inputs"));
  input dp_IN_var IN_var "Input record for function dp_overall_MFLOW"
    annotation (Dialog(group="Variable inputs"));
  input SI.Pressure dp "Pressure loss"
    annotation (Dialog(group="Input"));
  input SI.AbsolutePressure dp_small=1
    "Regularization of zero flow if |dp| < dp_small (dummy if use_dp_small = false)";

  //output variables
  output SI.MassFlowRate M_FLOW "Output of function dp_overall_MFLOW";

protected
  Real diameter = 0.5*(IN_con.diameter_a+IN_con.diameter_b) "Average diameter";
  Real crossArea = 0.5*(IN_con.crossArea_a+IN_con.crossArea_b)
    "Average cross area";
  Real roughness = 0.5*(IN_con.roughness_a+IN_con.roughness_b)
    "Average height of surface asperities";

    Real Delta = roughness/diameter "Relative roughness";
    SI.ReynoldsNumber Re1=min((745*Math.exp(if Delta <= 0.0065
         then 1 else 0.0065/Delta))^0.97, IN_con.Re_turbulent)
    "Re leaving laminar curve";
    SI.ReynoldsNumber Re2=IN_con.Re_turbulent "Re entering turbulent curve";
    SI.DynamicViscosity mu "Upstream viscosity";
    SI.Density rho "Upstream density";
    SI.ReynoldsNumber Re "Reynolds number";
    Real lambda2 "Modified friction coefficient (= lambda*Re^2)";

  SI.DynamicViscosity mu_l "Upstream liquid viscosity";
  SI.Density rho_l "Upstream liquid density";
  SI.DynamicViscosity mu_v "Upstream vapor viscosity";
  SI.Density rho_v "Upstream vapor density";
  SIadd.NonDim x_abs "Upstream absolute quality";
  Real phi2 "Two-phase modifier";

    function interpolateInRegion2
       input Real Re_turbulent;
       input SI.ReynoldsNumber Re1;
       input SI.ReynoldsNumber Re2;
       input Real Delta;
       input Real lambda2;
       output SI.ReynoldsNumber Re;
      // point lg(lambda2(Re1)) with derivative at lg(Re1)
  protected
      Real x1=Math.log10(64*Re1);
      Real y1=Math.log10(Re1);
      Real yd1=1;

      // Point lg(lambda2(Re2)) with derivative at lg(Re2)
      Real aux1=(0.5/Math.log(10))*5.74*0.9;
      Real aux2=Delta/3.7 + 5.74/Re2^0.9;
      Real aux3=Math.log10(aux2);
      Real L2=0.25*(Re2/aux3)^2;
      Real aux4=2.51/sqrt(L2) + 0.27*Delta;
      Real aux5=-2*sqrt(L2)*Math.log10(aux4);
      Real x2=Math.log10(L2);
      Real y2=Math.log10(aux5);
      Real yd2=0.5 + (2.51/Math.log(10))/(aux5*aux4);

      // Constants: Cubic polynomial between lg(Re1) and lg(Re2)
      Real diff_x=x2 - x1;
      Real m=(y2 - y1)/diff_x;
      Real c2=(3*m - 2*yd1 - yd2)/diff_x;
      Real c3=(yd1 + yd2 - 2*m)/(diff_x*diff_x);
      Real lambda2_1=64*Re1;
      Real dx;
    algorithm
       dx := Math.log10(lambda2/lambda2_1);
       Re := Re1*(lambda2/lambda2_1)^(1 + dx*(c2 + dx*c3));
       annotation(smoothOrder=1);
    end interpolateInRegion2;

algorithm
    // Determine upstream density, upstream viscosity, and lambda2
  if dp >= 0 then
    rho := IN_var.rho_a;
    mu := IN_var.mu_a;
    rho_l := IN_var.rho_l_a;
    mu_l := IN_var.mu_l_a;
    rho_v := IN_var.rho_v_a;
    mu_v := IN_var.mu_v_a;
    x_abs := IN_var.x_abs_a;
  else
    rho := IN_var.rho_b;
    mu := IN_var.mu_b;
    rho_l := IN_var.rho_l_b;
    mu_l := IN_var.mu_l_b;
    rho_v := IN_var.rho_v_b;
    mu_v := IN_var.mu_v_b;
    x_abs := IN_var.x_abs_b;
  end if;

  phi2 := TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Utilities.TwoPhaseFrictionMultiplier(x_abs,mu_l,mu_v,rho_l,rho_v);

    lambda2 := abs(dp)*2*diameter*diameter*diameter*rho/(IN_con.length*mu*mu)/phi2;

    // Determine Re under the assumption of laminar flow
    Re := lambda2/64;

    // Modify Re, if turbulent flow
    if Re > Re1 then
       Re :=-2*sqrt(lambda2)*Math.log10(2.51/sqrt(lambda2) + 0.27*Delta);
       if Re < Re2 then
          Re := interpolateInRegion2(Re, Re1, Re2, Delta, lambda2);
       end if;
    end if;

    // Determine mass flow rate
    M_FLOW := crossArea/diameter*mu*(if dp >= 0 then Re else -Re);
            annotation (smoothOrder=1, Documentation(info="<html>

</html>"));
end dp_MFLOW;