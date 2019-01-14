within TRANSFORM.HeatExchangers.ClosureRelations.Models.EffectivenessNTU_Relations;
model Crossflow "Cross-flow (single pass)"

  extends PartialMethod;

  parameter Boolean C_max_mixed=false "=true if stream is mixed";
  parameter Boolean C_min_mixed=false "=true if stream is mixed";

  // Internal calculation for manual checking if actual and specified C_min/max are as expected
protected
  Integer C_min_stream=if abs(C_min - C_1) <= 100*Modelica.Constants.eps then 1
       else 2;
  Integer C_max_stream=if abs(C_max - C_1) <= 100*Modelica.Constants.eps then 1
       else 2;

equation

  if epsilonMethod then
    if not C_max_mixed and not C_min_mixed then
      method = 1 - exp(1/C_r*NTU^0.22*(exp(-C_r*NTU^0.78) - 1));
    elseif C_max_mixed and not C_min_mixed then
      method = 1/C_r*(1 - exp(-C_r*(1 - exp(-NTU))));
    elseif not C_max_mixed and C_min_mixed then
      method = 1 - exp(-1/C_r*(1 - exp(-C_r*NTU)));
    else
      assert(false, "Unsupported mixed specification");
      method = 0;
    end if;
  else
    if C_max_mixed and not C_min_mixed then
      method = -log(1 + 1/C_r*log(1 - epsilon*C_r));
    elseif not C_max_mixed and C_min_mixed then
      method = -1/C_r*log(C_r*log(1 - epsilon) + 1);
    else
      assert(false, "Unsupported mixed specification");
      method = 0;
    end if;
  end if;

  annotation (defaultComponentName="effectivenessNTU",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Source:</p>
<p>Incropera, Frank P., David P. DeWitt, Theodore L. Bergman, and Adrienne S. Lavine, eds. <i>Fundamentals of Heat and Mass Transfer</i>. 6. ed. Hoboken, NJ: Wiley, 2007. </p>
<p>Table 11.3 and 11.4 (pg. 689-690)</p>
</html>"));
end Crossflow;
