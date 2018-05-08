within TRANSFORM.Examples.MoltenSaltReactor;
model MSR_12bprotdemo
  import TRANSFORM;

  package Medium_PFL =
      TRANSFORM.Media.Fluids.FLiBe.LinearFLiBe_12Th_05U_pT (
  extraPropertiesNames=data_traceSubstances.extraPropertiesNames,
  C_nominal=data_traceSubstances.C_nominal) "Primary fuel loop medium";

  package Medium_PCL = TRANSFORM.Media.Fluids.FLiBe.LinearFLiBe_pT (
  extraPropertiesNames={"Tritium"},
  C_nominal={1e6}) "Primary coolant loop medium";

  package Medium_OffGas = Modelica.Media.IdealGases.SingleGases.He (
  extraPropertiesNames=data_traceSubstances.extraPropertiesNames,
  C_nominal=data_traceSubstances.C_nominal);

  package Medium_DRACS = TRANSFORM.Media.Fluids.NaK.LinearNaK_22_78_pT;

  package Medium_BOP = Modelica.Media.Water.StandardWater (
  extraPropertiesNames={"Tritium"},
  C_nominal={1e6});

  parameter Integer iOG[:]={1,4} + fill(data_traceSubstances.data_PG.nC, 2)
    "Index array of substances sent to off-gas system";

  parameter Integer toggleStaticHead = 0 "=1 to turn on, =0 to turn off";

  // Initialization
  import Modelica.Constants.N_A;
  parameter SIadd.ExtraProperty[data_traceSubstances.data_TR.nC] C_start = N_A.*{1/Flibe_MM*MMFrac_LiF*Li6_molefrac,1/Flibe_MM*MMFrac_LiF*Li7_molefrac,1/Flibe_MM*(1-MMFrac_LiF),0} "atoms/kg fluid";

parameter SI.MassFraction Li7_enrichment = 0.99995 "mass fraction Li-7 enrichment in flibe.  Baseline is 99.995%";
parameter SI.MoleFraction MMFrac_LiF = 0.67 "Mole fraction of LiF";
parameter SI.MolarMass Flibe_MM = 0.0328931 "Molar mass of flibe [kg/mol] from doing 0.67*MM_LiF + 0.33*MM_BeF2";

parameter SI.MolarMass Li7_MM = 0.00701600455 "[kg/mol]";
parameter SI.MolarMass Li6_MM = 0.006015122795 "[kg/mol]";

