within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.Control.ControlBuses;
expandable connector ControlBus_SteamGenerator
  "Control bus that is adapted 
  to the signals connected to it"
  extends
    TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.Control.Interfaces.SignalBus;
  input Real u_MSIValve "Main Steam Insolation Valve input [0-1]" annotation ();
  input Real u_SGBlockValve "Steam Generator Block Valve input [0-1]" annotation ();
  output Real y_drum_pressure "Drum pressure [Pa]" annotation ();
  output Real y_drum_level "Drum level [%]" annotation ();
  output Real y_drum_steamFlow "Drum steam flow [kg/s]" annotation ();
  output Real y_drum_FeedWaterFlow "Drum feedwater flow [kg/s]" annotation ();
  annotation (Documentation(info="<html>
<h4>Description</h4>
<p>Control bus for the Rankine example. </p>
</html>",
    revisions="<html>
<!--copyright-->
</html>"));
end ControlBus_SteamGenerator;
