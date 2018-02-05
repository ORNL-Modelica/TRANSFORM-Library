within TRANSFORM.Examples.MoltenSaltReactor.Data;
record Summary

  replaceable package Medium_PFL = Modelica.Media.Interfaces.PartialMedium annotation(choicesAllMatching=true);
  replaceable package Medium_OffGas = Modelica.Media.Interfaces.PartialMedium annotation(choicesAllMatching=true);
  replaceable package Material_Graphite =
      TRANSFORM.Media.Interfaces.Solids.PartialAlloy                                     annotation(choicesAllMatching=true);
  replaceable package Material_Vessel =
      TRANSFORM.Media.Interfaces.Solids.PartialAlloy                                   annotation(choicesAllMatching=true);

  parameter SI.Temperature Tref = 873.15 "ref temperature for volume calcs";
  parameter SI.Pressure pref = 1e5 "ref pressure for volume calcs";

  parameter SI.Density d_PFL = Medium_PFL.density(Medium_PFL.setState_pTX(pref,Tref));
  parameter SI.Density d_G = Material_Graphite.density_T(Tref);

  input Real nG_reflA_blocks "# of graphite blocks per fuel cell" annotation(Dialog(tab="PFL",group="Input Variables"));
  input Real dims_reflAG[3] "rin, rout, angle of graphite blocks" annotation(Dialog(tab="PFL",group="Input Variables"));
  input SI.Area crossArea_reflA "Cross sectional area of fuel" annotation(Dialog(tab="PFL",group="Input Variables"));
  input SI.Length perimeter_reflA "wetted perimeter of fuel" annotation(Dialog(tab="PFL",group="Input Variables"));
  input SI.Area surfaceArea_reflA "surface area of fuel to graphite" annotation(Dialog(tab="PFL",group="Input Variables"));
  input SI.Mass m_reflAG "mass of graphite in core" annotation(Dialog(tab="PFL",group="Input Variables"));
  input SI.Mass m_reflA "mass of fuel in core" annotation(Dialog(tab="PFL",group="Input Variables"));
  input SI.Volume volume_reflAG = m_reflAG/Material_Graphite.density_T(Tref) "volume of graphite in ax refl at Tref" annotation(Dialog(tab="PFL",group="Input Variables"));
  input SI.Volume volume_reflA = m_reflA/Medium_PFL.density(Medium_PFL.setState_pTX(pref,Tref)) "volume of fuel in ax refl at Tref" annotation(Dialog(tab="PFL",group="Input Variables"));

  input Real nG_reflR_blocks "# of graphite blocks per fuel cell" annotation(Dialog(tab="PFL",group="Input Variables"));
  input Real dims_reflRG[3] "rin, rout, angle of graphite blocks" annotation(Dialog(tab="PFL",group="Input Variables"));
  input SI.Area crossArea_reflR "Cross sectional area of fuel" annotation(Dialog(tab="PFL",group="Input Variables"));
  input SI.Length perimeter_reflR "wetted perimeter of fuel" annotation(Dialog(tab="PFL",group="Input Variables"));
  input SI.Area surfaceArea_reflR "surface area of fuel to graphite" annotation(Dialog(tab="PFL",group="Input Variables"));
  input SI.Mass m_reflRG "mass of graphite in core" annotation(Dialog(tab="PFL",group="Input Variables"));
  input SI.Mass m_reflR "mass of fuel in core" annotation(Dialog(tab="PFL",group="Input Variables"));
  input SI.Volume volume_reflRG = m_reflRG/Material_Graphite.density_T(Tref) "volume of graphite in rad refl at Tref" annotation(Dialog(tab="PFL",group="Input Variables"));
  input SI.Volume volume_reflR = m_reflR/Medium_PFL.density(Medium_PFL.setState_pTX(pref,Tref)) "volume of fuel in rad refl at Tref" annotation(Dialog(tab="PFL",group="Input Variables"));

  input Real nG_fuelCell "# of graphite blocks per fuel cell" annotation(Dialog(tab="PFL",group="Input Variables"));
  input SI.Length dims_fuelG[3] "Lenght,width,height of graphite blocks" annotation(Dialog(tab="PFL",group="Input Variables"));
  input SI.Area crossArea_fuel "Cross sectional area of fuel" annotation(Dialog(tab="PFL",group="Input Variables"));
  input SI.Length perimeter_fuel "wetted perimeter of fuel" annotation(Dialog(tab="PFL",group="Input Variables"));
  input SI.Area surfaceArea_fuel "surface area of fuel to graphite" annotation(Dialog(tab="PFL",group="Input Variables"));
  input SI.Mass m_fuelG "mass of graphite in core" annotation(Dialog(tab="PFL",group="Input Variables"));
  input SI.Mass m_fuel "mass of fuel in core" annotation(Dialog(tab="PFL",group="Input Variables"));
  input SI.Volume volume_fuelG = m_fuelG/Material_Graphite.density_T(Tref) "volume of graphite in core at Tref" annotation(Dialog(tab="PFL",group="Input Variables"));
  input SI.Volume volume_fuel = m_fuel/Medium_PFL.density(Medium_PFL.setState_pTX(pref,Tref)) "volume of fuel in core at Tref" annotation(Dialog(tab="PFL",group="Input Variables"));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Summary;