parameter SI.MoleFraction Li7_molefrac = (Li7_enrichment/Li7_MM)/((Li7_enrichment/Li7_MM)+((1.0-Li7_enrichment)/Li6_MM)) "Mole fraction of lithium in flibe that is Li-7";
parameter SI.MoleFraction Li6_molefrac = 1.0-Li7_molefrac "Mole fraction of lithium in flibe that is Li-6";

  parameter SIadd.ExtraProperty[data_traceSubstances.nC] C_start_tee_inlet=cat(
      1,
      fill(0, data_traceSubstances.data_PG.nC),
      fill(0, data_traceSubstances.data_FP.nC),
      C_start);
  parameter SIadd.ExtraProperty[data_traceSubstances.nC] C_start_plenum_lower=
      cat(
      1,
      fill(0, data_traceSubstances.data_PG.nC),
      fill(0, data_traceSubstances.data_FP.nC),
      C_start);
  parameter SIadd.ExtraProperty[reflA_lower.nV,data_traceSubstances.nC]
    Cs_start_reflA_lower={cat(
      1,
      fill(0, data_traceSubstances.data_PG.nC),
      fill(0, data_traceSubstances.data_FP.nC),
      C_start) for i in 1:reflA_lower.nV};
  parameter SIadd.ExtraProperty[fuelCell.nV,data_traceSubstances.nC]
    Cs_start_fuelCell={cat(
      1,
      fill(0, data_traceSubstances.data_PG.nC),
      fill(0, data_traceSubstances.data_FP.nC),
      C_start) for i in 1:fuelCell.nV};
  parameter SIadd.ExtraProperty[reflR.nV,data_traceSubstances.nC]
    Cs_start_reflR={cat(
      1,
      fill(0, data_traceSubstances.data_PG.nC),
      fill(0, data_traceSubstances.data_FP.nC),
      C_start) for i in 1:reflR.nV};
  parameter SIadd.ExtraProperty[reflA_upper.nV,data_traceSubstances.nC]
    Cs_start_reflA_upper={cat(
      1,
      fill(0, data_traceSubstances.data_PG.nC),
      fill(0, data_traceSubstances.data_FP.nC),
      C_start) for i in 1:reflA_upper.nV};
  parameter SIadd.ExtraProperty[data_traceSubstances.nC] C_start_plenum_upper=
      cat(
      1,
      fill(0, data_traceSubstances.data_PG.nC),
      fill(0, data_traceSubstances.data_FP.nC),
      C_start);
  parameter SIadd.ExtraProperty[data_traceSubstances.nC] C_start_pumpBowl_PFL=
      cat(
      1,
      fill(0, data_traceSubstances.data_PG.nC),
      fill(0, data_traceSubstances.data_FP.nC),
      C_start);
  parameter SIadd.ExtraProperty[pipeToPHX_PFL.nV,data_traceSubstances.nC]
    Cs_start_pipeToPHX_PFL={cat(
      1,
      fill(0, data_traceSubstances.data_PG.nC),
      fill(0, data_traceSubstances.data_FP.nC),
      C_start) for i in 1:pipeToPHX_PFL.nV};
  parameter SIadd.ExtraProperty[PHX.tube.nV,data_traceSubstances.nC]
    Cs_start_PHX_tube={cat(
      1,
      fill(0, data_traceSubstances.data_PG.nC),
      fill(0, data_traceSubstances.data_FP.nC),
      C_start) for i in 1:PHX.tube.nV};
  parameter SIadd.ExtraProperty[pipeFromPHX_PFL.nV,data_traceSubstances.nC]
    Cs_start_pipeFromPHX_PFL={cat(
      1,
      fill(0, data_traceSubstances.data_PG.nC),
      fill(0, data_traceSubstances.data_FP.nC),
      C_start) for i in 1:pipeFromPHX_PFL.nV};

  // Gathered info
  SI.Power Qt_total = sum(kinetics.Qs) "Total thermal power output (from primary fission)";

  SI.Temperature Ts[10] = fuelCell.mediums.T;
  SI.Temperature Ts_ref[10] = kinetics.vals_feedback_reference[:,1];

  SI.Temperature Tst[10] = PHX.tube.mediums.T;
  SI.Temperature Tss[10] = PHX.shell.mediums.T;

  SI.Temperature ms_PFL[1+reflA_lower.nV+fuelCell.nV+reflA_upper.nV+1+pipeToPHX_PFL.nV+PHX.tube.nV+pipeFromPHX_PFL.nV+1+1+reflR.nV] = cat(1,{plenum_lower.m},reflA_lower.ms*reflA_lower.nParallel,fuelCell.ms*fuelCell.nParallel,reflA_upper.ms*reflA_upper.nParallel,
  {plenum_upper.m},pipeToPHX_PFL.ms*pipeToPHX_PFL.nParallel,PHX.tube.ms*PHX.tube.nParallel,pipeFromPHX_PFL.ms*pipeFromPHX_PFL.nParallel,{tee_inlet.m},{pumpBowl_PFL.m},reflR.ms*reflR.nParallel);

  SI.Temperature ms_PCL[pipeFromPHX_PCL.nV+1+pipeToSHX_PCL.nV+SHX.shell.nV+pipeToPHX_PCL.nV+PHX.shell.nV] = cat(1, pipeFromPHX_PCL.ms*pipeFromPHX_PCL.nParallel,{pumpBowl_PCL.m},pipeToSHX_PCL.ms*pipeToSHX_PCL.nParallel,SHX.shell.ms*SHX.shell.nParallel,pipeToPHX_PCL.ms*pipeToPHX_PCL.nParallel,PHX.shell.ms*PHX.shell.nParallel);

  SI.Temperature Ts_loop[1+reflA_lower.nV+fuelCell.nV+reflA_upper.nV+1+pipeToPHX_PFL.nV+PHX.tube.nV+pipeFromPHX_PFL.nV+1] = cat(1,{plenum_lower.medium.T},reflA_lower.mediums.T,fuelCell.mediums.T,reflA_upper.mediums.T,
  {plenum_upper.medium.T},pipeToPHX_PFL.mediums.T,PHX.tube.mediums.T,pipeFromPHX_PFL.mediums.T,{tee_inlet.medium.T});

  SIadd.ExtraProperty Cs_loop_H3[1+reflA_lower.nV+fuelCell.nV+reflA_upper.nV+1+pipeToPHX_PFL.nV+PHX.tube.nV+pipeFromPHX_PFL.nV+1] = cat(1,{plenum_lower.C[7]},reflA_lower.Cs[:,7],fuelCell.Cs[:,7],reflA_upper.Cs[:,7],
  {plenum_upper.C[7]},pipeToPHX_PFL.Cs[:,7],PHX.tube.Cs[:,7],pipeFromPHX_PFL.Cs[:,7],{tee_inlet.C[7]});

  SIadd.ExtraProperty Cs_loop_PG[1+reflA_lower.nV+fuelCell.nV+reflA_upper.nV+1+pipeToPHX_PFL.nV+PHX.tube.nV+pipeFromPHX_PFL.nV+1] = cat(1,{plenum_lower.C[5]},reflA_lower.Cs[:,5],fuelCell.Cs[:,5],reflA_upper.Cs[:,5],
  {plenum_upper.C[5]},pipeToPHX_PFL.Cs[:,5],PHX.tube.Cs[:,5],pipeFromPHX_PFL.Cs[:,5],{tee_inlet.C[5]});

  SIadd.ExtraProperty Cs_loop_Xe[1+reflA_lower.nV+fuelCell.nV+reflA_upper.nV+1+pipeToPHX_PFL.nV+PHX.tube.nV+pipeFromPHX_PFL.nV+1] = cat(1,{plenum_lower.C[10]},reflA_lower.Cs[:,10],fuelCell.Cs[:,10],reflA_upper.Cs[:,10],
  {plenum_upper.C[10]},pipeToPHX_PFL.Cs[:,10],PHX.tube.Cs[:,10],pipeFromPHX_PFL.Cs[:,10],{tee_inlet.C[10]});

  SI.Length xpos_loop[9] = cat(1,{plenum_lower.geometry.length},{reflA_lower.geometry.length},{fuelCell.geometry.length},{reflA_upper.geometry.length},
  {plenum_upper.geometry.length},{pipeToPHX_PFL.geometry.length},{sum(PHX.tube.geometry.dlengths)},{pipeFromPHX_PFL.geometry.length},{tee_inlet.geometry.length});

