within TRANSFORM.Nuclear.ReactorKinetics.Examples;
model PointKinetics_Test2
  extends TRANSFORM.Icons.Example;
  Modelica.Blocks.Sources.Sine Teff_Fuel(
    amplitude=5,
    freqHz=0.002,
    startTime=1e4,
    offset=1000)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Sources.Sine Teff_Coolant(
    amplitude=10,
    freqHz=0.01,
    startTime=1e4,
    phase=0.5235987755983,
    offset=500)
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Modelica.Blocks.Sources.Constant ControlRod_Reactivity(k=0)
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  PointKinetics_L1_powerBased kinetics(
    Q_nominal=1e9,
    Lambda_start=1e-3,
    rhos_input={ControlRod_Reactivity.y},
    nFeedback=2,
    alphas_feedback=[-2.5e-5,-20e-5],
    vals_feedback=[Teff_Fuel.y,Teff_Coolant.y],
    vals_feedback_reference=[Teff_Fuel.offset,Teff_Coolant.offset],
    nI=data.nC,
    nDH=data_dh.nC,
    lambda_i_start=data.lambdas,
    alpha_i_start=data.alphas,
    Beta_start=data.Beta,
    lambda_dh_start=data_dh.lambdas,
    w_frac_dh_start=data_dh.w_frac,
    use_history=true,
    history=data_history.table)
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(x=cat(
        1,
        kinetics.Cs[1, :],
        kinetics.Es_dh[1, :]), n=data_dh.nC + data.nC)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Data.PrecursorGroups.precursorGroups_6_TRACEdefault data
    annotation (Placement(transformation(extent={{40,2},{60,22}})));
  Data.DecayHeat.decayHeat_11_TRACEdefault data_dh
    annotation (Placement(transformation(extent={{40,-18},{60,2}})));
  Blocks.DataTable data_history(table=[0,0; 1e4,1e3; 2e4,1e4; 1e16,1e6])
    annotation (Placement(transformation(extent={{70,2},{90,22}})));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    experiment(StopTime=10, __Dymola_NumberOfIntervals=1000),
    __Dymola_experimentSetupOutput);
end PointKinetics_Test2;
