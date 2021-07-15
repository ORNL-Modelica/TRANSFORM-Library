within TRANSFORM.Media.ExternalMedia.CoolProp;
package ParaHydrogen "ParaHydrogen | Two Phase | Cool Prop"
  //Surface tension from Mulero, A., Cachadiña, I. & Parra, M. I. Recommended Correlations for the Surface Tension of Common Fluids. Journal of Physical and Chemical Reference Data 41, 043105 (2012).
  extends ExternalMedia.Media.CoolPropMedium(
    mediumName = "ParaHydrogen",
    substanceNames = {"parahydrogen"},
    ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.ph,
    SpecificEnthalpy(start=2e5));

    redeclare replaceable function surfaceTension
    extends Modelica.Icons.Function;
    input SaturationProperties sat "saturation point";
    output Modelica.SIunits.SurfaceTension sigma "Surface tension in SI units";
    constant Real s[1] = {0.005314};
    constant Real n[1] = {1.060};
    constant Real Tc=32.938;
protected
      Real t = sat.Tsat/Tc;
    algorithm
    sigma := sum(s[i]*(1-t)^n[i] for i in 1:1);
    annotation (Inline=true);
    end surfaceTension;
end ParaHydrogen;
