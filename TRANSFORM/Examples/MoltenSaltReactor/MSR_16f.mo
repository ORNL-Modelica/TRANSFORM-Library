within TRANSFORM.Examples.MoltenSaltReactor;
model MSR_16f
  import TRANSFORM;

  package Medium_PFL =
      TRANSFORM.Media.Fluids.FLiBe.LinearFLiBe_12Th_05U_pT (
  extraPropertiesNames=kinetics.summary_data.extraPropertiesNames,
  C_nominal=kinetics.summary_data.C_nominal) "Primary fuel loop medium";

  package Medium_PCL = TRANSFORM.Media.Fluids.FLiBe.LinearFLiBe_pT (
  extraPropertiesNames={"Tritium"},
  C_nominal={1e6}) "Primary coolant loop medium";

  package Medium_OffGas = Modelica.Media.IdealGases.SingleGases.He (
  extraPropertiesNames=kinetics.summary_data.extraPropertiesNames,
  C_nominal=kinetics.summary_data.C_nominal);

  package Medium_DRACS = TRANSFORM.Media.Fluids.NaK.LinearNaK_22_78_pT;

  package Medium_BOP = Modelica.Media.Water.StandardWater (
  extraPropertiesNames={"Tritium"},
  C_nominal={1e6});

  parameter Integer iOG[:]={2,3} + fill(kinetics.summary_data.data_PG.nC, 2)
    "Index array of substances sent to off-gas system";

  parameter Integer toggleStaticHead = 0 "=1 to turn on, =0 to turn off";

  // Constant volume spacing for radial geometry
//   SI.Length rs[reflA_upperG.geometry.nR+1,reflA_upperG.geometry.nZ] = {{if i == 1 then reflA_upperG.geometry.r_inner else sqrt((reflA_upperG.geometry.r_outer^2-reflA_upperG.geometry.r_inner^2)/reflA_upperG.geometry.nR + rs[i-1,j]^2) for j in 1:reflA_upperG.geometry.nZ} for i in 1:reflA_upperG.geometry.nR+1};
//   SI.Length drs[reflA_upperG.geometry.nR,reflA_upperG.geometry.nZ]={{rs[i+1,j] - rs[i,j] for j in 1:reflA_upperG.geometry.nZ} for i in 1:reflA_upperG.geometry.nR};

  // Initialization
  import Modelica.Constants.N_A;
  parameter SIadd.ExtraProperty[kinetics.summary_data.data_TR.nC] C_start = N_A.*{1/Flibe_MM*MMFrac_LiF*Li6_molefrac,1/Flibe_MM*MMFrac_LiF*Li7_molefrac,1/Flibe_MM*(1-MMFrac_LiF),0} "atoms/kg fluid";

parameter SI.MassFraction Li7_enrichment = 0.99995 "mass fraction Li-7 enrichment in flibe.  Baseline is 99.995%";
parameter SI.MoleFraction MMFrac_LiF = 0.67 "Mole fraction of LiF";
parameter SI.MolarMass Flibe_MM = 0.0328931 "Molar mass of flibe [kg/mol] from doing 0.67*MM_LiF + 0.33*MM_BeF2";

parameter SI.MolarMass Li7_MM = 0.00701600455 "[kg/mol]";
parameter SI.MolarMass Li6_MM = 0.006015122795 "[kg/mol]";

parameter SI.MoleFraction Li7_molefrac = (Li7_enrichment/Li7_MM)/((Li7_enrichment/Li7_MM)+((1.0-Li7_enrichment)/Li6_MM)) "Mole fraction of lithium in flibe that is Li-7";
parameter SI.MoleFraction Li6_molefrac = 1.0-Li7_molefrac "Mole fraction of lithium in flibe that is Li-6";

  parameter SIadd.ExtraProperty[kinetics.summary_data.nC] C_start_tee_inlet=cat(
      1,
      fill(0, kinetics.summary_data.data_PG.nC),
      fill(0, kinetics.summary_data.data_FP.nC),
      C_start,
      fill(0, kinetics.summary_data.data_CP.nC));
  parameter SIadd.ExtraProperty[kinetics.summary_data.nC] C_start_plenum_lower=
      cat(
      1,
      fill(0, kinetics.summary_data.data_PG.nC),
      fill(0, kinetics.summary_data.data_FP.nC),
      C_start,
      fill(0, kinetics.summary_data.data_CP.nC));
  parameter SIadd.ExtraProperty[reflA_lower.nV,kinetics.summary_data.nC]
    Cs_start_reflA_lower={cat(
      1,
      fill(0, kinetics.summary_data.data_PG.nC),
      fill(0, kinetics.summary_data.data_FP.nC),
      C_start,
      fill(0, kinetics.summary_data.data_CP.nC)) for i in 1:reflA_lower.nV};
  parameter SIadd.ExtraProperty[fuelCell.nV,kinetics.summary_data.nC]
    Cs_start_fuelCell={cat(
      1,
      fill(0, kinetics.summary_data.data_PG.nC),
      fill(0, kinetics.summary_data.data_FP.nC),
      C_start,
      fill(0, kinetics.summary_data.data_CP.nC)) for i in 1:fuelCell.nV};
  parameter SIadd.ExtraProperty[reflR.nV,kinetics.summary_data.nC]
    Cs_start_reflR={cat(
      1,
      fill(0, kinetics.summary_data.data_PG.nC),
      fill(0, kinetics.summary_data.data_FP.nC),
      C_start,
      fill(0, kinetics.summary_data.data_CP.nC)) for i in 1:reflR.nV};
  parameter SIadd.ExtraProperty[reflA_upper.nV,kinetics.summary_data.nC]
    Cs_start_reflA_upper={cat(
      1,
      fill(0, kinetics.summary_data.data_PG.nC),
      fill(0, kinetics.summary_data.data_FP.nC),
      C_start,
      fill(0, kinetics.summary_data.data_CP.nC)) for i in 1:reflA_upper.nV};
  parameter SIadd.ExtraProperty[kinetics.summary_data.nC] C_start_plenum_upper=
      cat(
      1,
      fill(0, kinetics.summary_data.data_PG.nC),
      fill(0, kinetics.summary_data.data_FP.nC),
      C_start,
      fill(0, kinetics.summary_data.data_CP.nC));
  parameter SIadd.ExtraProperty[kinetics.summary_data.nC] C_start_pumpBowl_PFL=
      cat(
      1,
      fill(0, kinetics.summary_data.data_PG.nC),
      fill(0, kinetics.summary_data.data_FP.nC),
      C_start,
      fill(0, kinetics.summary_data.data_CP.nC));
  parameter SIadd.ExtraProperty[pipeToPHX_PFL.nV,kinetics.summary_data.nC]
    Cs_start_pipeToPHX_PFL={cat(
      1,
      fill(0, kinetics.summary_data.data_PG.nC),
      fill(0, kinetics.summary_data.data_FP.nC),
      C_start,
      fill(0, kinetics.summary_data.data_CP.nC)) for i in 1:pipeToPHX_PFL.nV};
  parameter SIadd.ExtraProperty[PHX.tube.nV,kinetics.summary_data.nC]
    Cs_start_PHX_tube={cat(
      1,
      fill(0, kinetics.summary_data.data_PG.nC),
      fill(0, kinetics.summary_data.data_FP.nC),
      C_start,
      fill(0, kinetics.summary_data.data_CP.nC)) for i in 1:PHX.tube.nV};
  parameter SIadd.ExtraProperty[pipeFromPHX_PFL.nV,kinetics.summary_data.nC]
    Cs_start_pipeFromPHX_PFL={cat(
      1,
      fill(0, kinetics.summary_data.data_PG.nC),
      fill(0, kinetics.summary_data.data_FP.nC),
      C_start,
      fill(0, kinetics.summary_data.data_CP.nC)) for i in 1:pipeFromPHX_PFL.nV};

      parameter Integer nV_fuelCell = 10;
      parameter Integer nV_PHX = 10;
      parameter Integer nV_SHX = 10;
      parameter Integer nV_pipeToPHX_PFL = 2;
      parameter Integer nV_pipeFromPHX_PFL = 2;
      parameter Integer nV_pipeFromPHX_PCL = 2;
      parameter Integer nV_pipeToPHX_PCL = 2;
      parameter Integer nV_pipeToSHX_PCL = 2;

