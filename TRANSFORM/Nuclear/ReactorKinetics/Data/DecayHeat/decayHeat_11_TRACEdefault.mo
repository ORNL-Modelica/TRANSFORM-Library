within TRANSFORM.Nuclear.ReactorKinetics.Data.DecayHeat;
record decayHeat_11_TRACEdefault
  "11 decay heat groups default in TRACE"

  extends PartialDecayHeat_powerBased(
    extraPropertiesNames=TRANSFORM.Utilities.Strings.fillNumString(11,"DHGroup"),
    C_nominal=fill(1e14, nC),
    lambdas={1.772, 0.5774, 0.06743, 6.214e-03, 4.739e-04, 4.810e-05, 5.344e-06, 5.726e-07, 1.036e-07, 2.959e-08, 7.585e-10},
    w_frac={2.99e-03, 8.25e-03, 0.01550, 0.01935, 0.01165, 6.45e-03, 2.31e-03, 1.64e-03, 8.5e-04, 4.3e-04, 5.7e-04});

  annotation (defaultComponentName="data",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info=""));
end decayHeat_11_TRACEdefault;
