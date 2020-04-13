within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.Records;
record NominalData
  extends TRANSFORM.Icons.Record;
  // Conversion factors
  constant Real psi_to_Pa=6894.75729 "psia to Pa";
  constant Real lb_to_kg=0.45359237 "lb to kg conversion factor";
  constant Real inchMercuryAbs_to_Pa=3386 "Inch Mercury to Pa conversion factor";
  constant Real btu_per_h_to_Watt=0.29307107 "Btu per hour to Watt";
  constant Real inch_to_m=0.0254 "Inch to meter";
  // Raw data (declared as constants to be able to reference them without instatiation
  constant Real steamRate=1.8e6 "lb/hour";
  constant Real steamPressure=1000 "psi";
  constant Real steamTemperature=545 "Fahrenheit";
  constant Real feedWaterTemperature=420 "Fahrenheit";
  constant Real condenserPressure=2.5 "in. of Mercury absolute";
  constant Real condenserHeatRate=3.1e9 "Btu/hr";
  constant Real sodiumRate=18.33e6 "lb/hour";
  constant Real Tin_sodium=800 "Fahrenheit";
  constant Real Tout_sodium=538.7 "Fahrenheit";
  constant Real Tin_SG_water=440 "Fahrenheit";
  constant Real pin_SG_water=1036 "psia";
  constant Real drumRecirculationRate=2.2 "lb m/h * 10^-6";
  // constants to reference in model
  constant Modelica.SIunits.MassFlowRate steamRate_kg_per_s=steamRate*lb_to_kg/3600;
  constant Modelica.SIunits.MassFlowRate drumRecirculationRate_kg_per_s=drumRecirculationRate*lb_to_kg/3600*10^6;
  constant Modelica.SIunits.MassFlowRate sodiumRate_kg_per_s=sodiumRate*lb_to_kg/3600;
  constant Modelica.SIunits.Pressure steamPressure_Pa=steamPressure*psi_to_Pa;
  constant Modelica.SIunits.Pressure pin_SG_water_Pa=pin_SG_water*psi_to_Pa;
  constant Modelica.SIunits.Pressure condenserPressure_Pa=condenserPressure*inchMercuryAbs_to_Pa;
  constant Modelica.SIunits.HeatFlowRate condenserHeatRate_W=condenserHeatRate*btu_per_h_to_Watt/3600;
  constant Modelica.SIunits.Temperature steamTemperature_K=Modelica.SIunits.Conversions.from_degF(steamTemperature);
  constant Modelica.SIunits.Temperature feedWaterTemperature_K=Modelica.SIunits.Conversions.from_degF(feedWaterTemperature);
  constant Modelica.SIunits.Temperature T_SG_water_in=Modelica.SIunits.Conversions.from_degF(Tin_SG_water);
  constant Modelica.SIunits.Temperature Tin_sodium_K=Modelica.SIunits.Conversions.from_degF(Tin_sodium);
  constant Modelica.SIunits.Temperature Tout_sodium_K=Modelica.SIunits.Conversions.from_degF(Tout_sodium);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<!--copyright-->
</html>"));
end NominalData;