//   SI.Temperature Tref_fuelCell[fuelCell.geometry.nV] = {TRANSFORM.Math.Sigmoid(fuelCell.summary.xpos_norm[i], 0.5, fuelCell.geometry.nV)*(data_RCTR.T_outlet_core-data_RCTR.T_inlet_core) + data_RCTR.T_inlet_core for i in 1:fuelCell.geometry.nV};
//   SI.Temperature Tref_fuelCellG[fuelCell.geometry.nV] = {TRANSFORM.Math.Sigmoid(fuelCell.summary.xpos_norm[i], 0.5, fuelCell.geometry.nV)*(data_RCTR.T_outlet_core-data_RCTR.T_inlet_core) + data_RCTR.T_inlet_core+1 for i in 1:fuelCell.geometry.nV};
//   SI.Temperature Tref_core[fuelCell.geometry.nV,kinetics.nFeedback] = {{if j == 1 then Tref_fuelCell[i] else Tref_fuelCellG[i] for j in 1:kinetics.nFeedback} for i in 1:fuelCell.geometry.nV};

  // Gathered info

  parameter Real A[2] = {3e4,4e-8}*100^2/1e6/60^2 "kg/m^2/s";
  parameter Real Q[2] = {29900,14400}*4.1868 "J/mol";
  parameter SI.MolarMass MW_Cr = 0.0519961;
  parameter SI.Density d_alloyN = 8.86*100^3/1000;
  parameter Real wf_Cr = 0.07 "Weight fraction Cr";
  parameter SI.MolarDensity C_start_Cr = d_alloyN*wf_Cr/MW_Cr "Initial concentration of Cr in HX";

  SI.MolarFlowRate dWdt_removal[PHX.geometry.nV] = {A[1]*exp(-Q[1]/(Modelica.Constants.R*PHX.tube.mediums[i].T))*PHX.tube.geometry.surfaceAreas[i,1]*PHX.tube.nParallel for i in 1:PHX.geometry.nV}/MW_Cr;
  SI.MolarFlowRate dWdt_deposit[PHX.geometry.nV] = {A[2]*exp(Q[2]/(Modelica.Constants.R*PHX.tube.mediums[i].T))*PHX.tube.geometry.surfaceAreas[i,1]*PHX.tube.nParallel for i in 1:PHX.geometry.nV}/MW_Cr;

  parameter SI.Temperature T_transition = 0.5*(data_PHX.T_inlet_tube+data_PHX.T_outlet_tube);

  SI.MolarFlowRate n_flows_Cr[PHX.geometry.nV]={
      if PHX.tube.mediums[i].T > T_transition then
          -dWdt_removal[i]
      else
        dWdt_deposit[i] for i in 1:PHX.geometry.nV};

  SI.Power Qt_total = sum(kinetics.Qs) "Total thermal power output (from primary fission)";

  SI.Temperature Ts[fuelCell.geometry.nV] = fuelCell.mediums.T;

  SI.Temperature Tst[PHX.geometry.nV] = PHX.tube.mediums.T;
  SI.Temperature Tss[PHX.geometry.nV] = PHX.shell.mediums.T;

  SI.Temperature Ts_loop[1+reflA_lower.nV+fuelCell.nV+reflA_upper.nV+1+pipeToPHX_PFL.nV+PHX.tube.nV+pipeFromPHX_PFL.nV+1] = cat(1,{plenum_lower.medium.T},reflA_lower.mediums.T,fuelCell.mediums.T,reflA_upper.mediums.T,
  {plenum_upper.medium.T},pipeToPHX_PFL.mediums.T,PHX.tube.mediums.T,pipeFromPHX_PFL.mediums.T,{tee_inlet.medium.T});

  // Decay Heat Calculations: PFL
  SI.Power Qs_gen_tee_inlet=sum({(kinetics.summary_data.w_near_decay[j] +
      kinetics.summary_data.w_far_decay[j])*kinetics.summary_data.lambdas[j]*
      tee_inlet.mC[j] for j in 1:kinetics.summary_data.nC});
  SI.Power Qs_gen_plenum_lower=sum({(kinetics.summary_data.w_near_decay[j] +
      kinetics.summary_data.w_far_decay[j])*kinetics.summary_data.lambdas[j]*
      plenum_lower.mC[j] for j in 1:kinetics.summary_data.nC});
  SI.Power[reflA_lower.nV] Qs_gen_reflA_lower={sum({kinetics.summary_data.w_near_decay[
      j]*kinetics.summary_data.lambdas[j]*reflA_lower.mCs[i, j] for j in 1:
      kinetics.summary_data.nC}) for i in 1:reflA_lower.nV};
  SI.Power[fuelCell.nV] Qs_gen_fuelCell=kinetics.Qs;
  SI.Power[reflR.nV] Qs_gen_reflR={sum({kinetics.summary_data.w_near_decay[j]*
      kinetics.summary_data.lambdas[j]*reflR.mCs[i, j] for j in 1:
      kinetics.summary_data.nC}) for i in 1:reflR.nV};
  SI.Power[reflA_upper.nV] Qs_gen_reflA_upper={sum({kinetics.summary_data.w_near_decay[
      j]*kinetics.summary_data.lambdas[j]*reflA_upper.mCs[i, j] for j in 1:
      kinetics.summary_data.nC}) for i in 1:reflA_upper.nV};

  SI.Power Qs_gen_plenum_upper=sum({(kinetics.summary_data.w_near_decay[j] +
      kinetics.summary_data.w_far_decay[j])*kinetics.summary_data.lambdas[j]*
      plenum_upper.mC[j] for j in 1:kinetics.summary_data.nC});
  SI.Power Qs_gen_pumpBowl_PFL=sum({(kinetics.summary_data.w_near_decay[j] +
      kinetics.summary_data.w_far_decay[j])*kinetics.summary_data.lambdas[j]*
      pumpBowl_PFL.mC[j] for j in 1:kinetics.summary_data.nC});
  SI.Power[pipeToPHX_PFL.nV] Qs_gen_pipeToPHX_PFL={sum({(kinetics.summary_data.w_near_decay[
      j] + kinetics.summary_data.w_far_decay[j])*kinetics.summary_data.lambdas[j]
      *pipeToPHX_PFL.mCs[i, j] for j in 1:kinetics.summary_data.nC}) for i in 1:
      pipeToPHX_PFL.nV};
  SI.Power[PHX.tube.nV] Qs_gen_PHX_tube={sum({(kinetics.summary_data.w_near_decay[
      j] + kinetics.summary_data.w_far_decay[j])*kinetics.summary_data.lambdas[j]
      *PHX.tube.mCs[i, j] for j in 1:kinetics.summary_data.nC}) for i in 1:PHX.tube.nV};
  SI.Power[pipeFromPHX_PFL.nV] Qs_gen_pipeFromPHX_PFL={sum({(
      kinetics.summary_data.w_near_decay[j] + kinetics.summary_data.w_far_decay[j])
      *kinetics.summary_data.lambdas[j]*pipeFromPHX_PFL.mCs[i, j] for j in 1:
      kinetics.summary_data.nC}) for i in 1:pipeFromPHX_PFL.nV};

  // Decay Heat Calculations: PFL - solid
  SI.Power[reflA_lower.nV] QsG_reflA_lowerG={sum({kinetics.summary_data.w_far_decay[
      j]*kinetics.summary_data.lambdas[j]*reflA_lower.mCs[i, j] for j in 1:
      kinetics.summary_data.nC}) for i in 1:reflA_lower.nV};
  //SI.Power[fuelCell.nV] QsG_fuelCellG = {sum({kinetics.summary_data.wG_decay[j]*kinetics.summary_data.lambdas[j]*fuelCell.mCs[i, j] for j in 1:kinetics.summary_data.nC}) for i in 1:fuelCell.nV};
  SI.Power[reflR.nV] QsG_reflRG={sum({kinetics.summary_data.w_far_decay[j]*
      kinetics.summary_data.lambdas[j]*reflR.mCs[i, j] for j in 1:
      kinetics.summary_data.nC}) for i in 1:reflR.nV};
  SI.Power[reflA_upper.nV] QsG_reflA_upperG={sum({kinetics.summary_data.w_far_decay[
      j]*kinetics.summary_data.lambdas[j]*reflA_upper.mCs[i, j] for j in 1:
      kinetics.summary_data.nC}) for i in 1:reflA_upper.nV};

  SI.Power[reflA_lowerG.nVs[1],reflA_lowerG.nVs[2]] Qs_gen_reflA_lowerG = {{QsG_reflA_lowerG[j]/reflA_lowerG.nVs[1] for j in 1:reflA_lowerG.nVs[2]} for i in 1:reflA_lowerG.nVs[1]};
  SI.Power[fuelCellG.nVs[1],fuelCellG.nVs[2]] Qs_gen_fuellCellG={{kinetics.fissionProducts.Qs_far[
      j]/fuelCellG.nVs[1] for j in 1:fuelCellG.nVs[2]} for i in 1:fuelCellG.nVs[
      1]};
  SI.Power[reflRG.nVs[1],reflRG.nVs[2]] Qs_gen_reflRG = {{QsG_reflRG[j]/reflRG.nVs[1] + Qs_gen_fuellCellG[i,j] for j in 1:reflRG.nVs[2]} for i in 1:reflRG.nVs[1]};
  SI.Power[reflA_upperG.nVs[1],reflA_upperG.nVs[2]] Qs_gen_reflA_upperG = {{QsG_reflA_upperG[j]/reflA_upperG.nVs[1] for j in 1:reflA_upperG.nVs[2]} for i in 1:reflA_upperG.nVs[1]};

  // Decay Heat Calculations: Off-Gas/DrainTank
  SI.Power Qs_gen_drainTank_gas=sum({(kinetics.summary_data.w_near_decay[j] +
      kinetics.summary_data.w_far_decay[j])*kinetics.summary_data.lambdas[j]*
      drainTank_gas.mC[j] for j in 1:kinetics.summary_data.nC});
  SI.Power Qs_gen_drainTank_liquid=sum({(kinetics.summary_data.w_near_decay[j]
       + kinetics.summary_data.w_far_decay[j])*kinetics.summary_data.lambdas[j]*
      drainTank_liquid.mC[j] for j in 1:kinetics.summary_data.nC});

  // Trace Substance Calculations: PFL
  SIadd.ExtraPropertyFlowRate[kinetics.summary_data.nC] mC_gen_tee_inlet = {-kinetics.summary_data.lambdas[j]*tee_inlet.mC[j] + mC_gen_tee_inlet_PtoD[j] for j in 1:kinetics.summary_data.nC};
  SIadd.ExtraPropertyFlowRate[kinetics.summary_data.nC] mC_gen_plenum_lower = {-kinetics.summary_data.lambdas[j]*plenum_lower.mC[j] + mC_gen_plenum_lower_PtoD[j] for j in 1:kinetics.summary_data.nC};
  SIadd.ExtraPropertyFlowRate[reflA_lower.nV,kinetics.summary_data.nC] mC_gens_reflA_lower = {{-kinetics.summary_data.lambdas[j]*reflA_lower.mCs[i, j]*reflA_lower.nParallel + mC_gens_reflA_lower_PtoD[i,j] for j in 1:kinetics.summary_data.nC} for i in 1:reflA_lower.nV};
  SIadd.ExtraPropertyFlowRate[fuelCell.nV,kinetics.summary_data.nC] mC_gens_fuelCell = cat(2, kinetics.mC_gens, kinetics.fissionProducts.mC_gens,kinetics.fissionProducts.mC_gens_TR,fill(0,fuelCell.nV,kinetics.summary_data.data_CP.nC));
  SIadd.ExtraPropertyFlowRate[reflR.nV,kinetics.summary_data.nC] mC_gens_reflR = {{-kinetics.summary_data.lambdas[j]*reflR.mCs[i, j]*reflR.nParallel + mC_gens_reflR_PtoD[i,j] for j in 1:kinetics.summary_data.nC} for i in 1:reflR.nV};
  SIadd.ExtraPropertyFlowRate[reflA_upper.nV,kinetics.summary_data.nC] mC_gens_reflA_upper = {{-kinetics.summary_data.lambdas[j]*reflA_upper.mCs[i, j]*reflA_upper.nParallel + mC_gens_reflA_upper_PtoD[i,j] for j in 1:kinetics.summary_data.nC} for i in 1:reflA_upper.nV};
  SIadd.ExtraPropertyFlowRate[kinetics.summary_data.nC] mC_gen_plenum_upper = {-kinetics.summary_data.lambdas[j]*plenum_upper.mC[j] + mC_gen_plenum_upper_PtoD[j] for j in 1:kinetics.summary_data.nC};
  SIadd.ExtraPropertyFlowRate[kinetics.summary_data.nC] mC_gen_pumpBowl_PFL={-kinetics.summary_data.lambdas[j]*pumpBowl_PFL.mC[j]*3 + mC_flows_fromOG[j] + mC_gen_pumpBowl_PFL_PtoD[j] for j in 1:kinetics.summary_data.nC};
  SIadd.ExtraPropertyFlowRate[pipeToPHX_PFL.nV,kinetics.summary_data.nC] mC_gens_pipeToPHX_PFL = {{-kinetics.summary_data.lambdas[j]*pipeToPHX_PFL.mCs[i, j]*pipeToPHX_PFL.nParallel + mC_gens_pipeToPHX_PFL_PtoD[i,j] for j in 1:kinetics.summary_data.nC} for i in 1:pipeToPHX_PFL.nV};
  SIadd.ExtraPropertyFlowRate[PHX.tube.nV,kinetics.summary_data.nC] mC_gens_PHX_tube = {{-kinetics.summary_data.lambdas[j]*PHX.tube.mCs[i, j]*PHX.tube.nParallel + mC_gens_PHX_tube_PtoD[i,j] + (if j == kinetics.summary_data.iCP[1] then -n_flows_Cr[i]*6.022e23 else 0) for j in 1:kinetics.summary_data.nC} for i in 1:PHX.tube.nV};
  SIadd.ExtraPropertyFlowRate[pipeFromPHX_PFL.nV,kinetics.summary_data.nC] mC_gens_pipeFromPHX_PFL = {{-kinetics.summary_data.lambdas[j]*pipeFromPHX_PFL.mCs[i, j]*pipeFromPHX_PFL.nParallel + mC_gens_pipeFromPHX_PFL_PtoD[i,j] for j in 1:kinetics.summary_data.nC} for i in 1:pipeFromPHX_PFL.nV};

  // Trace Substances Parent->Daughter contribution
  SIadd.ExtraPropertyFlowRate[kinetics.summary_data.nC] mC_gen_tee_inlet_PtoD = {sum({kinetics.summary_data.lambdas[k].*tee_inlet.mC[k].*kinetics.summary_data.parents[j,k] for k in 1:kinetics.summary_data.nC}) for j in 1:kinetics.summary_data.nC};
  SIadd.ExtraPropertyFlowRate[kinetics.summary_data.nC] mC_gen_plenum_lower_PtoD= {sum({kinetics.summary_data.lambdas[k].*plenum_lower.mC[k].*kinetics.summary_data.parents[j,k] for k in 1:kinetics.summary_data.nC}) for j in 1:kinetics.summary_data.nC};
  SIadd.ExtraPropertyFlowRate[reflA_lower.nV,kinetics.summary_data.nC] mC_gens_reflA_lower_PtoD = {{sum({kinetics.summary_data.lambdas[k].*reflA_lower.mCs[i,k].*reflA_lower.nParallel.*kinetics.summary_data.parents[j,k] for k in 1:kinetics.summary_data.nC}) for j in 1:kinetics.summary_data.nC} for i in 1:reflA_lower.nV};
  //SIadd.ExtraPropertyFlowRate[fuelCell.nV,kinetics.summary_data.nC] mC_gens_fuelCell_PtoD = {{sum({kinetics.summary_data.lambdas[k].*fuelCell.mCs[i,k].*fuelCell.nParallel.*kinetics.summary_data.parents[j,k] for k in 1:kinetics.summary_data.nC}) for j in 1:kinetics.summary_data.nC} for i in 1:fuelCell.nV};
  SIadd.ExtraPropertyFlowRate[reflR.nV,kinetics.summary_data.nC] mC_gens_reflR_PtoD= {{sum({kinetics.summary_data.lambdas[k].*reflR.mCs[i,k].*reflR.nParallel.*kinetics.summary_data.parents[j,k] for k in 1:kinetics.summary_data.nC}) for j in 1:kinetics.summary_data.nC} for i in 1:reflR.nV};
  SIadd.ExtraPropertyFlowRate[reflA_upper.nV,kinetics.summary_data.nC] mC_gens_reflA_upper_PtoD= {{sum({kinetics.summary_data.lambdas[k].*reflA_upper.mCs[i,k].*reflA_upper.nParallel.*kinetics.summary_data.parents[j,k] for k in 1:kinetics.summary_data.nC}) for j in 1:kinetics.summary_data.nC} for i in 1:reflA_upper.nV};
  SIadd.ExtraPropertyFlowRate[kinetics.summary_data.nC] mC_gen_plenum_upper_PtoD= {sum({kinetics.summary_data.lambdas[k].*plenum_upper.mC[k].*kinetics.summary_data.parents[j,k] for k in 1:kinetics.summary_data.nC}) for j in 1:kinetics.summary_data.nC};
  SIadd.ExtraPropertyFlowRate[kinetics.summary_data.nC] mC_gen_pumpBowl_PFL_PtoD= {sum({kinetics.summary_data.lambdas[k].*pumpBowl_PFL.mC[k].*kinetics.summary_data.parents[j,k] for k in 1:kinetics.summary_data.nC}) for j in 1:kinetics.summary_data.nC};
  SIadd.ExtraPropertyFlowRate[pipeToPHX_PFL.nV,kinetics.summary_data.nC] mC_gens_pipeToPHX_PFL_PtoD = {{sum({kinetics.summary_data.lambdas[k].*pipeToPHX_PFL.mCs[i,k].*pipeToPHX_PFL.nParallel.*kinetics.summary_data.parents[j,k] for k in 1:kinetics.summary_data.nC}) for j in 1:kinetics.summary_data.nC} for i in 1:pipeToPHX_PFL.nV};
  SIadd.ExtraPropertyFlowRate[PHX.tube.nV,kinetics.summary_data.nC] mC_gens_PHX_tube_PtoD = {{sum({kinetics.summary_data.lambdas[k].*PHX.tube.mCs[i,k].*PHX.tube.nParallel.*kinetics.summary_data.parents[j,k] for k in 1:kinetics.summary_data.nC}) for j in 1:kinetics.summary_data.nC} for i in 1:PHX.tube.nV};
  SIadd.ExtraPropertyFlowRate[pipeFromPHX_PFL.nV,kinetics.summary_data.nC] mC_gens_pipeFromPHX_PFL_PtoD = {{sum({kinetics.summary_data.lambdas[k].*pipeFromPHX_PFL.mCs[i,k].*pipeFromPHX_PFL.nParallel.*kinetics.summary_data.parents[j,k] for k in 1:kinetics.summary_data.nC}) for j in 1:kinetics.summary_data.nC} for i in 1:pipeFromPHX_PFL.nV};

  // TraceSubstance Calculations: Off-Gas and Drain Tank
  SI.MassFlowRate m_flow_toDrainTank = data_OFFGAS.V_flow_sep_salt_total*Medium_PFL.density_ph(pump_PFL.port_b.p, pump_PFL.port_b.h_outflow) "Mass flow rate of salt to drain tank (+)";
  SIadd.ExtraPropertyFlowRate[kinetics.summary_data.nC] mC_gen_drainTank_gas=-kinetics.summary_data.lambdas.*drainTank_gas.mC + mC_gen_drainTank_gas_PtoD;
  SIadd.ExtraPropertyFlowRate[kinetics.summary_data.nC] mC_gen_drainTank_liquid=-kinetics.summary_data.lambdas.*drainTank_liquid.mC + mC_gen_drainTank_liquid_PtoD;
  SIadd.ExtraPropertyFlowRate[kinetics.summary_data.nC] mC_flows_fromOG = abs(pump_OffGas_bypass.port_b.m_flow).*pump_OffGas_bypass.port_b.C_outflow+abs(pump_OffGas_adsorberBed.port_b.m_flow).*pump_OffGas_adsorberBed.port_b.C_outflow;

  // Trace Substances Parent->Daughter contribution:  Off-Gas and Drain Tank
  SIadd.ExtraPropertyFlowRate[kinetics.summary_data.nC] mC_gen_drainTank_gas_PtoD = {sum({kinetics.summary_data.lambdas[k].*drainTank_gas.mC[k].*kinetics.summary_data.parents[j,k] for k in 1:kinetics.summary_data.nC}) for j in 1:kinetics.summary_data.nC};
  SIadd.ExtraPropertyFlowRate[kinetics.summary_data.nC] mC_gen_drainTank_liquid_PtoD = {sum({kinetics.summary_data.lambdas[k].*drainTank_liquid.mC[k].*kinetics.summary_data.parents[j,k] for k in 1:kinetics.summary_data.nC}) for j in 1:kinetics.summary_data.nC};

  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT boundary_OffGas_sink(
    redeclare package Medium = Medium_OffGas,
    nPorts=2,
    T=data_OFFGAS.T_carbon,
    p=data_OFFGAS.p_sep_ref,
    use_p_in=true,
    showName=systemTF.showName)
    annotation (Placement(transformation(extent={{-170,20},{-190,40}})));

  Data.data_PHX data_PHX
    annotation (Placement(transformation(extent={{290,100},{310,120}})));
  Data.data_RCTR data_RCTR
    annotation (Placement(transformation(extent={{260,100},{280,120}})));
  Data.data_PUMP data_PUMP
    annotation (Placement(transformation(extent={{320,120},{340,140}})));
  Data.data_SHX data_SHX
    annotation (Placement(transformation(extent={{320,100},{340,120}})));
  Data.data_PIPING data_PIPING
    annotation (Placement(transformation(extent={{260,80},{280,100}})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface fuelCell(
    nParallel=data_RCTR.nFcells,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    T_a_start=data_PHX.T_outlet_tube,
    T_b_start=data_PHX.T_inlet_tube,
    exposeState_b=true,
    p_a_start=data_PHX.p_inlet_tube + 100,
    redeclare package Medium = Medium_PFL,
    use_HeatTransfer=true,
    showName=systemTF.showName,
    m_flow_a_start=0.95*data_RCTR.m_flow,
    redeclare model InternalTraceGen =
        TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
        (mC_gens=mC_gens_fuelCell),
    Cs_start=Cs_start_fuelCell,
    redeclare model InternalHeatGen =
        TRANSFORM.Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.GenericHeatGeneration
        (Q_gens=Qs_gen_fuelCell),
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        crossArea=data_RCTR.crossArea_f,
        perimeter=data_RCTR.perimeter_f,
        length=data_RCTR.length_cells,
        angle=toggleStaticHead*90,
        surfaceArea={fuelCellG.nParallel/fuelCell.nParallel*sum(fuelCellG.geometry.crossAreas_1
            [1, :])},
        nV=nV_fuelCell),
    use_TraceMassTransfer=true,
    redeclare model TraceMassTransfer =
        TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D_MultiTransferSurface.Shs_SinglePhase_2Region
        (
        MMs={6.022e23},
        redeclare model DiffusionCoeff =
            TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.ArrheniusEquation
            (iTable={1}),
        iC={kinetics.summary_data.iH3}))
    "frac*data_RCTR.Q_nominal/fuelCell.nV; mC_gens_fuelCell"
                                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,0})));

  Fluid.Pipes.GenericPipe_MultiTransferSurface reflA_upper(
    m_flow_a_start=data_RCTR.m_flow,
    p_a_start=data_PHX.p_inlet_tube + 50,
    T_a_start=data_PHX.T_inlet_tube,
    redeclare package Medium = Medium_PFL,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    showName=systemTF.showName,
    redeclare model InternalTraceGen =
        TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
        (mC_gens=mC_gens_reflA_upper),
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        crossArea=data_RCTR.crossArea_reflA_ring,
        perimeter=data_RCTR.perimeter_reflA_ring,
        length=data_RCTR.length_reflA,
        nV=2,
        nSurfaces=2,
        angle=toggleStaticHead*90,
        surfaceArea={reflA_upperG.nParallel/reflA_upper.nParallel*sum(
            reflA_upperG.geometry.crossAreas_1[1, :]),reflA_upperG.nParallel/
            reflA_upper.nParallel*sum(reflA_upperG.geometry.crossAreas_1[end, :])}),
    Cs_start=Cs_start_reflA_upper,
    redeclare model InternalHeatGen =
        TRANSFORM.Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.GenericHeatGeneration
        (Q_gens=Qs_gen_reflA_upper),
    use_TraceMassTransfer=true,
    redeclare model TraceMassTransfer =
        TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D_MultiTransferSurface.Shs_SinglePhase_2Region
        (
        redeclare model DiffusionCoeff =
            TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.ArrheniusEquation
            (iTable={1}),
        MMs={6.022e23},
        iC={kinetics.summary_data.iH3}))
               annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,60})));

  Fluid.Volumes.MixingVolume plenum_upper(
    p_start=data_PHX.p_inlet_tube,
    T_start=data_PHX.T_inlet_tube,
    nPorts_b=1,
    nPorts_a=1,
    redeclare package Medium = Medium_PFL,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.Cylinder (
        length=data_RCTR.length_plenum,
        crossArea=data_RCTR.crossArea_plenum,
        angle=toggleStaticHead*90),
    showName=systemTF.showName,
    mC_gen=mC_gen_plenum_upper,
    C_start=C_start_plenum_upper,
    Q_gen=Qs_gen_plenum_upper)             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,90})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface reflA_lower(
    m_flow_a_start=data_RCTR.m_flow,
    p_a_start=data_PHX.p_inlet_tube + 150,
    T_a_start=data_PHX.T_outlet_tube,
    exposeState_a=false,
    exposeState_b=true,
    redeclare package Medium = Medium_PFL,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    showName=systemTF.showName,
    redeclare model InternalTraceGen =
        TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
        (mC_gens=mC_gens_reflA_lower),
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        crossArea=data_RCTR.crossArea_reflA_ring,
        perimeter=data_RCTR.perimeter_reflA_ring,
        length=data_RCTR.length_reflA,
        nV=2,
        nSurfaces=2,
        angle=toggleStaticHead*90,
        surfaceArea={reflA_lowerG.nParallel/reflA_lower.nParallel*sum(
            reflA_lowerG.geometry.crossAreas_1[1, :]),reflA_lowerG.nParallel/
            reflA_lower.nParallel*sum(reflA_lowerG.geometry.crossAreas_1[end, :])}),
    Cs_start=Cs_start_reflA_lower,
    redeclare model InternalHeatGen =
        TRANSFORM.Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.GenericHeatGeneration
        (Q_gens=Qs_gen_reflA_lower),
    use_TraceMassTransfer=true,
    redeclare model TraceMassTransfer =
        TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D_MultiTransferSurface.Shs_SinglePhase_2Region
        (
        MMs={6.022e23},
        redeclare model DiffusionCoeff =
            TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.ArrheniusEquation
            (iTable={1}),
        iC={kinetics.summary_data.iH3}))
                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-60})));

  Fluid.FittingsAndResistances.SpecifiedResistance resistance_fuelCell_outlet(
          redeclare package Medium = Medium_PFL, R=1,
    showName=systemTF.showName)
          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,30})));
  Fluid.Volumes.MixingVolume plenum_lower(
    nPorts_b=1,
    redeclare package Medium = Medium_PFL,
    nPorts_a=1,
    p_start=data_PHX.p_inlet_tube + 150,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.Cylinder (
        length=data_RCTR.length_plenum,
        crossArea=data_RCTR.crossArea_plenum,
        angle=toggleStaticHead*90),
    T_start=data_PHX.T_outlet_tube,
    showName=systemTF.showName,
    mC_gen=mC_gen_plenum_lower,
    C_start=C_start_plenum_lower,
    Q_gen=Qs_gen_plenum_lower)           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-90})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance_fuelCell_inlet(
      redeclare package Medium = Medium_PFL, R=1,
    showName=systemTF.showName)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-30})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance_toPump_PFL(
      redeclare package Medium = Medium_PFL, R=1,
    showName=systemTF.showName)              annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,112})));
  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.HMTransfer_2D
                                                      fuelCellG(
    redeclare package Material = Media.Solids.Graphite.Graphite_0,
    nParallel=2*data_RCTR.nfG*data_RCTR.nFcells,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Plane_2D
        (
        nX=5,
        nY=fuelCell.nV,
        length_x=0.5*data_RCTR.width_fG,
        length_y=data_RCTR.length_cells,
        length_z=data_RCTR.length_fG),
    exposeState_b2=true,
    exposeState_b1=true,
    T_a2_start=data_PHX.T_outlet_tube,
    showName=systemTF.showName,
    redeclare model InternalHeatModel =
        TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_2.GenericHeatGeneration
        (Q_gens=Qs_gen_fuellCellG),
    T_a1_start=0.5*(data_PHX.T_inlet_tube + data_PHX.T_outlet_tube),
    T_b1_start=0.5*(data_PHX.T_inlet_tube + data_PHX.T_outlet_tube),
    T_b2_start=data_PHX.T_inlet_tube,
    redeclare model DiffusionCoeff =
        TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.ArrheniusEquation
        (iTable={12}))   annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-30,0})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi
    fuelCellG_centerline_bc(nPorts=fuelCell.nV, showName=systemTF.showName)
    annotation (Placement(transformation(extent={{-68,-10},{-48,10}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi
    fuelCellG_upper_bc(nPorts=fuelCellG.geometry.nX, showName=systemTF.showName)
                                                     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,30})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi
    fuelCellG_lower_bc(nPorts=fuelCellG.geometry.nX, showName=systemTF.showName)
                                                     annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-30,-30})));
  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.HMTransfer_2D
                                                      reflA_upperG(
    redeclare package Material = Media.Solids.Graphite.Graphite_0,
    T_a2_start=data_PHX.T_inlet_tube,
    T_b2_start=data_PHX.T_inlet_tube,
    exposeState_b2=true,
    exposeState_b1=true,
    T_a1_start=data_PHX.T_inlet_tube,
    T_b1_start=data_PHX.T_inlet_tube,
    nParallel=data_RCTR.n_reflA_ringG,
    showName=systemTF.showName,
    redeclare model Geometry =
        HeatAndMassTransfer.ClosureRelations.Geometry.Models.Cylinder_2D_r_z (
        nR=5,
        nZ=reflA_upper.nV,
        r_inner=data_RCTR.rs_ring_edge_inner[6],
        r_outer=data_RCTR.rs_ring_edge_outer[6],
        length_z=data_RCTR.length_reflA,
        angle_theta=data_RCTR.angle_reflA_ring_blockG),
    redeclare model InternalHeatModel =
        TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_2.GenericHeatGeneration
        (Q_gens=Qs_gen_reflA_upperG),
    redeclare model DiffusionCoeff =
        TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.ArrheniusEquation
        (iTable={12}))                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-30,60})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi
    reflA_upperG_upper_bc(nPorts=reflA_upperG.geometry.nR, showName=systemTF.showName)
                                                           annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,90})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi
    reflA_upperG_lower_bc(nPorts=reflA_upperG.geometry.nR, showName=systemTF.showName)
                                                           annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-30,30})));
  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.HMTransfer_2D
                                                      reflA_lowerG(
    redeclare package Material = Media.Solids.Graphite.Graphite_0,
    exposeState_b2=true,
    exposeState_b1=true,
    nParallel=data_RCTR.n_reflA_ringG,
    T_a1_start=data_PHX.T_outlet_tube,
    T_b1_start=data_PHX.T_outlet_tube,
    T_a2_start=data_PHX.T_outlet_tube,
    T_b2_start=data_PHX.T_outlet_tube,
    showName=systemTF.showName,
    redeclare model Geometry =
        HeatAndMassTransfer.ClosureRelations.Geometry.Models.Cylinder_2D_r_z (
        nR=5,
        r_inner=data_RCTR.rs_ring_edge_inner[6],
        r_outer=data_RCTR.rs_ring_edge_outer[6],
        length_z=data_RCTR.length_reflA,
        nZ=reflA_lower.nV,
        angle_theta=data_RCTR.angle_reflA_ring_blockG),
    redeclare model InternalHeatModel =
        TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_2.GenericHeatGeneration
        (Q_gens=Qs_gen_reflA_lowerG),
    redeclare model DiffusionCoeff =
        TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.ArrheniusEquation
        (iTable={12}))                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-30,-60})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi
    reflA_lowerG_upper_bc(nPorts=reflA_lowerG.geometry.nR, showName=systemTF.showName)
                                                           annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,-30})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi
    reflA_lowerG_lower_bc(nPorts=reflA_lowerG.geometry.nR, showName=systemTF.showName)
                                                           annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-30,-90})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance_teeTOplenum(
      redeclare package Medium = Medium_PFL, R=1,
    showName=systemTF.showName)              annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-110})));
  Fluid.Volumes.MixingVolume tee_inlet(
    nPorts_b=1,
    T_start=data_PHX.T_outlet_tube,
    redeclare package Medium = Medium_PFL,
    p_start=data_PHX.p_inlet_tube + 200,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.Cylinder (
        length=data_RCTR.length_tee_inlet,
        crossArea=data_RCTR.crossArea_tee_inlet,
        angle=toggleStaticHead*90),
    nPorts_a=1,
    showName=systemTF.showName,
    mC_gen=mC_gen_tee_inlet,
    C_start=C_start_tee_inlet,
    Q_gen=Qs_gen_tee_inlet)              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-130})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface pipeFromPHX_PFL(
    nParallel=3,
    T_a_start=data_PHX.T_outlet_tube,
    redeclare package Medium = Medium_PFL,
    p_a_start=data_PHX.p_inlet_tube + 250,
    m_flow_a_start=2*3*data_PHX.m_flow_tube,
    showName=systemTF.showName,
    redeclare model InternalTraceGen =
        TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
        (mC_gens=mC_gens_pipeFromPHX_PFL),
    Cs_start=Cs_start_pipeFromPHX_PFL,
    redeclare model InternalHeatGen =
        TRANSFORM.Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.GenericHeatGeneration
        (Q_gens=Qs_gen_pipeFromPHX_PFL),
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        length=data_PIPING.length_PHXToRCTR,
        dimension=data_PIPING.D_PFL,
        dheight=toggleStaticHead*data_PIPING.height_PHXToRCTR,
        nV=nV_pipeFromPHX_PFL))
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={160,-70})));
  TRANSFORM.HeatExchangers.GenericDistributed_HX_withMass PHX(
    redeclare package Medium_shell = Medium_PCL,
    redeclare package Medium_tube = Medium_PFL,
    p_a_start_shell=data_PHX.p_inlet_shell,
    T_a_start_shell=data_PHX.T_inlet_shell,
    T_b_start_shell=data_PHX.T_outlet_shell,
    p_a_start_tube=data_PHX.p_inlet_tube,
    T_a_start_tube=data_PHX.T_inlet_tube,
    T_b_start_tube=data_PHX.T_outlet_tube,
    nParallel=2*3,
    m_flow_a_start_shell=2*3*data_PHX.m_flow_shell,
    m_flow_a_start_tube=2*3*data_PHX.m_flow_tube,
    redeclare model InternalTraceGen_tube =
        TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
        (mC_gens=mC_gens_PHX_tube),
    Cs_start_tube=Cs_start_PHX_tube,
    redeclare model InternalHeatGen_tube =
        TRANSFORM.Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.GenericHeatGeneration
        (Q_gens=Qs_gen_PHX_tube),
    redeclare model HeatTransfer_tube =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    redeclare model HeatTransfer_shell =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.FlowAcrossTubeBundles_Grimison
        (
        D=data_PHX.D_tube_outer,
        S_T=data_PHX.pitch_tube,
        S_L=data_PHX.pitch_tube,
        CFs=fill(
            0.44,
            PHX.shell.heatTransfer.nHT,
            PHX.shell.heatTransfer.nSurfaces)),
    redeclare package Material_wall = TRANSFORM.Media.Solids.AlloyN,
    nC=1,
    use_TraceMassTransfer_shell=true,
    use_TraceMassTransfer_tube=true,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ShellAndTubeHX
        (
        D_o_shell=data_PHX.D_shell_inner,
        nTubes=data_PHX.nTubes,
        nR=3,
        length_shell=data_PHX.length_tube,
        th_wall=data_PHX.th_tube,
        dimension_tube=data_PHX.D_tube_inner,
        length_tube=data_PHX.length_tube,
        nV=nV_PHX),
    redeclare model DiffusionCoeff_wall =
        TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.ArrheniusEquation
        (iTable={10}),
    Kb_wall_tubeSide=kS_PHX_tubeSide_wall.kSs,
    Ka_tubeSide=kH_PHX_tubeSide.kHs,
    redeclare model TraceMassTransfer_shell =
        TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D_MultiTransferSurface.Shs_SinglePhase_2Region
        (MMs={6.022e23}, redeclare model DiffusionCoeff =
            TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.ArrheniusEquation
            (iTable={1})),
    Ka_shellSide=kH_PHX_shellSide.kHs,
    Kb_wall_shellSide=kS_PHX_shellSide_wall.kSs,
    nb_wall_shellSide=fill(
        2,
        PHX.geometry.nV,
        Medium_PCL.nC),
    nb_wall_tubeSide=fill(
        2,
        PHX.geometry.nV,
        Medium_PCL.nC),
    redeclare model TraceMassTransfer_tube =
        TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D_MultiTransferSurface.Shs_SinglePhase_2Region
        (
        MMs={6.022e23},
        redeclare model DiffusionCoeff =
            TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.ArrheniusEquation
            (iTable={1}),
        iC={kinetics.summary_data.iH3}))
                        annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={160,0})));

  Fluid.Pipes.GenericPipe_MultiTransferSurface pipeToPHX_PFL(
    nParallel=3,
    redeclare package Medium = Medium_PFL,
    p_a_start=data_PHX.p_inlet_tube + 350,
    T_a_start=data_PHX.T_inlet_tube,
    m_flow_a_start=2*3*data_PHX.m_flow_tube,
    showName=systemTF.showName,
    redeclare model InternalTraceGen =
        TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
        (mC_gens=mC_gens_pipeToPHX_PFL),
    Cs_start=Cs_start_pipeToPHX_PFL,
    redeclare model InternalHeatGen =
        TRANSFORM.Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.GenericHeatGeneration
        (Q_gens=Qs_gen_pipeToPHX_PFL),
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=data_PIPING.D_PFL,
        length=data_PIPING.length_pumpToPHX,
        dheight=toggleStaticHead*data_PIPING.height_pumpToPHX,
        nV=nV_pipeToPHX_PFL))                                   annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={160,70})));
  Fluid.Machines.Pump_SimpleMassFlow pump_PFL(redeclare package Medium =
        Medium_PFL,
    m_flow_nominal=2*3*data_PHX.m_flow_tube,
    use_input=true)
    annotation (Placement(transformation(extent={{40,118},{60,138}})));
  Fluid.Volumes.ExpansionTank pumpBowl_PFL(
    redeclare package Medium = Medium_PFL,
    level_start=data_RCTR.level_pumpbowlnominal,
    showName=systemTF.showName,
    h_start=pumpBowl_PFL.Medium.specificEnthalpy_pT(pumpBowl_PFL.p_start,
        data_PHX.T_inlet_tube),
    A=3*data_RCTR.crossArea_pumpbowl,
    mC_gen=mC_gen_pumpBowl_PFL,
    C_start=C_start_pumpBowl_PFL,
    Q_gen=Qs_gen_pumpBowl_PFL)
    annotation (Placement(transformation(extent={{10,124},{30,144}})));

  UserInteraction.Outputs.SpatialPlot2 spatialPlot2_1(
    x1=PHX.tube.summary.xpos_norm,
    y1={PHX.tube.mediums[i].T for i in 1:PHX.geometry.nV},
    x2=if PHX.counterCurrent == true then Modelica.Math.Vectors.reverse(PHX.shell.summary.xpos_norm)
         else PHX.shell.summary.xpos_norm,
    y2={PHX.shell.mediums[i].T for i in 1:PHX.geometry.nV},
    maxY1=max({data_PHX.T_inlet_tube,data_PHX.T_inlet_shell,data_PHX.T_outlet_tube,
        data_PHX.T_outlet_shell}),
    minY1=min({data_SHX.T_inlet_tube,data_SHX.T_inlet_shell,data_SHX.T_outlet_tube,
        data_SHX.T_outlet_shell}))
    annotation (Placement(transformation(extent={{172,-206},{244,-134}})));
  inner TRANSFORM.Fluid.SystemTF systemTF(showName=false,
    showColors=true,
    val_max=data_PHX.T_inlet_tube,
    val_min=data_PHX.T_inlet_shell)
    annotation (Placement(transformation(extent={{200,120},{220,140}})));
  TRANSFORM.Nuclear.ReactorKinetics.PointKinetics_L1_atomBased_external
    kinetics(
    nV=fuelCell.nV,
    Q_nominal=data_RCTR.Q_nominal,
    mCs=fuelCell.mCs[:, kinetics.summary_data.iPG[1]:kinetics.summary_data.iPG[
        2]]*fuelCell.nParallel,
    mCs_FP=fuelCell.mCs[:, kinetics.summary_data.iFP[1]:kinetics.summary_data.iFP[
        2]]*fuelCell.nParallel,
    mCs_TR=fuelCell.mCs[:, kinetics.summary_data.iTR[1]:kinetics.summary_data.iTR[
        2]]*fuelCell.nParallel,
    Vs=fuelCell.Vs*fuelCell.nParallel,
    SigmaF_start=26,
    redeclare record Data =
        TRANSFORM.Nuclear.ReactorKinetics.Data.PrecursorGroups.precursorGroups_6_FLiBeFueledSalt,
    redeclare record Data_FP =
        TRANSFORM.Nuclear.ReactorKinetics.Data.FissionProducts.fissionProducts_cut6_U235_Pu239,
    redeclare record Data_TR =
        TRANSFORM.Nuclear.ReactorKinetics.Data.Tritium.FLiBe,
    nFeedback=2,
    vals_feedback={fuelCell.summary.T_effective,fuelCellG.summary.T_effective},
    Qs_fission_input=data_RCTR.Q_nominal*(1 - 0.12),
    vals_feedback_reference={649.114 + 273.15,649.385 + 273.15},
    alphas_feedback={-3.22e-5,2.35e-5},
    rhos_input=0.00337,
    redeclare record Data_CP =
        TRANSFORM.Nuclear.ReactorKinetics.Data.CorrosionProducts.corrosionProduct_1_Cr)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface
                                               pipeFromPHX_PCL(
    nParallel=3,
    showName=systemTF.showName,
    redeclare package Medium = Medium_PCL,
    p_a_start=data_PHX.p_inlet_shell - 50,
    T_a_start=data_PHX.T_outlet_shell,
    m_flow_a_start=2*3*data_PHX.m_flow_shell,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=data_PIPING.D_PCL,
        length=data_PIPING.length_PHXsToPump,
        dheight=toggleStaticHead*data_PIPING.height_PHXsToPump,
        nV=nV_pipeFromPHX_PCL))
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=180,
        origin={190,40})));
  TRANSFORM.Fluid.Volumes.ExpansionTank pumpBowl_PCL(
    level_start=data_RCTR.level_pumpbowlnominal,
    showName=systemTF.showName,
    redeclare package Medium = Medium_PCL,
    A=3*data_RCTR.crossArea_pumpbowl,
    h_start=pumpBowl_PCL.Medium.specificEnthalpy_pT(pumpBowl_PCL.p_start,
        data_SHX.T_outlet_shell))
    annotation (Placement(transformation(extent={{210,36},{230,56}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow pump_PCL(redeclare package
      Medium = Medium_PCL, m_flow_nominal=2*3*data_PHX.m_flow_shell,
    use_input=false)
    annotation (Placement(transformation(extent={{240,30},{260,50}})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface pipeToSHX_PCL(
    nParallel=3,
    showName=systemTF.showName,
    redeclare package Medium = Medium_PCL,
    T_a_start=data_PHX.T_outlet_shell,
    m_flow_a_start=2*3*data_PHX.m_flow_shell,
    p_a_start=data_PHX.p_inlet_shell + 300,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=data_PIPING.D_PCL,
        length=data_PIPING.length_pumpToSHX,
        dheight=toggleStaticHead*data_PIPING.height_pumpToSHX,
        nV=nV_pipeToSHX_PCL))               annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={280,40})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface
                                               pipeToPHX_PCL(
    showName=systemTF.showName,
    redeclare package Medium = Medium_PCL,
    m_flow_a_start=2*3*data_PHX.m_flow_shell,
    p_a_start=data_PHX.p_inlet_shell + 50,
    T_a_start=data_PHX.T_inlet_shell,
    nParallel=3,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=data_PIPING.D_PCL,
        length=data_PIPING.length_SHXToPHX,
        dheight=toggleStaticHead*data_PIPING.height_SHXToPHX,
        nV=nV_pipeToPHX_PCL))                                   annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={230,-40})));
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T
                                            boundary4(
    m_flow=2*3*data_SHX.m_flow_tube,
    T=data_SHX.T_inlet_tube,
    nPorts=1,
    showName=systemTF.showName,
    redeclare package Medium = Medium_BOP)
                              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={330,-40})));
  TRANSFORM.HeatExchangers.GenericDistributed_HX_withMass SHX(
    redeclare package Medium_shell = Medium_PCL,
    nParallel=2*3,
    p_a_start_shell=data_SHX.p_inlet_shell,
    T_a_start_shell=data_SHX.T_inlet_shell,
    T_b_start_shell=data_SHX.T_outlet_shell,
    m_flow_a_start_shell=2*3*data_SHX.m_flow_shell,
    p_a_start_tube=data_SHX.p_inlet_tube,
    T_a_start_tube=data_SHX.T_inlet_tube,
    T_b_start_tube=data_SHX.T_outlet_tube,
    m_flow_a_start_tube=2*3*data_SHX.m_flow_tube,
    redeclare model HeatTransfer_tube =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    redeclare model HeatTransfer_shell =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.FlowAcrossTubeBundles_Grimison
        (
        D=data_SHX.D_tube_outer,
        S_T=data_SHX.pitch_tube,
        S_L=data_SHX.pitch_tube,
        CFs=
           fill(
            0.44,
            SHX.shell.heatTransfer.nHT,
            SHX.shell.heatTransfer.nSurfaces)),
    redeclare package Material_wall = TRANSFORM.Media.Solids.AlloyN,
    nC=1,
    redeclare package Medium_tube = Medium_BOP,
    use_TraceMassTransfer_shell=true,
    use_TraceMassTransfer_tube=true,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ShellAndTubeHX
        (
        nR=3,
        D_o_shell=data_SHX.D_shell_inner,
        nTubes=data_SHX.nTubes,
        length_shell=data_SHX.length_tube,
        dimension_tube=data_SHX.D_tube_inner,
        length_tube=data_SHX.length_tube,
        th_wall=data_SHX.th_tube,
        nV=nV_SHX),
    redeclare model TraceMassTransfer_shell =
        TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D_MultiTransferSurface.Shs_SinglePhase_2Region
        (MMs={6.022e23}, redeclare model DiffusionCoeff =
            TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.ArrheniusEquation
            (iTable={1})),
    redeclare model DiffusionCoeff_wall =
        TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.ArrheniusEquation
        (iTable={10}),
    Ka_shellSide=kH_SHX_shellSide.kHs,
    Kb_wall_shellSide=kS_SHX_shellSide_wall.kSs,
    Ka_tubeSide=kH_SHX_tubeSide.kHs,
    Kb_wall_tubeSide=kS_SHX_tubeSide_wall.kSs,
    nb_wall_shellSide=fill(
        2,
        SHX.geometry.nV,
        Medium_PCL.nC),
    nb_wall_tubeSide=fill(
        2,
        SHX.geometry.nV,
        Medium_PCL.nC),
    redeclare model TraceMassTransfer_tube =
        TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D_MultiTransferSurface.Shs_SinglePhase_2Region
        (MMs={6.022e23}, redeclare model DiffusionCoeff =
            TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.ArrheniusEquation
            (use_RecordData=false, D_ab0=8.12e-4)))
                            annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={300,0})));

  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT
                                       boundary1(
    p=data_SHX.p_outlet_tube,
    T=data_SHX.T_outlet_tube,
    nPorts=1,
    showName=systemTF.showName,
    redeclare package Medium = Medium_BOP)
                             annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={330,40})));
  UserInteraction.Outputs.SpatialPlot2 spatialPlot2_2(
    x1=SHX.tube.summary.xpos_norm,
    y1={SHX.tube.mediums[i].T for i in 1:SHX.geometry.nV},
    x2=if SHX.counterCurrent == true then Modelica.Math.Vectors.reverse(SHX.shell.summary.xpos_norm)
         else SHX.shell.summary.xpos_norm,
    y2={SHX.shell.mediums[i].T for i in 1:SHX.geometry.nV},
    minY1=min({data_SHX.T_inlet_tube,data_SHX.T_inlet_shell,data_SHX.T_outlet_tube,
        data_SHX.T_outlet_shell}),
    maxY1=max({data_SHX.T_inlet_tube,data_SHX.T_inlet_shell,data_SHX.T_outlet_tube,
        data_SHX.T_outlet_shell}))
    annotation (Placement(transformation(extent={{260,-204},{330,-134}})));
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T boundary_OffGas_source(
    T=data_OFFGAS.T_sep_ref,
    redeclare package Medium = Medium_OffGas,
    m_flow=data_OFFGAS.m_flow_He_adsorber,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1,
    use_C_in=false,
    showName=systemTF.showName)
    annotation (Placement(transformation(extent={{-310,98},{-290,118}})));
  TRANSFORM.Fluid.TraceComponents.TraceDecayAdsorberBed adsorberBed(
    nV=10,
    redeclare package Medium = Medium_OffGas,
    d_adsorber=data_OFFGAS.d_carbon,
    cp_adsorber=data_OFFGAS.cp_carbon,
    tau_res=data_OFFGAS.delay_charcoalBed,
    R=data_OFFGAS.dp_carbon/data_OFFGAS.m_flow_He_adsorber,
    use_HeatPort=true,
    T_a_start=data_OFFGAS.T_carbon,
    showName=systemTF.showName,
    lambdas=kinetics.summary_data.lambdas,
    iC=8,
    parents=kinetics.summary_data.parents,
    Qs_decay=kinetics.summary_data.w_near_decay + kinetics.summary_data.w_far_decay)
    annotation (Placement(transformation(extent={{-230,-30},{-210,-10}})));
  TRANSFORM.Examples.MoltenSaltReactor.Data.data_OFFGAS
                   data_OFFGAS
    annotation (Placement(transformation(extent={{290,120},{310,140}})));
  Modelica.Blocks.Sources.RealExpression boundary_OffGas_m_flow(y=data_OFFGAS.m_flow_He_adsorber)
    annotation (Placement(transformation(extent={{-350,116},{-330,136}})));
  Modelica.Blocks.Sources.RealExpression boundary_OffGas_T(y=data_OFFGAS.T_sep_ref)
    annotation (Placement(transformation(extent={{-350,102},{-330,122}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature_multi boundary_thermal_adsorberBed(nPorts=
        adsorberBed.nV, T=fill(data_OFFGAS.T_carbon_wall, adsorberBed.nV),
    showName=systemTF.showName)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-220,10})));
  TRANSFORM.Fluid.Volumes.MixingVolume drainTank_gas(
    use_HeatPort=true,
    redeclare package Medium = Medium_OffGas,
    T_start=data_OFFGAS.T_drainTank,
    p_start=data_OFFGAS.p_drainTank,
    mC_gen=mC_gen_drainTank_gas,
    nPorts_b=2,
    nPorts_a=1,
    showName=systemTF.showName,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=data_OFFGAS.volume_drainTank_inner - drainTank_liquid.V),
    Q_gen=Qs_gen_drainTank_gas)
    annotation (Placement(transformation(extent={{-260,-10},{-240,-30}})));

  TRANSFORM.Fluid.Volumes.ExpansionTank drainTank_liquid(
    redeclare package Medium = Medium_PFL,
    p_surface=drainTank_gas.medium.p,
    h_start=pumpBowl_PFL.h_start,
    p_start=drainTank_gas.p_start,
    mC_gen=mC_gen_drainTank_liquid,
    use_HeatPort=true,
    A=data_OFFGAS.crossArea_drainTank_inner,
    level_start=0.20,
    showName=systemTF.showName,
    Q_gen=Qs_gen_drainTank_liquid)
    annotation (Placement(transformation(extent={{-260,-64},{-240,-44}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance_fromDrainTank(
    redeclare package Medium = Medium_PFL,
    R=1,
    showName=systemTF.showName) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-220,-60})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow pump_drainTank(redeclare package
      Medium = Medium_PFL, use_input=true)
    annotation (Placement(transformation(extent={{-200,-70},{-180,-50}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow pump_OffGas_bypass(use_input=true,
      redeclare package Medium = Medium_OffGas)
    annotation (Placement(transformation(extent={{-230,20},{-210,40}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow pump_OffGas_adsorberBed(use_input=
       true, redeclare package Medium = Medium_OffGas)
    annotation (Placement(transformation(extent={{-200,-30},{-180,-10}})));
  Modelica.Blocks.Sources.RealExpression m_flow_OffGas_bypass(y=
        boundary_OffGas_m_flow.y - m_flow_OffGas_adsorberBed.y)
    annotation (Placement(transformation(extent={{-252,30},{-232,50}})));
  Modelica.Blocks.Sources.RealExpression m_flow_OffGas_adsorberBed(y=
        data_OFFGAS.frac_gasSplit*boundary_OffGas_m_flow.y)
    annotation (Placement(transformation(extent={{-164,-10},{-184,10}})));
  TRANSFORM.Fluid.TraceComponents.TraceSeparator traceSeparator(m_flow_sepFluid=
       m_flow_toDrainTank, iSep=iOG,
    redeclare package Medium = Medium_PFL,
    redeclare package Medium_carrier = Medium_OffGas,
    showName=systemTF.showName,
    iCar=iOG)                        annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-270,90})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow pump_bypass(redeclare package
      Medium = Medium_PFL, use_input=true)
    annotation (Placement(transformation(extent={{-238,102},{-258,122}})));
  Modelica.Blocks.Sources.RealExpression m_flow_pump_bypass(y=x_bypass.y*abs(
        pump_PFL.port_a.m_flow))
    annotation (Placement(transformation(extent={{-278,116},{-258,136}})));
  Modelica.Blocks.Sources.RealExpression boundary_fromPump_PFL_bypass_p(y=
        pumpBowl_PFL.p)
    annotation (Placement(transformation(extent={{-142,28},{-162,48}})));
  Modelica.Blocks.Sources.Constant x_bypass(k=0.1)
    annotation (Placement(transformation(extent={{200,90},{220,110}})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface reflR(
    redeclare model HeatTransfer =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    T_a_start=data_PHX.T_outlet_tube,
    exposeState_b=true,
    p_a_start=data_PHX.p_inlet_tube + 100,
    redeclare package Medium = Medium_PFL,
    use_HeatTransfer=true,
    showName=systemTF.showName,
    nParallel=data_RCTR.nRegions,
    m_flow_a_start=0.05*data_RCTR.m_flow,
    redeclare model InternalTraceGen =
        TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
        (mC_gens=mC_gens_reflR),
    Cs_start=Cs_start_reflR,
    redeclare model InternalHeatGen =
        TRANSFORM.Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.GenericHeatGeneration
        (Q_gens=Qs_gen_reflR),
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        angle=toggleStaticHead*90,
        crossArea=data_RCTR.crossArea_reflR,
        perimeter=data_RCTR.perimeter_reflR,
        length=data_RCTR.length_reflR,
        surfaceArea={reflRG.nParallel/reflR.nParallel*sum(reflRG.geometry.crossAreas_1
            [1, :])},
        nV=fuelCell.nV),
    use_TraceMassTransfer=true,
    redeclare model TraceMassTransfer =
        TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D_MultiTransferSurface.Shs_SinglePhase_2Region
        (
        MMs={6.022e23},
        redeclare model DiffusionCoeff =
            TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.ArrheniusEquation
            (iTable={1}),
        iC={kinetics.summary_data.iH3}))  annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={20,0})));

  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.HMTransfer_2D reflRG(
    redeclare package Material =
        TRANSFORM.Media.Solids.Graphite.Graphite_0,
    exposeState_b2=true,
    exposeState_b1=true,
    T_a1_start=0.5*(data_PHX.T_outlet_tube + data_PHX.T_outlet_tube),
    T_a2_start=data_PHX.T_outlet_tube,
    showName=systemTF.showName,
    nParallel=2*data_RCTR.nRegions*data_RCTR.n_reflR_blockG,
    T_b1_start=0.5*(data_PHX.T_outlet_tube + data_PHX.T_outlet_tube),
    T_b2_start=data_PHX.T_outlet_tube,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Plane_2D
        (
        nX=5,
        nY=fuelCell.nV,
        length_x=0.5*data_RCTR.width_reflR_blockG,
        length_y=data_RCTR.length_reflR,
        length_z=data_RCTR.length_reflR_blockG),
    redeclare model InternalHeatModel =
        TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_2.GenericHeatGeneration
        (Q_gens=Qs_gen_reflRG),
    redeclare model DiffusionCoeff =
        TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.ArrheniusEquation
        (iTable={12}))                    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,0})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi reflRG_lower_bc(showName=
        systemTF.showName, nPorts=reflRG.geometry.nX) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={50,-30})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi reflRG_centerline_bc(showName=
        systemTF.showName, nPorts=reflR.nV)
    annotation (Placement(transformation(extent={{88,-10},{68,10}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi reflRG_upper_bc(showName=
        systemTF.showName, nPorts=reflRG.geometry.nX) annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={50,30})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance_reflR_inlet(
    redeclare package Medium = Medium_PFL,
    R=1,
    showName=systemTF.showName) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-30})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance_reflR_outlet(
    redeclare package Medium = Medium_PFL,
    R=1,
    showName=systemTF.showName) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,30})));

  TRANSFORM.Examples.MoltenSaltReactor.Data.Summary summary(
    nG_fuelCell=fuelCellG.nParallel,
    dims_fuelG_1=fuelCellG.geometry.length_x,
    dims_fuelG_2=fuelCellG.geometry.length_z,
    dims_fuelG_3=fuelCellG.geometry.length_y,
    nG_reflA_blocks=reflA_upperG.nParallel,
    dims_reflAG_1=reflA_upperG.geometry.r_inner,
    dims_reflAG_2=reflA_upperG.geometry.r_outer,
    dims_reflAG_3=reflA_upperG.geometry.length_z,
    dims_reflAG_4=reflA_upperG.geometry.angle_theta,
    nG_reflR_blocks=reflRG.nParallel,
    dims_reflRG_1=reflRG.geometry.length_x,
    dims_reflRG_2=reflRG.geometry.length_z,
    dims_reflRG_3=reflRG.geometry.length_y,
    redeclare package Medium_PFL = Medium_PFL,
    redeclare package Medium_OffGas = Medium_OffGas,
    redeclare package Material_Graphite =
        TRANSFORM.Media.Solids.Graphite.Graphite_0,
    redeclare package Material_Vessel = TRANSFORM.Media.Solids.AlloyN,
    m_reflAG=reflA_upperG.nParallel*sum(reflA_upperG.ms),
    m_reflA=reflA_upper.nParallel*sum(reflA_upper.ms),
    m_reflRG=reflRG.nParallel*sum(reflRG.ms),
    m_reflR=reflR.nParallel*sum(reflR.ms),
    crossArea_reflA=reflA_upper.nParallel*reflA_upper.geometry.crossArea,
    perimeter_reflA=reflA_upper.nParallel*reflA_upper.geometry.perimeter,
    crossArea_reflR=reflR.nParallel*reflR.geometry.crossArea,
    perimeter_reflR=reflR.nParallel*reflR.geometry.perimeter,
    crossArea_fuel=fuelCell.nParallel*fuelCell.geometry.crossArea,
    perimeter_fuel=fuelCell.nParallel*fuelCell.geometry.perimeter,
    surfaceArea_reflA=reflA_upper.nParallel*reflA_upper.geometry.surfaceArea_total,
    surfaceArea_reflR=reflR.nParallel*reflR.geometry.surfaceArea_total,
    surfaceArea_fuel=fuelCell.nParallel*fuelCell.geometry.surfaceArea_total,
    m_fuelG=fuelCellG.nParallel*sum(fuelCellG.ms),
    m_fuel=fuelCell.nParallel*sum(fuelCell.ms),
    m_plenum=plenum_upper.m,
    dims_pumpBowl_2=data_RCTR.length_pumpbowl,
    dims_pipeToPHX_1=pipeToPHX_PFL.geometry.dimension,
    dims_pipeToPHX_2=pipeToPHX_PFL.geometry.length,
    m_pipeToPHX_PFL=sum(pipeToPHX_PFL.ms),
    dims_pipeFromPHX_1=pipeFromPHX_PFL.geometry.dimension,
    dims_pipeFromPHX_2=pipeFromPHX_PFL.geometry.length,
    m_pipeFromPHX_PFL=sum(pipeFromPHX_PFL.ms),
    dims_pumpBowl_1=sqrt(4*pumpBowl_PFL.A/pi/3),
    m_pumpBowl=pumpBowl_PFL.m/3,
    level_nom_pumpBowl=data_RCTR.level_pumpbowlnominal,
    T_tube_inlet_PHX=data_PHX.T_inlet_tube,
    T_tube_outlet_PHX=data_PHX.T_outlet_tube,
    p_inlet_tube_PHX=data_PHX.p_inlet_tube,
    m_flow_tube_PHX=data_PHX.m_flow_tube,
    T_shell_inlet_PHX=data_PHX.T_inlet_shell,
    T_shell_outlet_PHX=data_PHX.T_outlet_shell,
    p_inlet_shell_PHX=data_PHX.p_inlet_shell,
    m_flow_shell_PHX=data_PHX.m_flow_shell,
    nTubes_PHX=PHX.geometry.nTubes,
    diameter_outer_tube_PHX=PHX.geometry.D_o_tube,
    th_tube_PHX=PHX.geometry.th_wall,
    length_tube_PHX=PHX.geometry.length_tube,
    tube_pitch_PHX=data_PHX.pitch_tube,
    m_tube_PHX=PHX.geometry.nTubes*sum(PHX.tube.ms),
    crossArea_shell_PHX=PHX.geometry.crossArea_shell,
    perimeter_shell_PHX=PHX.geometry.perimeter_shell,
    m_shell_PHX=sum(PHX.shell.ms),
    surfaceArea_shell_PHX=PHX.geometry.surfaceArea_shell[1],
    dp_tube_PHX=abs(PHX.port_a_tube.p - PHX.port_b_tube.p),
    dp_shell_PHX=abs(PHX.port_a_shell.p - PHX.port_b_shell.p),
    surfaceArea_tube_PHX=PHX.geometry.nTubes*PHX.geometry.surfaceArea_tube[1],
    m_tee_inlet=tee_inlet.m,
    redeclare package Medium_PCL = Medium_PCL,
    dims_pumpBowl_PCL_1=sqrt(4*pumpBowl_PCL.A/pi/3),
    dims_pumpBowl_PCL_2=data_RCTR.length_pumpbowl,
    level_nom_pumpBowl_PCL=data_RCTR.level_pumpbowlnominal,
    m_pumpBowl_PCL=pumpBowl_PCL.m/3,
    dims_pipePHXToPumpBowl_1=pipeFromPHX_PCL.geometry.dimension,
    dims_pipePHXToPumpBowl_2=pipeFromPHX_PCL.geometry.length,
    m_pipePHXToPumpBowl_PCL=sum(pipeFromPHX_PCL.ms),
    dims_pipePumpBowlToSHX_1=pipeToSHX_PCL.geometry.dimension,
    dims_pipePumpBowlToSHX_2=pipeToSHX_PCL.geometry.length,
    m_pipePumpBowlToSHX_PCL=sum(pipeToSHX_PCL.ms),
    dims_pipeSHXToPHX_1=pipeToPHX_PCL.geometry.dimension,
    dims_pipeSHXToPHX_2=pipeToPHX_PCL.geometry.length,
    m_pipeSHXToPHX_PCL=sum(pipeToPHX_PCL.ms),
    T_tube_inlet_SHX=data_SHX.T_inlet_tube,
    T_tube_outlet_SHX=data_SHX.T_outlet_tube,
    p_inlet_tube_SHX=data_SHX.p_inlet_tube,
    dp_tube_SHX=abs(SHX.port_a_tube.p - SHX.port_b_tube.p),
    m_flow_tube_SHX=data_SHX.m_flow_tube,
    T_shell_inlet_SHX=data_SHX.T_inlet_shell,
    T_shell_outlet_SHX=data_SHX.T_outlet_shell,
    p_inlet_shell_SHX=data_SHX.p_inlet_shell,
    dp_shell_SHX=abs(SHX.port_a_shell.p - SHX.port_b_shell.p),
    m_flow_shell_SHX=data_SHX.m_flow_shell,
    nTubes_SHX=SHX.geometry.nTubes,
    diameter_outer_tube_SHX=SHX.geometry.D_o_tube,
    th_tube_SHX=SHX.geometry.th_wall,
    length_tube_SHX=SHX.geometry.length_tube,
    tube_pitch_SHX=data_SHX.pitch_tube,
    surfaceArea_tube_SHX=SHX.geometry.nTubes*SHX.geometry.surfaceArea_tube[1],
    m_tube_SHX=SHX.geometry.nTubes*sum(SHX.tube.ms),
    crossArea_shell_SHX=SHX.geometry.crossArea_shell,
    perimeter_shell_SHX=SHX.geometry.perimeter_shell,
    surfaceArea_shell_SHX=SHX.geometry.surfaceArea_shell[1],
    m_shell_SHX=sum(SHX.shell.ms),
    redeclare package Medium_BOP = Modelica.Media.Water.StandardWater,
    alpha_reflA=sum(reflA_upper.heatTransfer.alphas)/reflA_upper.nV,
    alpha_reflR=sum(reflR.heatTransfer.alphas)/reflR.nV,
    alpha_fuel=sum(fuelCell.heatTransfer.alphas)/fuelCell.nV,
    alpha_tube_PHX=sum(PHX.tube.heatTransfer.alphas)/PHX.tube.nV,
    alpha_shell_PHX=sum(PHX.shell.heatTransfer.alphas)/PHX.shell.nV,
    alpha_tube_SHX=sum(SHX.tube.heatTransfer.alphas)/SHX.tube.nV,
    alpha_shell_SHX=sum(SHX.shell.heatTransfer.alphas)/SHX.shell.nV)
    annotation (Placement(transformation(extent={{260,120},{280,140}})));

  TRANSFORM.Examples.MoltenSaltReactor.Components.DRACS DRACS(
    redeclare package Medium_DRACS = Medium_DRACS,
    showName=systemTF.showName,
    surfaceAreas_thimble=DRACS.thimble_outer_drainTank.surfaceArea_outer*DRACS.nP_outer_drainTank[
        1].nParallel*{drainTank_liquid.level/data_OFFGAS.length_drainTank_inner,
        1 - drainTank_liquid.level/data_OFFGAS.length_drainTank_inner},
    alphas_drainTank={5000,1000})
    annotation (Placement(transformation(extent={{-354,-96},{-284,-16}})));
  Modelica.Blocks.Sources.RealExpression m_flow_pump_PFL(y=2*3*data_PHX.m_flow_tube
        /(1 - x_bypass.y))
    annotation (Placement(transformation(extent={{76,132},{56,152}})));
