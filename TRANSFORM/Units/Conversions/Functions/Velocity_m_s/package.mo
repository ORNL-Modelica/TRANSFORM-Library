within TRANSFORM.Units.Conversions.Functions;
package Velocity_m_s "Conversions for velocity. SI unit is [m/s]"



  function to_m_s "Velocity: [m/s] -> [m/s]"
    extends BaseClasses.to;

  algorithm
    y := u;
  end to_m_s;

  function from_feet_s "Velocity: [ft/s] -> [m/s]"
    extends BaseClasses.from;

  algorithm
    y := u*12*0.0254;
  end from_feet_s;
end Velocity_m_s;
