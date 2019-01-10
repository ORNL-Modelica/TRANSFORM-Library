within TRANSFORM.HeatExchangers.ClosureRelations.Models.EffectivenessNTU_Relations;
model ConcentricTube "Concentric tube"

  extends PartialMethod;

  parameter Boolean counterflow=false "=true for parallel flow";

equation

  if epsilonMethod then
    if not counterflow then
      method = (1 - exp(-NTU*(1 + C_r)))/(1 + C_r);
    else
      method = noEvent(if C_r < 1 then (1 - exp(-NTU*(1 - C_r)))/(1 - C_r*exp(-
        NTU*(1 - C_r))) else NTU/(1 + NTU));
    end if;
  else
    if not counterflow then
      method = -log(1 - epsilon*(1 + C_r))/(1 + C_r);
    else
      method = noEvent(if C_r < 1 then 1/(C_r - 1)*log((epsilon - 1)/(epsilon*
        C_r - 1)) else epsilon/(1 - epsilon));
    end if;
  end if;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Source:</p>
<p>Incropera, Frank P., David P. DeWitt, Theodore L. Bergman, and Adrienne S. Lavine, eds. Fundamentals of Heat and Mass Transfer. 6. ed. Hoboken, NJ: Wiley, 2007. </p>
<p>Table 11.3 and 11.4 (pg. 689-690)</p>
</html>"));
end ConcentricTube;