//  SIadd.ExtraProperty[1,data_traceSubstances.nC] Cs1={{tee_inlet.C[j] for j in 1:data_traceSubstances.nC} for i in 1:1};
//  SIadd.ExtraProperty[1,data_traceSubstances.nC] Cs2={{plenum_lower.C[j] for j in 1:data_traceSubstances.nC} for i in 1:1};
//  SIadd.ExtraProperty[2,data_traceSubstances.nC] Cs3={{reflA_lower.Cs[i,j] for j in 1:data_traceSubstances.nC} for i in 1:2};
//  SIadd.ExtraProperty[10,data_traceSubstances.nC] Cs4={{fuelCell.Cs[i,j] for j in 1:data_traceSubstances.nC} for i in 1:10};
//  SIadd.ExtraProperty[2,data_traceSubstances.nC] Cs5={{reflA_upper.Cs[i,j] for j in 1:data_traceSubstances.nC} for i in 1:2};
//  SIadd.ExtraProperty[1,data_traceSubstances.nC] Cs6={{plenum_upper.C[j] for j in 1:data_traceSubstances.nC} for i in 1:1};
//  SIadd.ExtraProperty[1,data_traceSubstances.nC] Cs7={{pumpBowl_PFL.C[j] for j in 1:data_traceSubstances.nC} for i in 1:1};
//  SIadd.ExtraProperty[2,data_traceSubstances.nC] Cs8={{pipeToPHX_PFL.Cs[i,j] for j in 1:data_traceSubstances.nC} for i in 1:2};
//  SIadd.ExtraProperty[10,data_traceSubstances.nC] Cs9={{PHX.tube.Cs[i,j] for j in 1:data_traceSubstances.nC} for i in 1:10};
//  SIadd.ExtraProperty[2,data_traceSubstances.nC] Cs10={{pipeFromPHX_PFL.Cs[i,j] for j in 1:data_traceSubstances.nC} for i in 1:2};
//
//  SIadd.ExtraProperty[10,data_traceSubstances.nC] Cs11={{reflR.Cs[i,j] for j in 1:data_traceSubstances.nC} for i in 1:10};
//  SIadd.ExtraProperty[1,data_traceSubstances.nC] Cs12={{drainTank_gas.C[j] for j in 1:data_traceSubstances.nC} for i in 1:1};
//  SIadd.ExtraProperty[1,data_traceSubstances.nC] Cs13={{drainTank_liquid.C[j] for j in 1:data_traceSubstances.nC} for i in 1:1};
//  SIadd.ExtraProperty[1,data_traceSubstances.nC] Cs14={{adsorberBed.port_b.C_outflow[j] for j in 1:data_traceSubstances.nC} for i in 1:1};

 SI.Power[10] Qs=Qs_gen_fuelCell;
 SI.Power Q_drainTank_gas = drainTank_gas.heatPort.Q_flow;
 SI.Power Q_drainTank_liquid= drainTank_liquid.heatPort.Q_flow;
  SI.Power Q_charcoalBed = sum(adsorberBed.heatPorts.Q_flow);

  Real[10] rhos=kinetics.rhos;

  SIadd.ExtraPropertyFlowRate H3_flow = SHX.port_b_tube.m_flow*SHX.port_b_tube.C_outflow[1];

SI.MassFlowRate m_flow_PFL = pump_PFL.port_a.m_flow;
SI.MassFlowRate m_flow_PCL = pump_PCL.port_a.m_flow;

  // Decay Heat Calculations: PFL
