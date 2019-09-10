within TRANSFORM.PeriodicTable;
record SimpleTable
  constant Integer z[:]={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,
      23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,
      48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,
      73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,
      98,99,100,101,102,103,104,105,106,107,108,109,110,111,112}
    "Atomic number";
  constant String symbol[:]={"He","H","Li","Be","B","C","N","O","F","Ne","Na","Mg","Al","Si",
      "P","S","Cl","Ar","K","Ca","Sc","Ti","V","Cr","Mn","Fe","Co","Ni","Cu","Zn","Ga","Ge",
      "As","Se","Br","Kr","Rb","Sr","Y","Zr","Nb","Mo","Tc","Ru","Rh","Pd","Ag","Cd","In",
      "Sn","Sb","Te","I","Xe","Cs","Ba","La","Ce","Pr","Nd","Pm","Sm","Eu","Gd","Tb","Dy",
      "Ho","Er","Tm","Yb","Lu","Hf","Ta","W","Re","Os","Ir","Pt","Au","Hg","Tl","Pb","Bi",
      "Po","At","Rn","Fr","Ra","Ac","Th","Pa","U","Np","Pu","Am","Cm","Bk","Cf","Es","Fm",
      "Md","No","Lr","Rf","Db","Sg","Bh","Hs","Mt","Ds","Rg","Cn"}
    "Element symbol";
  constant String name[:]={"hydrogen","helium","lithium","beryllium","boron","carbon","nitrogen",
      "oxygen","fluorine","neon","sodium","magnesium","aluminum","silicon","phosphorus","sulfur",
      "chlorine","argon","potassium","calcium","scandium","titanium","vanadium","chromium",
      "manganese","iron","cobalt","nickel","copper","zinc","gallium","germanium","arsenic",
      "selenium","bromine","krypton","rubidium","strontium","yttrium","zirconium","niobium",
      "molybdenum","technetium","ruthenium","rhodium","palladium","silver","cadmium","indium",
      "tin","antimony","tellurium","iodine","xenon","cesium","barium","lanthanum","cerium",
      "praseodymium","neodymium","promethium","samarium","europium","gadolinium","terbium",
      "dysprosium","holmium","erbium","thulium","ytterbium","lutetium","hafnium","tantalum",
      "tungsten","rhenium","osmium","iridium","platinum","gold","mercury","thallium","lead",
      "bismuth","polonium","astatine","radon","francium","radium","actinium","thorium","protactinium",
      "uranium","neptunium","plutonium","americium","curium","berkelium","californium","einsteinium",
      "fermium","mendelevium","nobelium","lawrencium","rutherfordium","dubnium","seaborgium",
      "bohrium","hassium","meitnerium","darmstadtium","roentgenium","copernicium"}
    "Element name";
  constant Integer isotopesNatural[:]={2,2,2,1,2,2,2,3,1,3,1,3,1,3,1,4,2,3,3,6,
      1,5,2,4,1,4,1,5,2,5,2,5,1,6,2,6,2,4,1,5,1,7,0,7,1,6,2,8,2,10,2,8,1,9,1,7,2,
      4,1,7,0,7,2,7,1,7,1,6,1,7,2,6,2,5,2,7,2,6,1,7,2,4,1,0,0,0,0,0,0,1,1,3,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0} "Naturally occuring isotopes";
  constant SI.MolarMass MM[:]={0.001007947,0.004002602,0.0069412,0.009012182,0.0108117,
      0.01201078,0.01400672,0.01599943,0.018998403,0.02017976,0.022989769,0.02430506,
      0.026981539,0.02808553,0.030973762,0.0320655,0.0354532,0.0399481,0.03909831,
      0.0400784,0.044955913,0.0478671,0.05094151,0.05199616,0.054938046,0.0558452,
      0.058933196,0.05869342,0.0635463,0.0654094,0.0697231,0.072641,0.074921602,
      0.078963,0.0799041,0.0837982,0.08546783,0.087621,0.088905852,0.0912242,0.092906382,
      0.095942,999,0.101072,0.102905502,0.106421,0.10786822,0.1124118,0.1148183,
      0.1187107,0.1217601,0.127603,0.126904473,0.1312936,0.132905452,0.1373277,0.138905477,
      0.1401161,0.140907652,0.1442423,999,0.150362,0.1519641,0.157253,0.158925352,
      0.1625001,0.164930322,0.1672593,0.168934212,0.173043,0.1749671,0.178492,0.180947882,
      0.138841,0.1862071,0.190233,0.1922173,0.1950849,0.196966569,0.200592,0.20438332,
      0.20721,0.208980401,999,999,999,999,999,999,0.232038062,0.231035882,0.238028913,
      999,999,999,999,999,999,999,999,999,999,999,999,999,999,999,999,999,999,999,
      999} "Molar mass";
  annotation (Documentation(info="<html>
<p style=\"margin-left: 20px;\">Taken from the inside cover of:</p>
<p style=\"margin-left: 20px;\">Baum EM, Ernesti MC, Knox HD, Miller TR, Watson AM (2009) Chart of the Nuclides: Nuclides and Isotopes 17th Edition, Seventeenth. Bechtel Marine Propulsion Corporation</p>
</html>"));
end SimpleTable;
