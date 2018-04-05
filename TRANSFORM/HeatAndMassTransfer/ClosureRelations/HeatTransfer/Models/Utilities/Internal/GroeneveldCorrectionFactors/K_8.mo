within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.Utilities.Internal.GroeneveldCorrectionFactors;
function K_8
  "Vertical Low-Flow Factor - A minus sign refers to downward flow"
  input SIadd.MassFlux G "Mass flux";
  input SI.Density rho_lsat "Fluid saturation density";
  input SI.Density rho_vsat "Vapor saturation density";
  input SIadd.NonDim x_abs "Absolute quality";

  output Real K "Correction factor";

protected
  Real alpha;
  Real C_1;

algorithm

  alpha := x_abs*rho_lsat/(x_abs*rho_lsat + (1 - x_abs)*rho_vsat);

  if alpha < 0.8 then
    C_1 := 1.0;
  else
    C_1 := (0.8 + 0.2*rho_lsat/rho_vsat)/(alpha + (1 - alpha)*rho_lsat/rho_vsat);
  end if;

  if G > -400 and G < 0 then
    K := (1 - alpha)*C_1;
  else
    K := 1;
  end if;
end K_8;