protected
  SI.Power Qs_gen_tee_inlet=sum({(data_traceSubstances.w_near_decay[j] +
      data_traceSubstances.w_far_decay[j])*data_traceSubstances.lambdas[j]*
      tee_inlet.mC[j] for j in 1:data_traceSubstances.nC});
  SI.Power Qs_gen_plenum_lower=sum({(data_traceSubstances.w_near_decay[j] +
      data_traceSubstances.w_far_decay[j])*data_traceSubstances.lambdas[j]*
      plenum_lower.mC[j] for j in 1:data_traceSubstances.nC});
  SI.Power[reflA_lower.nV] Qs_gen_reflA_lower={sum({data_traceSubstances.w_near_decay[
      j]*data_traceSubstances.lambdas[j]*reflA_lower.mCs[i, j] for j in 1:
      data_traceSubstances.nC}) for i in 1:reflA_lower.nV};
  SI.Power[fuelCell.nV] Qs_gen_fuelCell=kinetics.Qs + kinetics.Qs_FP_near;
  SI.Power[reflR.nV] Qs_gen_reflR={sum({data_traceSubstances.w_near_decay[j]*
      data_traceSubstances.lambdas[j]*reflR.mCs[i, j] for j in 1:
      data_traceSubstances.nC}) for i in 1:reflR.nV};
  SI.Power[reflA_upper.nV] Qs_gen_reflA_upper={sum({data_traceSubstances.w_near_decay[
      j]*data_traceSubstances.lambdas[j]*reflA_upper.mCs[i, j] for j in 1:
      data_traceSubstances.nC}) for i in 1:reflA_upper.nV};

  SI.Power Qs_gen_plenum_upper=sum({(data_traceSubstances.w_near_decay[j] +
      data_traceSubstances.w_far_decay[j])*data_traceSubstances.lambdas[j]*
      plenum_upper.mC[j] for j in 1:data_traceSubstances.nC});
  SI.Power Qs_gen_pumpBowl_PFL=sum({(data_traceSubstances.w_near_decay[j] +
      data_traceSubstances.w_far_decay[j])*data_traceSubstances.lambdas[j]*
      pumpBowl_PFL.mC[j] for j in 1:data_traceSubstances.nC});
  SI.Power[pipeToPHX_PFL.nV] Qs_gen_pipeToPHX_PFL={sum({(data_traceSubstances.w_near_decay[
      j] + data_traceSubstances.w_far_decay[j])*data_traceSubstances.lambdas[j]*
      pipeToPHX_PFL.mCs[i, j] for j in 1:data_traceSubstances.nC}) for i in 1:
      pipeToPHX_PFL.nV};
  SI.Power[PHX.tube.nV] Qs_gen_PHX_tube={sum({(data_traceSubstances.w_near_decay[
      j] + data_traceSubstances.w_far_decay[j])*data_traceSubstances.lambdas[j]*
      PHX.tube.mCs[i, j] for j in 1:data_traceSubstances.nC}) for i in 1:PHX.tube.nV};
  SI.Power[pipeFromPHX_PFL.nV] Qs_gen_pipeFromPHX_PFL={sum({(
      data_traceSubstances.w_near_decay[j] + data_traceSubstances.w_far_decay[j])
      *data_traceSubstances.lambdas[j]*pipeFromPHX_PFL.mCs[i, j] for j in 1:
      data_traceSubstances.nC}) for i in 1:pipeFromPHX_PFL.nV};

  // Decay Heat Calculations: PFL - solid
  SI.Power[reflA_lower.nV] QsG_reflA_lowerG={sum({data_traceSubstances.w_far_decay[
      j]*data_traceSubstances.lambdas[j]*reflA_lower.mCs[i, j] for j in 1:
      data_traceSubstances.nC}) for i in 1:reflA_lower.nV};
  //SI.Power[fuelCell.nV] QsG_fuelCellG = {sum({data_traceSubstances.wG_decay[j]*data_traceSubstances.lambdas[j]*fuelCell.mCs[i, j] for j in 1:data_traceSubstances.nC}) for i in 1:fuelCell.nV};
  SI.Power[reflR.nV] QsG_reflRG={sum({data_traceSubstances.w_far_decay[j]*
      data_traceSubstances.lambdas[j]*reflR.mCs[i, j] for j in 1:
      data_traceSubstances.nC}) for i in 1:reflR.nV};
  SI.Power[reflA_upper.nV] QsG_reflA_upperG={sum({data_traceSubstances.w_far_decay[
      j]*data_traceSubstances.lambdas[j]*reflA_upper.mCs[i, j] for j in 1:
      data_traceSubstances.nC}) for i in 1:reflA_upper.nV};

  SI.Power[reflA_lowerG.nVs[1],reflA_lowerG.nVs[2]] Qs_gen_reflA_lowerG = {{QsG_reflA_lowerG[j]/reflA_lowerG.nVs[1] for j in 1:reflA_lowerG.nVs[2]} for i in 1:reflA_lowerG.nVs[1]};
  SI.Power[fuelCellG.nVs[1],fuelCellG.nVs[2]] Qs_gen_fuellCellG={{kinetics.Qs_FP_far[j]/fuelCellG.nVs[1] for j in 1:fuelCellG.nVs[2]} for i in 1:fuelCellG.nVs[1]};
  SI.Power[reflRG.nVs[1],reflRG.nVs[2]] Qs_gen_reflRG = {{QsG_reflRG[j]/reflRG.nVs[1] + Qs_gen_fuellCellG[i,j] for j in 1:reflRG.nVs[2]} for i in 1:reflRG.nVs[1]};
  SI.Power[reflA_upperG.nVs[1],reflA_upperG.nVs[2]] Qs_gen_reflA_upperG = {{QsG_reflA_upperG[j]/reflA_upperG.nVs[1] for j in 1:reflA_upperG.nVs[2]} for i in 1:reflA_upperG.nVs[1]};

  // Decay Heat Calculations: Off-Gas/DrainTank
  SI.Power Qs_gen_drainTank_gas=sum({(data_traceSubstances.w_near_decay[j] +
      data_traceSubstances.w_far_decay[j])*data_traceSubstances.lambdas[j]*
      drainTank_gas.mC[j] for j in 1:data_traceSubstances.nC});
  SI.Power Qs_gen_drainTank_liquid=sum({(data_traceSubstances.w_near_decay[j] +
      data_traceSubstances.w_far_decay[j])*data_traceSubstances.lambdas[j]*
      drainTank_liquid.mC[j] for j in 1:data_traceSubstances.nC});

  // Trace Substance Calculations: PFL
  SIadd.ExtraPropertyFlowRate[data_traceSubstances.nC] mC_gen_tee_inlet = {-data_traceSubstances.lambdas[j]*tee_inlet.mC[j] + mC_gen_tee_inlet_PtoD[j] for j in 1:data_traceSubstances.nC};
  SIadd.ExtraPropertyFlowRate[data_traceSubstances.nC] mC_gen_plenum_lower = {-data_traceSubstances.lambdas[j]*plenum_lower.mC[j] + mC_gen_plenum_lower_PtoD[j] for j in 1:data_traceSubstances.nC};
  SIadd.ExtraPropertyFlowRate[reflA_lower.nV,data_traceSubstances.nC] mC_gens_reflA_lower = {{-data_traceSubstances.lambdas[j]*reflA_lower.mCs[i, j]*reflA_lower.nParallel + mC_gens_reflA_lower_PtoD[i,j] for j in 1:data_traceSubstances.nC} for i in 1:reflA_lower.nV};
  SIadd.ExtraPropertyFlowRate[fuelCell.nV,data_traceSubstances.nC] mC_gens_fuelCell = cat(2, kinetics.mC_gens, kinetics.mC_gens_FP,kinetics.mC_gens_TR);
  SIadd.ExtraPropertyFlowRate[reflR.nV,data_traceSubstances.nC] mC_gens_reflR = {{-data_traceSubstances.lambdas[j]*reflR.mCs[i, j]*reflR.nParallel + mC_gens_reflR_PtoD[i,j] for j in 1:data_traceSubstances.nC} for i in 1:reflR.nV};
  SIadd.ExtraPropertyFlowRate[reflA_upper.nV,data_traceSubstances.nC] mC_gens_reflA_upper = {{-data_traceSubstances.lambdas[j]*reflA_upper.mCs[i, j]*reflA_upper.nParallel + mC_gens_reflA_upper_PtoD[i,j] for j in 1:data_traceSubstances.nC} for i in 1:reflA_upper.nV};
  SIadd.ExtraPropertyFlowRate[data_traceSubstances.nC] mC_gen_plenum_upper = {-data_traceSubstances.lambdas[j]*plenum_upper.mC[j] + mC_gen_plenum_upper_PtoD[j] for j in 1:data_traceSubstances.nC};
  SIadd.ExtraPropertyFlowRate[data_traceSubstances.nC] mC_gen_pumpBowl_PFL={-data_traceSubstances.lambdas[j]*pumpBowl_PFL.mC[j]*3 + mC_flows_fromOG[j] + mC_gen_pumpBowl_PFL_PtoD[j] for j in 1:data_traceSubstances.nC};
  SIadd.ExtraPropertyFlowRate[pipeToPHX_PFL.nV,data_traceSubstances.nC] mC_gens_pipeToPHX_PFL = {{-data_traceSubstances.lambdas[j]*pipeToPHX_PFL.mCs[i, j]*pipeToPHX_PFL.nParallel + mC_gens_pipeToPHX_PFL_PtoD[i,j] for j in 1:data_traceSubstances.nC} for i in 1:pipeToPHX_PFL.nV};
  SIadd.ExtraPropertyFlowRate[PHX.tube.nV,data_traceSubstances.nC] mC_gens_PHX_tube = {{-data_traceSubstances.lambdas[j]*PHX.tube.mCs[i, j]*PHX.tube.nParallel + mC_gens_PHX_tube_PtoD[i,j] for j in 1:data_traceSubstances.nC} for i in 1:PHX.tube.nV};
  SIadd.ExtraPropertyFlowRate[pipeFromPHX_PFL.nV,data_traceSubstances.nC] mC_gens_pipeFromPHX_PFL = {{-data_traceSubstances.lambdas[j]*pipeFromPHX_PFL.mCs[i, j]*pipeFromPHX_PFL.nParallel + mC_gens_pipeFromPHX_PFL_PtoD[i,j] for j in 1:data_traceSubstances.nC} for i in 1:pipeFromPHX_PFL.nV};

  // Trace Substances Parent->Daughter contribution
  SIadd.ExtraPropertyFlowRate[data_traceSubstances.nC] mC_gen_tee_inlet_PtoD = {sum({data_traceSubstances.lambdas[k].*tee_inlet.mC[k].*data_traceSubstances.parents[j,k] for k in 1:data_traceSubstances.nC}) for j in 1:data_traceSubstances.nC};
  SIadd.ExtraPropertyFlowRate[data_traceSubstances.nC] mC_gen_plenum_lower_PtoD= {sum({data_traceSubstances.lambdas[k].*plenum_lower.mC[k].*data_traceSubstances.parents[j,k] for k in 1:data_traceSubstances.nC}) for j in 1:data_traceSubstances.nC};
  SIadd.ExtraPropertyFlowRate[reflA_lower.nV,data_traceSubstances.nC] mC_gens_reflA_lower_PtoD = {{sum({data_traceSubstances.lambdas[k].*reflA_lower.mCs[i,k].*reflA_lower.nParallel.*data_traceSubstances.parents[j,k] for k in 1:data_traceSubstances.nC}) for j in 1:data_traceSubstances.nC} for i in 1:reflA_lower.nV};
  //SIadd.ExtraPropertyFlowRate[fuelCell.nV,data_traceSubstances.nC] mC_gens_fuelCell_PtoD = {{sum({data_traceSubstances.lambdas[k].*fuelCell.mCs[i,k].*fuelCell.nParallel.*data_traceSubstances.parents[j,k] for k in 1:data_traceSubstances.nC}) for j in 1:data_traceSubstances.nC} for i in 1:fuelCell.nV};
  SIadd.ExtraPropertyFlowRate[reflR.nV,data_traceSubstances.nC] mC_gens_reflR_PtoD= {{sum({data_traceSubstances.lambdas[k].*reflR.mCs[i,k].*reflR.nParallel.*data_traceSubstances.parents[j,k] for k in 1:data_traceSubstances.nC}) for j in 1:data_traceSubstances.nC} for i in 1:reflR.nV};
  SIadd.ExtraPropertyFlowRate[reflA_upper.nV,data_traceSubstances.nC] mC_gens_reflA_upper_PtoD= {{sum({data_traceSubstances.lambdas[k].*reflA_upper.mCs[i,k].*reflA_upper.nParallel.*data_traceSubstances.parents[j,k] for k in 1:data_traceSubstances.nC}) for j in 1:data_traceSubstances.nC} for i in 1:reflA_upper.nV};
  SIadd.ExtraPropertyFlowRate[data_traceSubstances.nC] mC_gen_plenum_upper_PtoD= {sum({data_traceSubstances.lambdas[k].*plenum_upper.mC[k].*data_traceSubstances.parents[j,k] for k in 1:data_traceSubstances.nC}) for j in 1:data_traceSubstances.nC};
  SIadd.ExtraPropertyFlowRate[data_traceSubstances.nC] mC_gen_pumpBowl_PFL_PtoD= {sum({data_traceSubstances.lambdas[k].*pumpBowl_PFL.mC[k].*data_traceSubstances.parents[j,k] for k in 1:data_traceSubstances.nC}) for j in 1:data_traceSubstances.nC};
  SIadd.ExtraPropertyFlowRate[pipeToPHX_PFL.nV,data_traceSubstances.nC] mC_gens_pipeToPHX_PFL_PtoD = {{sum({data_traceSubstances.lambdas[k].*pipeToPHX_PFL.mCs[i,k].*pipeToPHX_PFL.nParallel.*data_traceSubstances.parents[j,k] for k in 1:data_traceSubstances.nC}) for j in 1:data_traceSubstances.nC} for i in 1:pipeToPHX_PFL.nV};
  SIadd.ExtraPropertyFlowRate[PHX.tube.nV,data_traceSubstances.nC] mC_gens_PHX_tube_PtoD = {{sum({data_traceSubstances.lambdas[k].*PHX.tube.mCs[i,k].*PHX.tube.nParallel.*data_traceSubstances.parents[j,k] for k in 1:data_traceSubstances.nC}) for j in 1:data_traceSubstances.nC} for i in 1:PHX.tube.nV};
  SIadd.ExtraPropertyFlowRate[pipeFromPHX_PFL.nV,data_traceSubstances.nC] mC_gens_pipeFromPHX_PFL_PtoD = {{sum({data_traceSubstances.lambdas[k].*pipeFromPHX_PFL.mCs[i,k].*pipeFromPHX_PFL.nParallel.*data_traceSubstances.parents[j,k] for k in 1:data_traceSubstances.nC}) for j in 1:data_traceSubstances.nC} for i in 1:pipeFromPHX_PFL.nV};

  // TraceSubstance Calculations: Off-Gas and Drain Tank
  SI.MassFlowRate m_flow_toDrainTank = data_OFFGAS.V_flow_sep_salt_total*Medium_PFL.density_ph(pump_PFL.port_b.p, pump_PFL.port_b.h_outflow) "Mass flow rate of salt to drain tank (+)";
  SIadd.ExtraPropertyFlowRate[data_traceSubstances.nC] mC_gen_drainTank_gas=-data_traceSubstances.lambdas.*drainTank_gas.mC + mC_gen_drainTank_gas_PtoD;
  SIadd.ExtraPropertyFlowRate[data_traceSubstances.nC] mC_gen_drainTank_liquid=-data_traceSubstances.lambdas.*drainTank_liquid.mC + mC_gen_drainTank_liquid_PtoD;
  SIadd.ExtraPropertyFlowRate[data_traceSubstances.nC] mC_flows_fromOG = abs(pump_OffGas_bypass.port_b.m_flow).*pump_OffGas_bypass.port_b.C_outflow+abs(pump_OffGas_adsorberBed.port_b.m_flow).*pump_OffGas_adsorberBed.port_b.C_outflow;

  // Trace Substances Parent->Daughter contribution:  Off-Gas and Drain Tank
  SIadd.ExtraPropertyFlowRate[data_traceSubstances.nC] mC_gen_drainTank_gas_PtoD = {sum({data_traceSubstances.lambdas[k].*drainTank_gas.mC[k].*data_traceSubstances.parents[j,k] for k in 1:data_traceSubstances.nC}) for j in 1:data_traceSubstances.nC};
  SIadd.ExtraPropertyFlowRate[data_traceSubstances.nC] mC_gen_drainTank_liquid_PtoD = {sum({data_traceSubstances.lambdas[k].*drainTank_liquid.mC[k].*data_traceSubstances.parents[j,k] for k in 1:data_traceSubstances.nC}) for j in 1:data_traceSubstances.nC};

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
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        crossArea=data_RCTR.crossArea_f,
        perimeter=data_RCTR.perimeter_f,
        length=data_RCTR.length_cells,
        nV=10,
        angle=toggleStaticHead*90,
        surfaceArea={fuelCellG.nParallel/fuelCell.nParallel*sum(fuelCellG.geometry.crossAreas_1
            [1, :])}),
    Cs_start=Cs_start_fuelCell,
    redeclare model InternalHeatGen =
        TRANSFORM.Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.GenericHeatGeneration
        (Q_gens=Qs_gen_fuelCell))
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
        (Q_gens=Qs_gen_reflA_upper))
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
        (Q_gens=Qs_gen_reflA_lower))
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
  HeatAndMassTransfer.DiscritizedModels.Conduction_2D fuelCellG(
    redeclare package Material = Media.Solids.Graphite.Graphite_0,
    T_b2_start=data_PHX.T_inlet_tube,
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
    T_a1_start=0.5*(data_PHX.T_outlet_tube + data_PHX.T_outlet_tube),
    T_b1_start=0.5*(data_PHX.T_outlet_tube + data_PHX.T_outlet_tube) + 50,
    T_a2_start=data_PHX.T_outlet_tube,
    showName=systemTF.showName,
    redeclare model InternalHeatModel =
        TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_2.GenericHeatGeneration
        (Q_gens=Qs_gen_fuellCellG))
                         annotation (Placement(transformation(
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
  HeatAndMassTransfer.DiscritizedModels.Conduction_2D reflA_upperG(
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
        (Q_gens=Qs_gen_reflA_upperG)) annotation (Placement(transformation(
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
  HeatAndMassTransfer.DiscritizedModels.Conduction_2D reflA_lowerG(
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
        (Q_gens=Qs_gen_reflA_lowerG)) annotation (Placement(transformation(
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
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        length=data_PIPING.length_PHXToRCTR,
        nV=10,
        dimension=data_PIPING.D_PFL,
        dheight=toggleStaticHead*data_PIPING.height_PHXToRCTR),
    m_flow_a_start=2*3*data_PHX.m_flow_tube,
    showName=systemTF.showName,
    redeclare model InternalTraceGen =
        TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
        (mC_gens=mC_gens_pipeFromPHX_PFL),
    Cs_start=Cs_start_pipeFromPHX_PFL,
    redeclare model InternalHeatGen =
        TRANSFORM.Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.GenericHeatGeneration
        (Q_gens=Qs_gen_pipeFromPHX_PFL))
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={160,-70})));
public
  TRANSFORM.HeatExchangers.GenericDistributed_HX_withMass PHX(
    redeclare package Medium_shell = Medium_PCL,
    redeclare package Medium_tube = Medium_PFL,
    p_a_start_shell=data_PHX.p_inlet_shell,
    T_a_start_shell=data_PHX.T_inlet_shell,
    T_b_start_shell=data_PHX.T_outlet_shell,
    p_a_start_tube=data_PHX.p_inlet_tube,
    T_a_start_tube=data_PHX.T_inlet_tube,
    T_b_start_tube=data_PHX.T_outlet_tube,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ShellAndTubeHX
        (
        D_o_shell=data_PHX.D_shell_inner,
        nV=10,
        nTubes=data_PHX.nTubes,
        nR=3,
        length_shell=data_PHX.length_tube,
        th_wall=data_PHX.th_tube,
        dimension_tube=data_PHX.D_tube_inner,
        length_tube=data_PHX.length_tube),
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
        CFs=
           fill(
            0.44,
            PHX.shell.heatTransfer.nHT,
            PHX.shell.heatTransfer.nSurfaces)),
    redeclare package Material_wall = TRANSFORM.Media.Solids.AlloyN,
    nC=1,
    use_TraceMassTransfer_shell=true,
    use_TraceMassTransfer_tube=true,
    redeclare model TraceMassTransfer_shell =
        TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D_MultiTransferSurface.Ideal
        (MMs={6.022e23}),
    redeclare model TraceMassTransfer_tube =
        TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D_MultiTransferSurface.Ideal
        (iC={7}, MMs={6.022e23}),
    redeclare model DiffusionCoeff_wall =
        TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.GenericCoefficient
        (D_ab0=0.0000001))  annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={160,0})));

