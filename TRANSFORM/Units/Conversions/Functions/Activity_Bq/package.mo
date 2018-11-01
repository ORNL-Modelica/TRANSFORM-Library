within TRANSFORM.Units.Conversions.Functions;
package Activity_Bq "Conversions for activity (e.g., bequeral, curies). SI unit is [Bq], i.e., [1/s]"

  function to_Bq "Activity: [Bq] -> [Bq]"
    extends BaseClasses.to;

  algorithm
    y := u;
  end to_Bq;
end Activity_Bq;
