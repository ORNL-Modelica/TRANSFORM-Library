within TRANSFORM.Examples.MoltenSaltReactor.Examples;
model MSDR_SA
  parameter Real alpha_Beta=0 "fraction deviation from initial value +/-";
  parameter Real alpha_Lambda=0 "fraction deviation from initial value +/-";
  SI.Power Q_fission = reactor.kinetics.Q_fission_total;
  SI.Temperature T_loop_max = max(reactor.Ts_loop);
  SI.Temperature T_core_max = max(reactor.fuelCell.mediums.T);
  SI.Temperature T_coreG_max = max(reactor.fuelCellG.materials.T);
  SIadd.ExtraPropertyFlowRate mC_flows_to_PCL = reactor.mC_flows_PCL_PHX;
  SIadd.ExtraPropertyFlowRate mC_flows_to_Env = reactor.mC_flows_BOP_SHX;
  SIadd.ExtraPropertyFlowRate mC_gens_H3 = reactor.mC_gens_H3;
protected
  MSDR_noBOP_SA reactor(alpha_Beta=alpha_Beta, alpha_Lambda=alpha_Lambda)
    annotation (Placement(transformation(extent={{-38,-20},{32,20}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=31536000,
      __Dymola_NumberOfIntervals=86400,
      __Dymola_Algorithm="Esdirk45a"));
end MSDR_SA;
