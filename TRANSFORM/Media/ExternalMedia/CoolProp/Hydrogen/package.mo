within TRANSFORM.Media.ExternalMedia.CoolProp;
package Hydrogen "Hydrogen | Two Phase | Cool Prop"
  //Surface tension from Mulero, A., Cachadiña, I. & Parra, M. I. Recommended Correlations for the Surface Tension of Common Fluids. Journal of Physical and Chemical Reference Data 41, 043105 (2012).
  extends ExternalMedia.Media.CoolPropMedium(
    mediumName = "Hydrogen",
    substanceNames = {"hydrogen|enable_BICUBIC=1"},
    ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.ph,
    SpecificEnthalpy(start=2e5));

    redeclare replaceable function surfaceTension
    extends Modelica.Icons.Function;
    input SaturationProperties sat "saturation point";
    output Modelica.SIunits.SurfaceTension sigma "Surface tension in SI units";
    constant Real s[3] = {-1.4165, 0.746383, 0.675625};
    constant Real n[3] = {0.63882, 0.659804, 0.619149};
    constant Real Tc=33.145;
protected
      Real t = sat.Tsat/Tc;
    algorithm
    sigma := sum(s[i]*(1-t)^n[i] for i in 1:3);
    annotation (Inline=true);
    end surfaceTension;
end Hydrogen;
