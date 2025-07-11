within TRANSFORM.Media.Fluids.FLiBe.Utilities_FLiBe;
function d_T
  input SI.Temperature T;
  output SI.Density d;
algorithm
  // ORNL/TM-2006/12 Not clear where this came from but it seems to be accurate as written when compared to the results from . Eq 1 (Table 4)
  // Also matches: https://www.researchgate.net/publication/287324762
  // Table 4: d := -0.488*(T-273.15) + 2280;
  d:=-0.4884*T+2413;
end d_T;
