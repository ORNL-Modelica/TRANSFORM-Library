within TRANSFORM.HeatExchangers.ClosureRelations.Models.EffectivenessNTU_Relations;
model ShellAndTube "Shell-and-tube"
  extends PartialMethod;
  parameter Real n=1 "# of shell passes";
protected
  SIadd.NonDim E;
  SIadd.NonDim epsilon_1;
  SIadd.NonDim F;
  SIadd.NonDim NTU_1;
equation
  if epsilonMethod then
    epsilon_1 = 2/(1 + C_r + sqrt(1 + C_r^2)*(1 + exp(-NTU_1*sqrt(1 + C_r^2)))/(
      1 - exp(-NTU_1*sqrt(1 + C_r^2))));
    method = ((1 - epsilon_1*C_r)/(1 - epsilon_1)^n - 1)/(((1 - epsilon_1*C_r)/(
      1 - epsilon_1))^n - C_r);
    E = 0;
    F = 0;
    NTU_1 = NTU/n;
  else
    E = (2/epsilon_1 - (1 + C_r))/sqrt(1 + C_r^2);
    epsilon_1 = (F - 1)/(F - C_r);
    F = ((epsilon*C_r - 1)/(epsilon - 1))^(1/n);
    NTU_1 = -1/sqrt((1 + C_r^2))*log((E - 1)/(E + 1));
    method = n*NTU_1;
  end if;
  annotation (defaultComponentName="effectivenessNTU",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Source:</p>
<p>Incropera, Frank P., David P. DeWitt, Theodore L. Bergman, and Adrienne S. Lavine, eds. <i>Fundamentals of Heat and Mass Transfer</i>. 6. ed. Hoboken, NJ: Wiley, 2007. </p>
<p>Table 11.3 and 11.4 (pg. 689-690)</p>
</html>"));
end ShellAndTube;