protected
  Fluid.Pipes.GenericPipe_MultiTransferSurface pipeToPHX_PFL(
    nParallel=3,
    redeclare package Medium = Medium_PFL,
    p_a_start=data_PHX.p_inlet_tube + 350,
    T_a_start=data_PHX.T_inlet_tube,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        nV=10,
        dimension=data_PIPING.D_PFL,
        length=data_PIPING.length_pumpToPHX,
        dheight=toggleStaticHead*data_PIPING.height_pumpToPHX),
    m_flow_a_start=2*3*data_PHX.m_flow_tube,
    showName=systemTF.showName,
    redeclare model InternalTraceGen =
        TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
        (mC_gens=mC_gens_pipeToPHX_PFL),
    Cs_start=Cs_start_pipeToPHX_PFL,
    redeclare model InternalHeatGen =
        TRANSFORM.Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.GenericHeatGeneration
        (Q_gens=Qs_gen_pipeToPHX_PFL))                          annotation (
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
public
  TRANSFORM.Nuclear.ReactorKinetics.PointKinetics_Drift kinetics(
    nV=fuelCell.nV,
    Q_nominal=data_RCTR.Q_nominal,
    lambda_i=data_traceSubstances.data_PG.lambdas,
    nC=data_traceSubstances.data_FP.nC,
    mCs=fuelCell.mCs[:, data_traceSubstances.iPG[1]:data_traceSubstances.iPG[2]]
        *fuelCell.nParallel,
    lambda_FP=data_traceSubstances.data_FP.lambdas,
    w_FP_decay=data_traceSubstances.data_FP.w_near_decay,
    mCs_FP=fuelCell.mCs[:, data_traceSubstances.iFP[1]:data_traceSubstances.iFP[
        2]]*fuelCell.nParallel,
    parents=data_traceSubstances.data_FP.parents,
    sigmaA_FP=data_traceSubstances.data_FP.sigmasA,
    fissionYield=data_traceSubstances.data_FP.fissionYields[:, :, 1],
    vals_feedback=matrix(fuelCell.mediums.T),
    vals_feedback_reference=matrix(linspace(
        data_RCTR.T_inlet_core,
        data_RCTR.T_outlet_core,
        fuelCell.nV)),
    nTR=data_traceSubstances.data_TR.nC,
    iH3=data_traceSubstances.iH3,
    parents_TR=data_traceSubstances.data_TR.parents,
    sigmaA_TR=data_traceSubstances.data_TR.sigmasA,
    sigmaT_TR=data_traceSubstances.data_TR.sigmasT,
    lambda_TR=data_traceSubstances.data_TR.lambdas,
    mCs_TR=fuelCell.mCs[:, data_traceSubstances.iTR[1]:data_traceSubstances.iTR[
        2]]*fuelCell.nParallel,
    Vs=fuelCell.Vs*fuelCell.nParallel,
    SigmaF=26,
    wG_FP_decay=data_traceSubstances.data_FP.w_far_decay,
    nFS=data_traceSubstances.data_FP.nFS,
    specifyPower=false)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
protected
  TRANSFORM.Nuclear.ReactorKinetics.Data.summary_traceSubstances
    data_traceSubstances(redeclare record FissionProducts =
        TRANSFORM.Nuclear.ReactorKinetics.Data.FissionProducts.fissionProducts_H3TeIXe_U235)
    annotation (Placement(transformation(extent={{260,120},{280,140}})));
public
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
        nV=10,
        dimension=data_PIPING.D_PCL,
        length=data_PIPING.length_PHXsToPump,
        dheight=toggleStaticHead*data_PIPING.height_PHXsToPump))
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=180,
        origin={190,40})));