protected
  Modelica.Blocks.Sources.RealExpression boundary_OffGas_T1(y=drainTank_liquid.port_a.m_flow)
    annotation (Placement(transformation(extent={{-222,-52},{-202,-32}})));
public
  TRANSFORM.Media.ClosureModels.HenrysLawCoefficient.Models.ExponentialTemperature
    kH_PHX_tubeSide[PHX.geometry.nV](
    T=PHX.tube.mediums.T,
    each iTable={1},
    each nC=Medium_PCL.nC)
    annotation (Placement(transformation(extent={{-300,-180},{-280,-160}})));
  TRANSFORM.Media.ClosureModels.SievertsLawCoefficient.Models.ArrheniusEquation
    kS_PHX_tubeSide_wall[PHX.geometry.nV](
    each iTable={9},
    T=PHX.tube.mediums.T,
    each nC=Medium_PCL.nC)
    annotation (Placement(transformation(extent={{-260,-180},{-240,-160}})));
  TRANSFORM.Media.ClosureModels.HenrysLawCoefficient.Models.ExponentialTemperature
    kH_PHX_shellSide[PHX.geometry.nV](
    each iTable={1},
    each nC=Medium_PCL.nC,
    T=PHX.shell.mediums.T)
    annotation (Placement(transformation(extent={{-300,-200},{-280,-180}})));
  TRANSFORM.Media.ClosureModels.SievertsLawCoefficient.Models.ArrheniusEquation
    kS_PHX_shellSide_wall[PHX.geometry.nV](
    each iTable={9},
    each nC=Medium_PCL.nC,
    T=PHX.shell.mediums.T)
    annotation (Placement(transformation(extent={{-260,-200},{-240,-180}})));
  TRANSFORM.Media.ClosureModels.HenrysLawCoefficient.Models.ExponentialTemperature
    kH_SHX_tubeSide[SHX.geometry.nV](
    each nC=Medium_PCL.nC,
    T=SHX.tube.mediums.T,
    each use_RecordData=false,
    each kH0=7.7e-6)
    annotation (Placement(transformation(extent={{-180,-180},{-160,-160}})));
  TRANSFORM.Media.ClosureModels.SievertsLawCoefficient.Models.ArrheniusEquation
    kS_SHX_tubeSide_wall[SHX.geometry.nV](
    each iTable={9},
    each nC=Medium_PCL.nC,
    T=SHX.tube.mediums.T)
    annotation (Placement(transformation(extent={{-220,-180},{-200,-160}})));
  TRANSFORM.Media.ClosureModels.HenrysLawCoefficient.Models.ExponentialTemperature
    kH_SHX_shellSide[SHX.geometry.nV](
    each iTable={1},
    each nC=Medium_PCL.nC,
    T=SHX.shell.mediums.T)
    annotation (Placement(transformation(extent={{-180,-200},{-160,-180}})));
  TRANSFORM.Media.ClosureModels.SievertsLawCoefficient.Models.ArrheniusEquation
    kS_SHX_shellSide_wall[SHX.geometry.nV](
    each iTable={9},
    each nC=Medium_PCL.nC,
    T=SHX.shell.mediums.T)
    annotation (Placement(transformation(extent={{-220,-200},{-200,-180}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Mass.AdiabaticMass_multi
    fuelCellG_centerline_bcM(showName=systemTF.showName, nPorts=fuelCell.nV)
    annotation (Placement(transformation(extent={{-68,-2},{-48,-22}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Mass.AdiabaticMass_multi
    fuelCellG_lower_bcM(showName=systemTF.showName, nPorts=fuelCellG.geometry.nX)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-42,-30})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Mass.AdiabaticMass_multi
    fuelCellG_upper_bcM(showName=systemTF.showName, nPorts=fuelCellG.geometry.nX)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-42,30})));
public
  TRANSFORM.Media.ClosureModels.HenrysLawCoefficient.Models.ExponentialTemperature
    kH_core[fuelCell.geometry.nV](each iTable={1}, T=fuelCell.mediums.T)
    annotation (Placement(transformation(extent={{-100,-160},{-80,-140}})));
  TRANSFORM.Media.ClosureModels.SievertsLawCoefficient.Models.ArrheniusEquation
    kS_coreG[fuelCell.geometry.nV](T=fuelCell.mediums.T, each iTable={11})
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
  TRANSFORM.HeatAndMassTransfer.Resistances.Mass.SolubilityInterface
    interface_fuelCell[fuelCell.nV](
    showName=systemTF.showName,
    Ka=kH_core.kHs,
    Kb=kS_coreG.kSs,
    each nb={2})
    annotation (Placement(transformation(extent={{-8,-8},{-16,0}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Mass.AdiabaticMass_multi
    reflRG_lower_bcM(showName=systemTF.showName, nPorts=reflRG.geometry.nX)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={62,-30})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Mass.AdiabaticMass_multi
    reflRG_centerline_bcM(showName=systemTF.showName, nPorts=reflR.nV)
    annotation (Placement(transformation(extent={{88,-2},{68,-22}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Mass.AdiabaticMass_multi
    reflRG_upper_bcM(showName=systemTF.showName, nPorts=reflRG.geometry.nX)
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={62,30})));
  TRANSFORM.HeatAndMassTransfer.Resistances.Mass.SolubilityInterface
    interface_reflR[reflR.nV](
    showName=systemTF.showName,
    each nb={2},
    Ka=kH_reflR.kHs,
    Kb=kS_reflRG.kSs)
    annotation (Placement(transformation(extent={{28,-8},{36,0}})));
public
  TRANSFORM.Media.ClosureModels.HenrysLawCoefficient.Models.ExponentialTemperature
    kH_reflR[reflR.geometry.nV](each iTable={1}, T=reflR.mediums.T)
    annotation (Placement(transformation(extent={{-100,-180},{-80,-160}})));
  TRANSFORM.Media.ClosureModels.SievertsLawCoefficient.Models.ArrheniusEquation
    kS_reflRG[reflR.geometry.nV](each iTable={11}, T=reflR.mediums.T)
    annotation (Placement(transformation(extent={{-60,-180},{-40,-160}})));
public
  TRANSFORM.Media.ClosureModels.HenrysLawCoefficient.Models.ExponentialTemperature
    kH_reflA_upper[reflA_upper.geometry.nV](each iTable={1}, T=reflA_upper.mediums.T)
    annotation (Placement(transformation(extent={{-100,-200},{-80,-180}})));
  TRANSFORM.Media.ClosureModels.SievertsLawCoefficient.Models.ArrheniusEquation
    kS_reflAG_upper[reflA_upper.geometry.nV](each iTable={11}, T=reflA_upper.mediums.T)
    annotation (Placement(transformation(extent={{-60,-200},{-40,-180}})));
public
  TRANSFORM.Media.ClosureModels.HenrysLawCoefficient.Models.ExponentialTemperature
    kH_reflA_lower[reflA_lower.geometry.nV](each iTable={1}, T=reflA_lower.mediums.T)
    annotation (Placement(transformation(extent={{-100,-220},{-80,-200}})));
  TRANSFORM.Media.ClosureModels.SievertsLawCoefficient.Models.ArrheniusEquation
    kS_reflAG_lower[reflA_lower.geometry.nV](each iTable={11}, T=reflA_lower.mediums.T)
    annotation (Placement(transformation(extent={{-60,-220},{-40,-200}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Mass.AdiabaticMass_multi
    reflA_upperG_upper_bcM(showName=systemTF.showName, nPorts=reflA_upperG.geometry.nR)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-42,90})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Mass.AdiabaticMass_multi
    reflA_upperG_lower_bcM(showName=systemTF.showName, nPorts=reflA_upperG.geometry.nR)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-42,30})));
  TRANSFORM.HeatAndMassTransfer.Resistances.Mass.SolubilityInterface
    interface_reflA_upper1[reflA_upper.nV](
    showName=systemTF.showName,
    each nb={2},
    Ka=kH_reflA_upper.kHs,
    Kb=kS_reflAG_upper.kSs)
    annotation (Placement(transformation(extent={{-8,52},{-16,60}})));
  TRANSFORM.HeatAndMassTransfer.Resistances.Mass.SolubilityInterface
    interface_reflA_upper2[reflA_upper.nV](
    showName=systemTF.showName,
    each nb={2},
    Ka=kH_reflA_upper.kHs,
    Kb=kS_reflAG_upper.kSs)
    annotation (Placement(transformation(extent={{-8,42},{-16,50}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Mass.AdiabaticMass_multi
    reflA_lowerG_upper_bcM(showName=systemTF.showName, nPorts=reflA_lowerG.geometry.nR)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-42,-30})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Mass.AdiabaticMass_multi
    reflA_lowerG_lower_bcM(showName=systemTF.showName, nPorts=reflA_lowerG.geometry.nR)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-42,-90})));
  TRANSFORM.HeatAndMassTransfer.Resistances.Mass.SolubilityInterface
    interface_reflA_lower1[reflA_lower.nV](
    showName=systemTF.showName,
    each nb={2},
    Ka=kH_reflA_lower.kHs,
    Kb=kS_reflAG_lower.kSs)
    annotation (Placement(transformation(extent={{-8,-68},{-16,-60}})));
  TRANSFORM.HeatAndMassTransfer.Resistances.Mass.SolubilityInterface
    interface_reflA_lower2[reflA_lower.nV](
    showName=systemTF.showName,
    each nb={2},
    Ka=kH_reflA_lower.kHs,
    Kb=kS_reflAG_lower.kSs)
    annotation (Placement(transformation(extent={{-8,-78},{-16,-70}})));
  TRANSFORM.HeatAndMassTransfer.Volumes.UnitVolume_wTraceMass volume[PHX.geometry.nV](
    V=PHX.tubeWall.Vs[1, :]*PHX.tubeWall.nParallel,
    d=PHX.tubeWall.materials[1, :].d,
    cp=PHX.tubeWall.Material.specificHeatCapacityCp_T(PHX.tubeWall.materials[1,
        :].T),
    T_start=PHX.Ts_start_wall_tubeSide,
    each C_start={C_start_Cr})
    annotation (Placement(transformation(extent={{100,-68},{120,-48}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature_multi
    boundary2(nPorts=PHX.geometry.nV, use_port=true)
    annotation (Placement(transformation(extent={{74,-92},{94,-72}})));
  Modelica.Blocks.Sources.RealExpression realExpression[PHX.geometry.nV](y=PHX.tubeWall.materials[
        1, :].T)
    annotation (Placement(transformation(extent={{50,-92},{70,-72}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Mass.MassFlow_multi boundary(
      nPorts=PHX.geometry.nV, use_port=true)
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));
  Modelica.Blocks.Sources.RealExpression realExpression1[PHX.geometry.nV](y=
        n_flows_Cr)
    annotation (Placement(transformation(extent={{58,-110},{78,-90}})));
equation
  connect(resistance_fuelCell_outlet.port_a, fuelCell.port_b)
    annotation (Line(points={{0,23},{0,10},{4.44089e-16,10}},
                                           color={0,127,255}));
  connect(reflA_upper.port_a, resistance_fuelCell_outlet.port_b)
    annotation (Line(points={{0,50},{0,37}}, color={0,127,255}));
  connect(plenum_lower.port_b[1], reflA_lower.port_a) annotation (Line(points={{
          4.44089e-16,-84},{4.44089e-16,-70},{-6.66134e-16,-70}}, color={0,127,255}));
  connect(reflA_lower.port_b, resistance_fuelCell_inlet.port_a)
    annotation (Line(points={{0,-50},{0,-37}}, color={0,127,255}));
  connect(resistance_fuelCell_inlet.port_b, fuelCell.port_a)
    annotation (Line(points={{0,-23},{0,-10}}, color={0,127,255}));
  connect(reflA_upper.port_b, plenum_upper.port_a[1])
    annotation (Line(points={{0,70},{0,84}}, color={0,127,255}));
  connect(resistance_toPump_PFL.port_a, plenum_upper.port_b[1]) annotation (
      Line(points={{-4.44089e-16,105},{-4.44089e-16,100.5},{3.33067e-16,100.5},{
          3.33067e-16,96}}, color={0,127,255}));
  connect(fuelCellG.port_a1, fuelCell.heatPorts[:, 1])
    annotation (Line(points={{-20,0},{-5,0}}, color={191,0,0}));
  connect(fuelCellG_centerline_bc.port, fuelCellG.port_b1)
    annotation (Line(points={{-48,0},{-40,0}}, color={191,0,0}));
  connect(fuelCellG_lower_bc.port, fuelCellG.port_a2)
    annotation (Line(points={{-30,-20},{-30,-10}}, color={191,0,0}));
  connect(fuelCellG_upper_bc.port, fuelCellG.port_b2)
    annotation (Line(points={{-30,20},{-30,10}}, color={191,0,0}));
  connect(reflA_upperG_lower_bc.port, reflA_upperG.port_a2)
    annotation (Line(points={{-30,40},{-30,50}}, color={191,0,0}));
  connect(reflA_upperG_upper_bc.port, reflA_upperG.port_b2)
    annotation (Line(points={{-30,80},{-30,70}}, color={191,0,0}));
  connect(reflA_upperG.port_a1, reflA_upper.heatPorts[:, 1])
    annotation (Line(points={{-20,60},{-5,60}}, color={191,0,0}));
  connect(reflA_lowerG_lower_bc.port, reflA_lowerG.port_a2)
    annotation (Line(points={{-30,-80},{-30,-70}}, color={191,0,0}));
  connect(reflA_lowerG_upper_bc.port, reflA_lowerG.port_b2)
    annotation (Line(points={{-30,-40},{-30,-50}}, color={191,0,0}));
  connect(reflA_lowerG.port_a1, reflA_lower.heatPorts[:, 1])
    annotation (Line(points={{-20,-60},{-5,-60}}, color={191,0,0}));
  connect(reflA_upperG.port_b1, reflA_upper.heatPorts[:, 2]) annotation (Line(
        points={{-40,60},{-44,60},{-44,64},{-12,64},{-12,60},{-5,60}}, color={191,
          0,0}));
  connect(reflA_lowerG.port_b1, reflA_lower.heatPorts[:, 2]) annotation (Line(
        points={{-40,-60},{-44,-60},{-44,-56},{-12,-56},{-12,-60},{-5,-60}},
        color={191,0,0}));
  connect(plenum_lower.port_a[1], resistance_teeTOplenum.port_b)
    annotation (Line(points={{0,-96},{0,-103}}, color={0,127,255}));
  connect(resistance_teeTOplenum.port_a, tee_inlet.port_b[1])
    annotation (Line(points={{0,-117},{0,-124}}, color={0,127,255}));
  connect(pipeToPHX_PFL.port_b, PHX.port_a_tube)
    annotation (Line(points={{160,60},{160,10}},
                                               color={0,127,255}));
  connect(pump_PFL.port_b, pipeToPHX_PFL.port_a)
    annotation (Line(points={{60,128},{160,128},{160,80}},
                                                         color={0,127,255}));
  connect(pump_PFL.port_a, pumpBowl_PFL.port_b)
    annotation (Line(points={{40,128},{34,128},{34,128},{27,128}},
                                                 color={0,127,255}));
  connect(pumpBowl_PFL.port_a, resistance_toPump_PFL.port_b)
    annotation (Line(points={{13,128},{0,128},{0,119}}, color={0,127,255}));
  connect(pipeFromPHX_PFL.port_a, PHX.port_b_tube)
    annotation (Line(points={{160,-60},{160,-10}},
                                                 color={0,127,255}));
  connect(pipeFromPHX_PFL.port_b, tee_inlet.port_a[1]) annotation (Line(points={{160,-80},
          {160,-140},{-4.44089e-16,-140},{-4.44089e-16,-136}},
                                                 color={0,127,255}));
  connect(PHX.port_b_shell, pipeFromPHX_PCL.port_a) annotation (Line(points={{164.6,
          10},{164,10},{164,40},{180,40}},
                                         color={0,127,255}));
  connect(pipeFromPHX_PCL.port_b, pumpBowl_PCL.port_a)
    annotation (Line(points={{200,40},{213,40}}, color={0,127,255}));
  connect(pumpBowl_PCL.port_b, pump_PCL.port_a)
    annotation (Line(points={{227,40},{240,40}}, color={0,127,255}));
  connect(pump_PCL.port_b, pipeToSHX_PCL.port_a)
    annotation (Line(points={{260,40},{270,40}}, color={0,127,255}));
  connect(pipeToPHX_PCL.port_a, SHX.port_b_shell) annotation (Line(points={{240,-40},
          {295.4,-40},{295.4,-10}},      color={0,127,255}));
  connect(pipeToSHX_PCL.port_b, SHX.port_a_shell) annotation (Line(points={{290,40},
          {295.4,40},{295.4,10}},     color={0,127,255}));
  connect(boundary1.ports[1], SHX.port_b_tube)
    annotation (Line(points={{320,40},{300,40},{300,10}}, color={0,127,255}));
  connect(SHX.port_a_tube, boundary4.ports[1]) annotation (Line(points={{300,-10},
          {300,-40},{320,-40}}, color={0,127,255}));
  connect(pipeToPHX_PCL.port_b, PHX.port_a_shell) annotation (Line(points={{220,-40},
          {164.6,-40},{164.6,-10}},    color={0,127,255}));
  connect(boundary_OffGas_T.y, boundary_OffGas_source.T_in) annotation (Line(
        points={{-329,112},{-312,112}},                       color={0,0,127}));
  connect(boundary_OffGas_m_flow.y, boundary_OffGas_source.m_flow_in)
    annotation (Line(points={{-329,126},{-320,126},{-320,116},{-310,116}},
                                                                         color={
          0,0,127}));
  connect(boundary_thermal_adsorberBed.port, adsorberBed.heatPorts)
    annotation (Line(points={{-220,0},{-220,-15}},color={191,0,0}));
  connect(drainTank_liquid.port_b, resistance_fromDrainTank.port_a)
    annotation (Line(points={{-243,-60},{-227,-60}}, color={0,127,255}));
  connect(resistance_fromDrainTank.port_b, pump_drainTank.port_a)
    annotation (Line(points={{-213,-60},{-200,-60}}, color={0,127,255}));
  connect(adsorberBed.port_b, pump_OffGas_adsorberBed.port_a)
    annotation (Line(points={{-210,-20},{-200,-20}},
                                                 color={0,127,255}));
  connect(m_flow_OffGas_bypass.y, pump_OffGas_bypass.in_m_flow) annotation (
      Line(points={{-231,40},{-220,40},{-220,37.3}}, color={0,0,127}));
  connect(m_flow_OffGas_adsorberBed.y, pump_OffGas_adsorberBed.in_m_flow)
    annotation (Line(points={{-185,0},{-190,0},{-190,-12.7}}, color={0,0,127}));
  connect(boundary_OffGas_source.ports[1], traceSeparator.port_a_carrier)
    annotation (Line(points={{-290,108},{-276,108},{-276,100}},        color={0,
          127,255}));
  connect(m_flow_pump_bypass.y, pump_bypass.in_m_flow) annotation (Line(points={{-257,
          126},{-248,126},{-248,119.3}},        color={0,0,127}));
  connect(adsorberBed.port_a, drainTank_gas.port_b[1]) annotation (Line(points={{-230,
          -20},{-238,-20},{-238,-19.5},{-244,-19.5}},       color={0,127,255}));
  connect(pump_bypass.port_b, traceSeparator.port_a) annotation (Line(points={{-258,
          112},{-264,112},{-264,100}}, color={0,127,255}));
  connect(traceSeparator.port_sepFluid, drainTank_liquid.port_a) annotation (
      Line(points={{-270,80},{-270,-60},{-257,-60}},           color={0,127,255}));
  connect(traceSeparator.port_b_carrier, drainTank_gas.port_a[1]) annotation (
      Line(points={{-276,80},{-276,-20},{-256,-20}}, color={0,127,255}));
  connect(pump_OffGas_bypass.port_a, drainTank_gas.port_b[2]) annotation (Line(
        points={{-230,30},{-238,30},{-238,-20.5},{-244,-20.5}}, color={0,127,255}));
  connect(pump_OffGas_bypass.port_b, boundary_OffGas_sink.ports[1]) annotation (
     Line(points={{-210,30},{-200,30},{-200,32},{-190,32}}, color={0,127,255}));
  connect(pump_OffGas_adsorberBed.port_b, boundary_OffGas_sink.ports[2])
    annotation (Line(points={{-180,-20},{-158,-20},{-158,16},{-198,16},{-198,28},
          {-190,28}}, color={0,127,255}));
  connect(boundary_fromPump_PFL_bypass_p.y, boundary_OffGas_sink.p_in)
    annotation (Line(points={{-163,38},{-168,38}},                     color={0,
          0,127}));
  connect(traceSeparator.port_b, pumpBowl_PFL.port_a) annotation (Line(points={{-264,80},
          {-264,70},{-140,70},{-140,128},{13,128}},
        color={0,127,255}));
  connect(pump_drainTank.port_b, pumpBowl_PFL.port_a) annotation (Line(points={{-180,
          -60},{-140,-60},{-140,128},{13,128}},
                 color={0,127,255}));
  connect(pump_bypass.port_a, pipeToPHX_PFL.port_a) annotation (Line(points={{-238,
          112},{-230,112},{-230,150},{160,150},{160,80}},      color={0,127,255}));
  connect(resistance_reflR_outlet.port_b, reflA_upper.port_a) annotation (Line(
        points={{20,37},{20,42},{0,42},{0,50}}, color={0,127,255}));
  connect(reflR.port_a, resistance_reflR_inlet.port_b)
    annotation (Line(points={{20,-10},{20,-23}}, color={0,127,255}));
  connect(resistance_reflR_inlet.port_a, reflA_lower.port_b) annotation (Line(
        points={{20,-37},{20,-46},{0,-46},{0,-50}}, color={0,127,255}));
  connect(resistance_reflR_outlet.port_a, reflR.port_b)
    annotation (Line(points={{20,23},{20,10}}, color={0,127,255}));
  connect(reflRG.port_a1, reflR.heatPorts[:, 1])
    annotation (Line(points={{40,0},{25,0}}, color={191,0,0}));
  connect(reflRG.port_a2, reflRG_lower_bc.port)
    annotation (Line(points={{50,-10},{50,-20}}, color={191,0,0}));
  connect(reflRG.port_b1, reflRG_centerline_bc.port)
    annotation (Line(points={{60,0},{68,0}}, color={191,0,0}));
  connect(reflRG.port_b2, reflRG_upper_bc.port)
    annotation (Line(points={{50,10},{50,20}}, color={191,0,0}));
  connect(drainTank_liquid.heatPort, DRACS.port_thimbleWall[1]) annotation (
      Line(points={{-250,-62.4},{-250,-82},{-284,-82}}, color={191,0,0}));
  connect(drainTank_gas.heatPort, DRACS.port_thimbleWall[2]) annotation (Line(
        points={{-250,-14},{-250,-8},{-260,-8},{-260,-78},{-284,-78}}, color={
          191,0,0}));
  connect(m_flow_pump_PFL.y, pump_PFL.in_m_flow)
    annotation (Line(points={{55,142},{50,142},{50,135.3}}, color={0,0,127}));
  connect(boundary_OffGas_T1.y, pump_drainTank.in_m_flow) annotation (Line(
        points={{-201,-42},{-190,-42},{-190,-52.7}}, color={0,0,127}));
  connect(fuelCellG_centerline_bcM.port, fuelCellG.portM_b1) annotation (Line(
        points={{-48,-12},{-44,-12},{-44,-4},{-40,-4}}, color={0,140,72}));
  connect(fuelCellG_lower_bcM.port, fuelCellG.portM_a2) annotation (Line(points=
         {{-42,-20},{-42,-16},{-34,-16},{-34,-9.8}}, color={0,140,72}));
  connect(fuelCellG_upper_bcM.port, fuelCellG.portM_b2) annotation (Line(points=
         {{-42,20},{-42,16},{-34,16},{-34,10}}, color={0,140,72}));
  connect(interface_fuelCell.port_b, fuelCellG.portM_a1)
    annotation (Line(points={{-14.8,-4},{-20,-4}}, color={0,140,72}));
  connect(interface_fuelCell.port_a, fuelCell.massPorts[:, 1])
    annotation (Line(points={{-9.2,-4},{-5,-4}}, color={0,140,72}));
  connect(reflRG_centerline_bcM.port, reflRG.portM_b1) annotation (Line(points=
          {{68,-12},{66,-12},{66,-4},{60,-4}}, color={0,140,72}));
  connect(reflRG_lower_bcM.port, reflRG.portM_a2) annotation (Line(points={{62,
          -20},{62,-16},{54,-16},{54,-9.8}}, color={0,140,72}));
  connect(reflRG_upper_bcM.port, reflRG.portM_b2) annotation (Line(points={{62,
          20},{62,16},{54,16},{54,10}}, color={0,140,72}));
  connect(interface_reflR.port_b, reflRG.portM_a1)
    annotation (Line(points={{34.8,-4},{40,-4}}, color={0,140,72}));
  connect(reflR.massPorts[:, 1], interface_reflR.port_a)
    annotation (Line(points={{25,-4},{29.2,-4}}, color={0,140,72}));
  connect(reflA_upperG_lower_bcM.port, reflA_upperG.portM_a2) annotation (Line(
        points={{-42,40},{-42,44},{-34,44},{-34,50.2}}, color={0,140,72}));
  connect(reflA_upperG_upper_bcM.port, reflA_upperG.portM_b2) annotation (Line(
        points={{-42,80},{-42,76},{-34,76},{-34,70}}, color={0,140,72}));
  connect(interface_reflA_upper1.port_b, reflA_upperG.portM_a1)
    annotation (Line(points={{-14.8,56},{-20,56}}, color={0,140,72}));
  connect(interface_reflA_upper1.port_a, reflA_upper.massPorts[:, 1])
    annotation (Line(points={{-9.2,56},{-5,56}}, color={0,140,72}));
  connect(interface_reflA_upper2.port_a, reflA_upper.massPorts[:, 2])
    annotation (Line(points={{-9.2,46},{-8,46},{-8,56},{-5,56}}, color={0,140,
          72}));
  connect(interface_reflA_upper2.port_b, reflA_upperG.portM_b1) annotation (
      Line(points={{-14.8,46},{-44,46},{-44,56},{-40,56}}, color={0,140,72}));
  connect(reflA_lowerG_lower_bcM.port, reflA_lowerG.portM_a2) annotation (Line(
        points={{-42,-80},{-42,-76},{-34,-76},{-34,-69.8}}, color={0,140,72}));
  connect(reflA_lowerG_upper_bcM.port, reflA_lowerG.portM_b2) annotation (Line(
        points={{-42,-40},{-42,-44},{-34,-44},{-34,-50}}, color={0,140,72}));
  connect(interface_reflA_lower2.port_b, reflA_lowerG.portM_b1) annotation (
      Line(points={{-14.8,-74},{-40,-74},{-40,-64}}, color={0,140,72}));
  connect(interface_reflA_lower1.port_a, reflA_lower.massPorts[:, 1])
    annotation (Line(points={{-9.2,-64},{-5,-64}}, color={0,140,72}));
  connect(interface_reflA_lower1.port_b, reflA_lowerG.portM_a1)
    annotation (Line(points={{-14.8,-64},{-20,-64}}, color={0,140,72}));
  connect(interface_reflA_lower2.port_a, reflA_lower.massPorts[:, 2])
    annotation (Line(points={{-9.2,-74},{-8,-74},{-8,-64},{-5,-64}}, color={0,
          140,72}));
  connect(boundary2.port, volume.port)
    annotation (Line(points={{94,-82},{110,-82},{110,-68}}, color={191,0,0}));
  connect(realExpression.y, boundary2.T_ext)
    annotation (Line(points={{71,-82},{80,-82}}, color={0,0,127}));
  connect(boundary.port, volume.portM) annotation (Line(points={{100,-100},{114,
          -100},{114,-68}}, color={0,140,72}));
  connect(realExpression1.y, boundary.n_flow_ext[:, 1])
    annotation (Line(points={{79,-100},{86,-100}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-360,
            -220},{340,180}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-360,-220},{340,
            180}}), graphics={
        Text(
          extent={{188,-106},{312,-120}},
          lineColor={0,0,0},
          textString="Heat Exchanger Temperature Profiles",
          textStyle={TextStyle.Bold,TextStyle.UnderLine}),
        Text(
          extent={{-33,5},{33,-5}},
          lineColor={0,0,0},
          origin={167,-173},
          rotation=90,
          textString="Temperature [K]"),
        Text(
          extent={{154,-126},{266,-136}},
          lineColor={0,0,0},
          textStyle={TextStyle.Bold,TextStyle.UnderLine},
          textString="Primary Fuel HX"),
        Text(
          extent={{240,-126},{352,-136}},
          lineColor={0,0,0},
          textStyle={TextStyle.Bold,TextStyle.UnderLine},
          textString="Primary Coolant HX"),
        Text(
          extent={{-33,5},{33,-5}},
          lineColor={0,0,0},
          origin={253,-215},
          rotation=0,
          textString="Position"),
        Text(
          extent={{-290,-132},{-248,-140}},
          lineColor={0,0,0},
          textString="PHX",
          textStyle={TextStyle.Bold,TextStyle.UnderLine}),
        Text(
          extent={{-312,-146},{-270,-154}},
          lineColor={0,0,0},
          textString="Fluid"),
        Text(
          extent={{-270,-146},{-228,-154}},
          lineColor={0,0,0},
          textString="Wall"),
        Text(
          extent={{-190,-146},{-148,-154}},
          lineColor={0,0,0},
          textString="Fluid"),
        Text(
          extent={{-232,-146},{-190,-154}},
          lineColor={0,0,0},
          textString="Wall"),
        Text(
          extent={{-210,-132},{-168,-140}},
          lineColor={0,0,0},
          textStyle={TextStyle.Bold,TextStyle.UnderLine},
          textString="SHX"),
        Text(
          extent={{-350,-168},{-308,-176}},
          lineColor={0,0,0},
          textString="Tube side"),
        Text(
          extent={{-350,-186},{-308,-194}},
          lineColor={0,0,0},
          textString="Shell side"),
        Text(
          extent={{-112,-126},{-70,-134}},
          lineColor={0,0,0},
          textString="Fluid"),
        Text(
          extent={{-70,-126},{-28,-134}},
          lineColor={0,0,0},
          textString="Wall"),
        Text(
          extent={{-154,-146},{-112,-154}},
          lineColor={0,0,0},
          textStyle={TextStyle.Bold,TextStyle.UnderLine},
          textString="Core"),
        Text(
          extent={{-154,-166},{-112,-174}},
          lineColor={0,0,0},
          textStyle={TextStyle.Bold,TextStyle.UnderLine},
          textString="ReflR"),
        Text(
          extent={{-154,-184},{-112,-192}},
          lineColor={0,0,0},
          textStyle={TextStyle.Bold,TextStyle.UnderLine},
          textString="ReflA_upper"),
        Text(
          extent={{-154,-200},{-112,-208}},
          lineColor={0,0,0},
          textStyle={TextStyle.Bold,TextStyle.UnderLine},
          textString="ReflA_lower")}),
    experiment(
      StopTime=10000,
      __Dymola_NumberOfIntervals=5000,
      __Dymola_Algorithm="Esdirk45a"));
end MSR_16f;
