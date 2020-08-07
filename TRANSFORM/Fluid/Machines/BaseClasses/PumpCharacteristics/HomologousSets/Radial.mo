within TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.HomologousSets;
model Radial
  "Example Radial style pump (converted from source)"
  extends PartialHomoSet(
  table_BAN=[ 0.000, 0.450;
              0.072, 0.486;
              0.144, 0.520;
              0.218, 0.552;
              0.294, 0.579;
              0.373, 0.603;
              0.457, 0.616;
              0.546, 0.617;
              0.643, 0.606;
              0.749, 0.582;
              0.867, 0.546;
              1.000, 0.500],
  table_BAD=[-1.000, 0.520;
             -0.867, 0.454;
             -0.749, 0.408;
             -0.643, 0.370;
             -0.546, 0.343;
             -0.457, 0.331;
             -0.373, 0.329;
             -0.294, 0.338;
             -0.218, 0.354;
             -0.144, 0.372;
             -0.072, 0.405;
              0.000, 0.450],
  table_BAR=[-1.000, -1.690;
             -0.867,-1.770;
             -0.749,-1.650;
             -0.643,-1.590;
             -0.546,-1.520;
             -0.457,-1.420;
             -0.373,-1.320;
             -0.294,-1.230;
             -0.218,-1.100;
             -0.144,-0.980;
             -0.072,-0.820;
              0.000,-0.684],
  table_BAT=[ 0.000,-0.684;
              0.072,-0.547;
              0.144,-0.414;
              0.218,-0.292;
              0.294,-0.187;
              0.373,-0.105;
              0.457,-0.053;
              0.546,-0.012;
              0.643, 0.042;
              0.749, 0.097;
              0.867, 0.156;
              1.000, 0.227],
  table_BVN=[ 0.000, 0.000;
              0.072,-0.002;
              0.144,-0.005;
              0.218,-0.008;
              0.294,-0.005;
              0.373, 0.005;
              0.457, 0.026;
              0.546, 0.064;
              0.643, 0.119;
              0.749, 0.202;
              0.867, 0.324;
              1.000, 0.500],
  table_BVD=[-1.000, 0.520;
             -0.867, 0.438;
             -0.749, 0.361;
             -0.643, 0.290;
             -0.546, 0.226;
             -0.457, 0.168;
             -0.373, 0.117;
             -0.294, 0.074;
             -0.218, 0.042;
             -0.144, 0.018;
             -0.072, 0.005;
              0.000, 0.000],
  table_BVR=[-1.000,-1.690;
             -0.867,-1.246;
             -0.749,-0.891;
             -0.643,-0.615;
             -0.546,-0.408;
             -0.457,-0.261;
             -0.373,-0.156;
             -0.294,-0.086;
             -0.218,-0.042;
             -0.144,-0.015;
             -0.072,-0.003;
              0.000, 0.000],
  table_BVT=[ 0.000, 0.000;
              0.072, 0.004;
              0.144, 0.016;
              0.218, 0.036;
              0.294, 0.064;
              0.373, 0.093;
              0.457, 0.124;
              0.546, 0.156;
              0.643, 0.183;
              0.749, 0.208;
              0.867, 0.225;
              1.000, 0.227],
  table_HAN=[ 0.000, 1.288;
              0.072, 1.281;
              0.144, 1.260;
              0.218, 1.225;
              0.294, 1.172;
              0.373, 1.107;
              0.457, 1.031;
              0.546, 0.942;
              0.643, 0.842;
              0.749, 0.733;
              0.867, 0.617;
              1.000, 0.500],
  table_HAD=[-1.000, 0.996;
             -0.867, 1.027;
             -0.749, 1.060;
             -0.643, 1.090;
             -0.546, 1.124;
             -0.457, 1.165;
             -0.373, 1.204;
             -0.294, 1.238;
             -0.218, 1.258;
             -0.144, 1.271;
             -0.072, 1.282;
              0.000, 1.288],
  table_HAR=[-1.000,-0.470;
             -0.867,-0.430;
             -0.749,-0.360;
             -0.643,-0.275;
             -0.546,-0.160;
             -0.457,-0.040;
             -0.373, 0.130;
             -0.294, 0.295;
             -0.218, 0.430;
             -0.144, 0.550;
             -0.072, 0.620;
              0.000, 0.634],
  table_HAT=[ 0.000, 0.634;
              0.072, 0.643;
              0.144, 0.646;
              0.218, 0.640;
              0.294, 0.629;
              0.373, 0.613;
              0.457, 0.595;
              0.546, 0.575;
              0.643, 0.552;
              0.749, 0.533;
              0.867, 0.516;
              1.000, 0.505],
  table_HVN=[ 0.000, 0.000;
              0.072,-0.003;
              0.144,-0.009;
              0.218,-0.016;
              0.294,-0.022;
              0.373,-0.023;
              0.457,-0.021;
              0.546, 0.003;
              0.643, 0.052;
              0.749, 0.134;
              0.867, 0.276;
              1.000, 0.500],
  table_HVD=[-1.000, 0.996;
             -0.867, 0.720;
             -0.749, 0.521;
             -0.643, 0.373;
             -0.546, 0.262;
             -0.457, 0.179;
             -0.373, 0.116;
             -0.294, 0.070;
             -0.218, 0.037;
             -0.144, 0.016;
             -0.072, 0.004;
              0.000, 0.000],
  table_HVR=[-1.000,-0.470;
             -0.867,-0.390;
             -0.749,-0.319;
             -0.643,-0.248;
             -0.546,-0.191;
             -0.457,-0.137;
             -0.373,-0.092;
             -0.294,-0.058;
             -0.218,-0.032;
             -0.144,-0.014;
             -0.072,-0.003;
              0.000, 0.000],
  table_HVT=[ 0.000, 0.000;
              0.072, 0.003;
              0.144, 0.013;
              0.218, 0.028;
              0.294, 0.050;
              0.373, 0.078;
              0.457, 0.112;
              0.546, 0.156;
              0.643, 0.211;
              0.749, 0.286;
              0.867, 0.378;
              1.000, 0.505],
  tCCF = table_BAN[end,2],
  hCCF = table_HAN[end,2]);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Radial;
