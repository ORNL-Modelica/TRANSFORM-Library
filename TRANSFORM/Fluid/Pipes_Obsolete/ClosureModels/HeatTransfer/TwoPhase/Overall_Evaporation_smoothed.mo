within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.TwoPhase;
model Overall_Evaporation_smoothed
  "Evaporation: Smoothed overall evaporation model from single phase liquid to single phase vapor."
  extends Modelica.Icons.UnderConstruction;
  extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.TwoPhase.Partial_TwoPhaseHeatTransfer;
  parameter Units.NonDim[nHT] x_chf=0.9*ones(nHT)
    "Steam quality corresponding to Critical Heat Flux";
  replaceable function heatTransfer_SinglephaseLiquid =
     TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.SinglePhase.alpha_DittusBoelter
    constrainedby
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.SinglePhase.alpha_DittusBoelter
     annotation(choicesAllMatching=true);
  replaceable function heatTransfer_TwoPhaseSaturated =
     TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.TwoPhase.Evaporation.alpha_Chen_TubeFlow
    constrainedby
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.TwoPhase.Evaporation.alpha_Chen_TubeFlow
     annotation(choicesAllMatching=true);
  replaceable function heatTransfer_SinglephaseVapor =
     TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.SinglePhase.alpha_DittusBoelter
    constrainedby
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.SinglePhase.alpha_DittusBoelter
     annotation(choicesAllMatching=true);
  SI.CoefficientOfHeatTransfer[nHT] alphas_SinglephaseLiquid;
  SI.CoefficientOfHeatTransfer[nHT] alphas_TwoPhaseSaturated;
  SI.CoefficientOfHeatTransfer[nHT] alphas_SinglephaseVapor;
  SI.CoefficientOfHeatTransfer[nHT] alphas_original;
  SI.CoefficientOfHeatTransfer[nHT] alphas_fsat;
  SI.CoefficientOfHeatTransfer[nHT] alphas_chf;
  SI.CoefficientOfHeatTransfer[nHT] alphas_smoothLeft;
  SI.CoefficientOfHeatTransfer[nHT] alphas_smoothRight;
  SI.ReynoldsNumber[nHT] Res_fsat "Reynolds number at saturated liquid properties";
  SI.PrandtlNumber[nHT] Prs_fsat "Prandtl number at saturated liquid properties";
  SI.ReynoldsNumber[nHT] Res_gsat "Reynolds number at saturated vapor properties";
  SI.PrandtlNumber[nHT] Prs_gsat "Prandtl number at saturated vapor properties";
  SI.SpecificEnthalpy[nHT] h_chf "Enthalpy corresponding to the Critical Heat Flux";
