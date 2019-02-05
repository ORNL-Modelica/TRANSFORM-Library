#ifndef COOLPROPSOLVER_H_
#define COOLPROPSOLVER_H_

#include "basesolver.h"

//! CoolProp solver class
/*!
  This class defines a solver that calls out to the open-source CoolProp
  property database and is partly inspired by the fluidpropsolver that
  was part of the first ExternalMedia release.


  libraryName = "CoolProp";

  Ian Bell (ian.h.bell@gmail.com)
  University of Liege,
  Liege, Belgium

  Jorrit Wronski (jowr@mek.dtu.dk)
  Technical University of Denmark,
  Kgs. Lyngby, Denmark

  2012-2014
*/
class CoolPropSolver : public BaseSolver{

protected:
	class CoolPropStateClassSI *state;
	bool enable_TTSE, enable_BICUBIC, calc_transport;
	int debug_level;
	double twophase_derivsmoothing_xend;
	double rho_smoothing_xend;
	long fluidType;
	double _p_eps   ; // relative tolerance margin for subcritical pressure conditions
	double _delta_h ; // delta_h for one-phase/two-phase discrimination
	ExternalSaturationProperties _satPropsClose2Crit; // saturation properties close to  critical conditions

	virtual void  preStateChange(void);
	virtual void postStateChange(ExternalThermodynamicState *const properties);
	long makeDerivString(const string &of, const string &wrt, const string &cst);

public:
	CoolPropSolver(const std::string &mediumName, const std::string &libraryName, const std::string &substanceName);
	~CoolPropSolver();
	virtual void setFluidConstants();

	virtual void setState_ph(double &p, double &h, ExternalThermodynamicState *const properties);
	virtual void setState_pT(double &p, double &T, ExternalThermodynamicState *const properties);
	virtual void setState_dT(double &d, double &T, ExternalThermodynamicState *const properties);
	virtual void setState_ps(double &p, double &s, ExternalThermodynamicState *const properties);
	virtual void setState_hs(double &h, double &s, ExternalThermodynamicState *const properties);

	virtual double partialDeriv_state(const string &of, const string &wrt, const string &cst, ExternalThermodynamicState *const properties);

	virtual double Pr(ExternalThermodynamicState *const properties);
	virtual double T(ExternalThermodynamicState *const properties);
	virtual double a(ExternalThermodynamicState *const properties);
	virtual double beta(ExternalThermodynamicState *const properties);
	virtual double cp(ExternalThermodynamicState *const properties);
	virtual double cv(ExternalThermodynamicState *const properties);
	virtual double d(ExternalThermodynamicState *const properties);
	virtual double ddhp(ExternalThermodynamicState *const properties);
	virtual double ddph(ExternalThermodynamicState *const properties);
	virtual double eta(ExternalThermodynamicState *const properties);
	virtual double h(ExternalThermodynamicState *const properties);
	virtual double kappa(ExternalThermodynamicState *const properties);
	virtual double lambda(ExternalThermodynamicState *const properties);
	virtual double p(ExternalThermodynamicState *const properties);
	virtual double s(ExternalThermodynamicState *const properties);
	virtual double d_der(ExternalThermodynamicState *const properties);
};

#endif // COOLPROPSOLVER_H_
