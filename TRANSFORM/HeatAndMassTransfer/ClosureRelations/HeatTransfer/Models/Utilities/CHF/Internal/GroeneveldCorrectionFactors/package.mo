within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.Utilities.CHF.Internal;
package GroeneveldCorrectionFactors

  function K_1 "Diameter Effect Factor"
    input SI.Length D_hyd "Hydraulic diameter of subchannel";

    output Real K "Correction factor";

  algorithm
    if D_hyd < 0.002 then
      K := 1;
    elseif D_hyd > 0.025 then
      K := 0.57;
    else
      K := sqrt(0.008/D_hyd);
    end if;
  end K_1;

  function K_2 "Bundle Geometry Factor"
    input SI.Length D_htr "Heater element diameter";
    input SI.Length Pitch "Center distance between heating elements";
    input SIadd.NonDim x_abs "Absolute quality";

    output Real K "Correction factor";

protected
    SI.Length delta;
    Real arg;

  algorithm
    assert(Pitch >= D_htr,"Pitch must be >= D_htr");

    delta := Pitch - D_htr;
    arg := (0.5 + 2*delta/D_htr)*exp(-max(0, x_abs)^(1/3)/2);
    K := min(1.0, arg);
  end K_2;

  function K_3 "Mid-Plane Spacer Factor"
    input SI.Length D_hyd "Hydraulic diameter of subchannel";
    input SIadd.MassFlux G "Mass flux";
    input SIadd.NonDim K_g "Pressure loss coefficient of spacer";
    input SI.Length L_sp "Distance between mid-plane of spacers";

    output Real K "Correction factor";

protected
    Real A;
    Real B;

  algorithm
    A := 1.5*sqrt(K_g)*(abs(G)/1000)^(0.2);
    B := 0.10;
    K := 1 + A*exp(-B*L_sp/D_hyd);
  end K_3;

  function K_4 "Heated Length Factor"
    input SI.Length D_hyd "Hydraulic diameter of subchannel";
    input SI.Length L_htd "Heated length";
    input SI.Density rho_lsat "Fluid saturation density";
    input SI.Density rho_vsat "Vapor saturation density";
    input SIadd.NonDim x_abs "Absolute quality";

    output Real K "Correction factor";

protected
    Real alpha;

  algorithm

    alpha := x_abs*rho_lsat/(x_abs*rho_lsat + (1 - x_abs)*rho_vsat);

    if L_htd/D_hyd >= 5 then
      K := exp(D_hyd/L_htd*exp(2*alpha));
    else
      K := 1;
    end if;

  end K_4;

  function K_5 "Axial Flux Distribution Factor"
    input SI.HeatFlux q_BLA "Boiling length average heat flux";
    input SI.HeatFlux q_local "Local heat flux";
    input SIadd.NonDim x_abs "Absolute quality";

    output Real K "Correction factor";

  algorithm
    if x_abs > 0 then
      K := q_local/q_BLA;
    else
      K := 1;
    end if;
  end K_5;

  function K_6
    "Radial/Circumferential (R/C) Flux Distribution Factor"
    input SI.HeatFlux q_rc_avg "Average R/C flux at a height z";
    input SI.HeatFlux q_rc_max "Maximum R/C flux at a height z";
    input SIadd.NonDim x_abs "Absolute quality";

    output Real K "Correction factor";

  algorithm
    if x_abs > 0 then
      K := q_rc_avg/q_rc_max;
    else
      K := 1;
    end if;
  end K_6;

  function K_7 "Flow-Orientation Factor"
    input SI.Length D_hyd "Hydraulic diameter of subchannel";
    input SIadd.NonDim f_L "Friction factor of the channel";
    input SIadd.MassFlux G "Mass flux";
    input SI.Density rho_lsat "Fluid saturation density";
    input SI.Density rho_vsat "Vapor saturation density";
    input SIadd.NonDim x_abs "Absolute quality";
    input SI.Acceleration g_n=Modelica.Constants.g_n "Gravity coefficient";

    output Real K "Correction factor";

protected
    Real alpha;
    Real T_1;

  algorithm

    // This alpha should be changed to the correlation of Premoli et al. (1970)
    alpha := x_abs*rho_lsat/(x_abs*rho_lsat + (1 - x_abs)*rho_vsat);

    T_1 := ((1 - x_abs)/(1 - alpha))^2*f_L*abs(G)^2/(g_n*D_hyd*rho_lsat*(rho_lsat - rho_vsat)*sqrt(max(1e-6,alpha)));
    K := 1 - exp(-sqrt(T_1/3));
  end K_7;

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
end GroeneveldCorrectionFactors;