protected
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
    use_input=true)
    annotation (Placement(transformation(extent={{240,30},{260,50}})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface pipeToSHX_PCL(
    nParallel=3,
    showName=systemTF.showName,
    redeclare package Medium = Medium_PCL,
    T_a_start=data_PHX.T_outlet_shell,
    m_flow_a_start=2*3*data_PHX.m_flow_shell,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        nV=10,
        dimension=data_PIPING.D_PCL,
        length=data_PIPING.length_pumpToSHX,
        dheight=toggleStaticHead*data_PIPING.height_pumpToSHX),
    p_a_start=data_PHX.p_inlet_shell + 300) annotation (Placement(
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
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        nV=10,
        dimension=data_PIPING.D_PCL,
        length=data_PIPING.length_SHXToPHX,
        dheight=toggleStaticHead*data_PIPING.height_SHXToPHX),
    nParallel=3)                                                annotation (
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
public
  TRANSFORM.HeatExchangers.GenericDistributed_HX_withMass SHX(
    redeclare package Medium_shell = Medium_PCL,
    nParallel=2*3,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ShellAndTubeHX
        (
        nV=10,
        nR=3,
        D_o_shell=data_SHX.D_shell_inner,
        nTubes=data_SHX.nTubes,
        length_shell=data_SHX.length_tube,
        dimension_tube=data_SHX.D_tube_inner,
        length_tube=data_SHX.length_tube,
        th_wall=data_SHX.th_tube),
    p_a_start_shell=data_SHX.p_inlet_shell,
    T_a_start_shell=data_SHX.T_inlet_shell,
    T_b_start_shell=data_SHX.T_outlet_shell,
    m_flow_a_start_shell=2*3*data_SHX.m_flow_shell,
    p_a_start_tube=data_SHX.p_inlet_tube,
    T_a_start_tube=data_SHX.T_inlet_tube,
    T_b_start_tube=data_SHX.T_outlet_tube,
    m_flow_a_start_tube=2*3*data_SHX.m_flow_tube,
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
    redeclare model TraceMassTransfer_shell =
        TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D_MultiTransferSurface.Ideal
        (MMs={6.022e23}),
    redeclare model TraceMassTransfer_tube =
        TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D_MultiTransferSurface.Ideal
        (MMs={6.022e23}),
    redeclare model DiffusionCoeff_wall =
        TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.GenericCoefficient
        (D_ab0=0.0000001),
    redeclare model HeatTransfer_tube =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
                            annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={300,0})));