equation
  for i in 1:nHT loop
    Res_fsat[i] = TRANSFORM.Utilities.CharacteristicNumbers.ReynoldsNumber_m_flow(
      m_flow=m_flows[i],
      mu=mu_fsat[i],
      D=dimensions[i],
      A=crossAreas[i]);
    Prs_fsat[i] = TRANSFORM.Utilities.CharacteristicNumbers.PrandtlNumber(
      mu=mu_fsat[i],
      cp=cp_fsat[i],
      lambda=lambda_fsat[i]);
    Res_gsat[i] = TRANSFORM.Utilities.CharacteristicNumbers.ReynoldsNumber_m_flow(
      m_flow=m_flows[i],
      mu=mu_gsat[i],
      D=dimensions[i],
      A=crossAreas[i]);
    Prs_gsat[i] = TRANSFORM.Utilities.CharacteristicNumbers.PrandtlNumber(
      mu=mu_gsat[i],
      cp=cp_gsat[i],
      lambda=lambda_gsat[i]);
    alphas_fsat[i] = heatTransfer_SinglephaseLiquid(
       D=dimensions[i],
       lambda=lambda_fsat[i],
       Re=Res_fsat[i],
       Pr=Prs_fsat[i]);
    alphas_chf[i] = heatTransfer_SinglephaseLiquid(
       D=dimensions[i],
       lambda=lambda_gsat[i],
       Re=Res_gsat[i]*x_abs[i],
       Pr=Prs_gsat[i]);
    h_chf[i] = h_fsat[i] + x_chf[i]*(h_gsat[i] - h_fsat[i]);
  end for;
  for i in 1:nHT loop
    alphas_SinglephaseLiquid[i] = heatTransfer_SinglephaseLiquid(
       D=dimensions[i],
       lambda=lambdas[i],
       Re=Res[i],
       Pr=Prs[i]);
    alphas_TwoPhaseSaturated[i] = heatTransfer_TwoPhaseSaturated(
       D=dimensions[i],
       G=m_flows[i]/crossAreas[i],
       x=x_abs[i],
       rho_fsat=rho_fsat[i],
       mu_fsat=mu_fsat[i],
       lambda_fsat=lambda_fsat[i],
       cp_fsat=cp_fsat[i],
       sigma=sigma[i],
       rho_gsat=rho_gsat[i],
       mu_gsat=mu_gsat[i],
       h_fg=h_gsat[i] - h_fsat[i],
       Delta_Tsat=heatPorts[i].T - sat[i].Tsat,
       Delta_psat=Medium.saturationPressure(heatPorts[i].T) - p[i]);
    alphas_SinglephaseVapor[i] = heatTransfer_SinglephaseVapor(
       D=dimensions[i],
       lambda=lambdas[i],
       Re=Res[i],
       Pr=Prs[i]);
    alphas_original[i] = TRANSFORM.Math.spliceSigmoid(TRANSFORM.Math.spliceSigmoid(alphas_SinglephaseLiquid[i],alphas_TwoPhaseSaturated[i],x_th[i],0),alphas_SinglephaseVapor[i],x_th[i],1);
  end for;
  // Corrections due to boundaries near the nodes to the left
  // to achieve continuous h.t.c.
  alphas_smoothLeft[1] = 0;
  for i in 2:nHT loop
     if h[i]<h_fsat[i] then
       if 0.5*(h[i-1]+h[i]) > h_fsat[i] then
       alphas_smoothLeft[i]= ((h[i-1]-h_fsat[i])/(h[i-1]-h[i])-0.5)
           *(if i==nHT then 2 else 1)
           *(-alphas_fsat[i]
             + heatTransfer_TwoPhaseSaturated(
                D=dimensions[i],
                G=m_flows[i]/crossAreas[i],
                x=0,
                rho_fsat=rho_fsat[i],
                mu_fsat=mu_fsat[i],
                lambda_fsat=lambda_fsat[i],
                cp_fsat=cp_fsat[i],
                sigma=sigma[i],
                rho_gsat=rho_gsat[i],
                mu_gsat=mu_gsat[i],
                h_fg=h_gsat[i] - h_fsat[i],
                Delta_Tsat=heatPorts[i].T - sat[i].Tsat,
                Delta_psat=Medium.saturationPressure(heatPorts[i].T) - p[i]));
       else
         alphas_smoothLeft[i] = 0;
       end if;
     elseif h[i] > h_chf[i] then
       if 0.5*(h[i-1]+h[i]) < h_chf[i] then
         alphas_smoothLeft[i]=((h_chf[i]-h[i-1])/(h[i]-h[i-1])-0.5)
           *(if i == nHT then 2 else 1)
           *(-alphas_chf[i]
             + heatTransfer_TwoPhaseSaturated(
                D=dimensions[i],
                G=m_flows[i]/crossAreas[i],
                x=x_chf[i],
                rho_fsat=rho_fsat[i],
                mu_fsat=mu_fsat[i],
                lambda_fsat=lambda_fsat[i],
                cp_fsat=cp_fsat[i],
                sigma=sigma[i],
                rho_gsat=rho_gsat[i],
                mu_gsat=mu_gsat[i],
                h_fg=h_gsat[i] - h_fsat[i],
                Delta_Tsat=heatPorts[i].T - sat[i].Tsat,
                Delta_psat=Medium.saturationPressure(heatPorts[i].T) - p[i]));
       else
         alphas_smoothLeft[i] = 0;
       end if;
     elseif 0.5*(h[i-1]+h[i]) < h_fsat[i] then
       alphas_smoothLeft[i] = ((h_fsat[i]-h[i-1])/(h[i]-h[i-1])-0.5)
         *(if i == nHT then 2 else 1)
         *(alphas_fsat[i]
           - heatTransfer_TwoPhaseSaturated(
                D=dimensions[i],
                G=m_flows[i]/crossAreas[i],
                x=0,
                rho_fsat=rho_fsat[i],
                mu_fsat=mu_fsat[i],
                lambda_fsat=lambda_fsat[i],
                cp_fsat=cp_fsat[i],
                sigma=sigma[i],
                rho_gsat=rho_gsat[i],
                mu_gsat=mu_gsat[i],
                h_fg=h_gsat[i] - h_fsat[i],
                Delta_Tsat=heatPorts[i].T - sat[i].Tsat,
                Delta_psat=Medium.saturationPressure(heatPorts[i].T) - p[i]));
     elseif 0.5*(h[i-1]+h[i]) > h_chf[i] then
       alphas_smoothLeft[i] = ((h[i-1]-h_chf[i])/(h[i-1]-h[i])-0.5)
         *(if i == nHT then 2 else 1)
         *(alphas_chf[i]
           - heatTransfer_TwoPhaseSaturated(
                D=dimensions[i],
                G=m_flows[i]/crossAreas[i],
                x=x_chf[i],
                rho_fsat=rho_fsat[i],
                mu_fsat=mu_fsat[i],
                lambda_fsat=lambda_fsat[i],
                cp_fsat=cp_fsat[i],
                sigma=sigma[i],
                rho_gsat=rho_gsat[i],
                mu_gsat=mu_gsat[i],
                h_fg=h_gsat[i] - h_fsat[i],
                Delta_Tsat=heatPorts[i].T - sat[i].Tsat,
                Delta_psat=Medium.saturationPressure(heatPorts[i].T) - p[i]));
   else
      alphas_smoothLeft[i] = 0;
   end if;
  end for;
