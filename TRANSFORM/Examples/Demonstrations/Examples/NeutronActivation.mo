within TRANSFORM.Examples.Demonstrations.Examples;
model NeutronActivation
  // See example in Section 9.9 Neutron Activation (pp. 229-230)
  // Source: J. E. TURNER, Atoms, Radiation, and Radiation Protection, 3., completely revised and enl. ed, Wiley-VCH, Weinheim (2007).
  extends Icons.Example;
  import Modelica.Constants.N_A;
  parameter SI.Mass m_T_start = 3e-3 "Target initial mass";
  parameter SI.MolarMass MM_T = 0.032 "Target molar mass";
  parameter SIadd.InverseTime lambda = log(2)/SIadd.Conversions.Functions.Time_s.from_day(14.3) "Decay constant";
  parameter SI.Area sigma = SIadd.Conversions.Functions.Area_m2.from_barn(0.2) "Cross section for reaction";
  parameter SIadd.NeutronFlux phi = 155e4 "Nuetron flux";
  final parameter Real N_T_start = m_T_start/MM_T*N_A "Initial number of atoms for isotope i";
  Real Nb "Sources and sinks product";
  Real N "Atoms of product";
  Real N_T "Atoms of target";
initial equation
  N = 0;
  N_T = N_T_start;
equation
  der(N) = Nb;
  der(N_T) = -phi*sigma*N_T;
  Nb = phi*sigma*N_T - lambda*N;
  annotation (experiment(StopTime=12096000, __Dymola_NumberOfIntervals=12096));
end NeutronActivation;