protected
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
    lambdas=data_traceSubstances.lambdas,
    iC=8,
    parents=data_traceSubstances.parents,
    Qs_decay=data_traceSubstances.w_near_decay + data_traceSubstances.w_far_decay)
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
        nV=fuelCell.nV))                  annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={20,0})));

  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.Conduction_2D reflRG(
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
        (Q_gens=Qs_gen_reflRG))           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,0})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi reflRG_lower_bc(showName=
        systemTF.showName, nPorts=reflRG.geometry.nX) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={50,-30})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi reflRG_centerline_bc(showName=
        systemTF.showName, nPorts=reflR.nV)
    annotation (Placement(transformation(extent={{88,-10},{68,10}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi reflRG_upper_bc(showName=
        systemTF.showName, nPorts=reflRG.geometry.nX) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
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
    annotation (Placement(transformation(extent={{230,120},{250,140}})));

  TRANSFORM.Examples.MoltenSaltReactor.Components.DRACS DRACS(
    redeclare package Medium_DRACS = Medium_DRACS,
    showName=systemTF.showName,
    surfaceAreas_thimble=DRACS.thimble_outer_drainTank.surfaceArea_outer*DRACS.nP_outer_drainTank[
        1].nParallel*{drainTank_liquid.level/data_OFFGAS.length_drainTank_inner,
        1 - drainTank_liquid.level/data_OFFGAS.length_drainTank_inner},
    alphas_drainTank={5000,1000})
    annotation (Placement(transformation(extent={{-354,-96},{-284,-16}})));
public
  Modelica.Blocks.Sources.Ramp ramp1(
    offset=2*3*data_PHX.m_flow_shell,
    height=-0.95*(2*3*data_PHX.m_flow_shell),
    duration=60,
    startTime=172800 + 300)
    annotation (Placement(transformation(extent={{222,60},{242,80}})));
  Modelica.Blocks.Sources.Ramp ramp(
    offset=2*3*data_PHX.m_flow_tube/(1 - x_bypass.k),
    height=-0.95*(2*3*data_PHX.m_flow_tube/(1 - x_bypass.k)),
    duration=60,
    startTime=172800)
    annotation (Placement(transformation(extent={{12,162},{32,182}})));
protected
  Modelica.Blocks.Sources.RealExpression boundary_OffGas_T1(y=drainTank_liquid.port_a.m_flow)
    annotation (Placement(transformation(extent={{-222,-52},{-202,-32}})));
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
        points={{20,37},{20,46},{0,46},{0,50}}, color={0,127,255}));
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
  connect(ramp.y, pump_PFL.in_m_flow)
    annotation (Line(points={{33,172},{50,172},{50,135.3}}, color={0,0,127}));
  connect(ramp1.y, pump_PCL.in_m_flow)
    annotation (Line(points={{243,70},{250,70},{250,47.3}}, color={0,0,127}));
  connect(boundary_OffGas_T1.y, pump_drainTank.in_m_flow) annotation (Line(
        points={{-201,-42},{-190,-42},{-190,-52.7}}, color={0,0,127}));
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
          textString="Position")}),
    experiment(
      StopTime=173700,
      __Dymola_NumberOfIntervals=173700,
      __Dymola_Algorithm="Esdirk45a"));
end MSR_12bprotdemo;