// Corrections due to boundaries near the nodes to the right
  // to achieve continuous h.t.c.
  alphas_smoothRight[nHT] = 0;
  for i in 1:nHT-1 loop
     if h[i]<h_fsat[i] then
       if 0.5*(h[i+1]+h[i]) > h_fsat[i] then
       alphas_smoothRight[i]= ((h[i+1]-h_fsat[i])/(h[i+1]-h[i])-0.5)
           *(if i==1 then 2 else 1)
           *(-alphas_fsat[i]
             + heatTransfer_TwoPhaseSaturated(
                D=dimensions[i],
                G=m_flows[i]/crossAreas[i],
                x=0,
                rho_fsat=rho_fsat[i],
                mu_fsat=mu_fsat[i],
                lambda_fsat=lambda_fsat[i],
                cp_fsat=cp_fsat[i],
                sigma=sigma[i],
                rho_gsat=rho_gsat[i],
                mu_gsat=mu_gsat[i],
                h_fg=h_gsat[i] - h_fsat[i],
                Delta_Tsat=heatPorts[i].T - sat[i].Tsat,
                Delta_psat=Medium.saturationPressure(heatPorts[i].T) - p[i]));
       else
         alphas_smoothRight[i] = 0;
       end if;
     elseif h[i] > h_chf[i] then
       if 0.5*(h[i+1]+h[i]) < h_chf[i] then
         alphas_smoothRight[i]=((h_chf[i]-h[i+1])/(h[i]-h[i+1])-0.5)
           *(if i == 1 then 2 else 1)
           *(-alphas_chf[i]
             + heatTransfer_TwoPhaseSaturated(
                D=dimensions[i],
                G=m_flows[i]/crossAreas[i],
                x=x_chf[i],
                rho_fsat=rho_fsat[i],
                mu_fsat=mu_fsat[i],
                lambda_fsat=lambda_fsat[i],
                cp_fsat=cp_fsat[i],
                sigma=sigma[i],
                rho_gsat=rho_gsat[i],
                mu_gsat=mu_gsat[i],
                h_fg=h_gsat[i] - h_fsat[i],
                Delta_Tsat=heatPorts[i].T - sat[i].Tsat,
                Delta_psat=Medium.saturationPressure(heatPorts[i].T) - p[i]));
       else
         alphas_smoothRight[i] = 0;
       end if;
     elseif 0.5*(h[i+1]+h[i]) < h_fsat[i] then
       alphas_smoothRight[i] = ((h_fsat[i]-h[i+1])/(h[i]-h[i+1])-0.5)
         *(if i == 1 then 2 else 1)
         *(alphas_fsat[i]
           - heatTransfer_TwoPhaseSaturated(
                D=dimensions[i],
                G=m_flows[i]/crossAreas[i],
                x=0,
                rho_fsat=rho_fsat[i],
                mu_fsat=mu_fsat[i],
                lambda_fsat=lambda_fsat[i],
                cp_fsat=cp_fsat[i],
                sigma=sigma[i],
                rho_gsat=rho_gsat[i],
                mu_gsat=mu_gsat[i],
                h_fg=h_gsat[i] - h_fsat[i],
                Delta_Tsat=heatPorts[i].T - sat[i].Tsat,
                Delta_psat=Medium.saturationPressure(heatPorts[i].T) - p[i]));
     elseif 0.5*(h[i+1]+h[i]) > h_chf[i] then
       alphas_smoothRight[i] = ((h[i+1]-h_chf[i])/(h[i+1]-h[i])-0.5)
         *(if i == 1 then 2 else 1)
         *(alphas_chf[i]
           - heatTransfer_TwoPhaseSaturated(
                D=dimensions[i],
                G=m_flows[i]/crossAreas[i],
                x=x_chf[i],
                rho_fsat=rho_fsat[i],
                mu_fsat=mu_fsat[i],
                lambda_fsat=lambda_fsat[i],
                cp_fsat=cp_fsat[i],
                sigma=sigma[i],
                rho_gsat=rho_gsat[i],
                mu_gsat=mu_gsat[i],
                h_fg=h_gsat[i] - h_fsat[i],
                Delta_Tsat=heatPorts[i].T - sat[i].Tsat,
                Delta_psat=Medium.saturationPressure(heatPorts[i].T) - p[i]));
    else
      alphas_smoothRight[i] = 0;
    end if;
  end for;
  for i in 1:nHT loop
    alphas[i] = TRANSFORM.Math.spliceSigmoid(TRANSFORM.Math.spliceSigmoid(alphas_SinglephaseLiquid[i],alphas_TwoPhaseSaturated[i],x_th[i],0),alphas_SinglephaseVapor[i],x_th[i],1);
    //alphas[i] = alphas_smoothLeft[i] + alphas_original[i] + alphas_smoothRight[i];
    Nus[i] = dimensions[i]/lambdas[i]*alphas[i];
  end for;
end Overall_Evaporation_smoothed;
