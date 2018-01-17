within TRANSFORM.Units.Conversions.Functions;
package DynamicViscosity_kg_ms "Conversions for dynamic viscosity. SI unit is [kg/(m*s)]."



  function to_kg_ms "Dynamic Viscosity: [kg/(m*s)] -> [kg/(m*s)]"
    extends BaseClasses.to;

  algorithm
    y := u;
  end to_kg_ms;

  function from_lb_hrfeet "Dynamic Viscosity: [lb/(ft*hr)] -> [kg/(m*s)]"
    extends BaseClasses.from;

  algorithm
    y := u*0.453592/(12*0.0254*60^2);
  end from_lb_hrfeet;
end DynamicViscosity_kg_ms;
