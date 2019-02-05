#include "coolpropsolver.h"
#include "CoolPropTools.h"
#include "CoolPropDLL.h"
#include "CoolProp.h"
#include "CPState.h"
#include <iostream>
#include <string>
#include <stdlib.h>

//double _p_eps   ; // relative tolerance margin for subcritical pressure conditions
//double _T_eps   ; // relative tolerance margin for supercritical temperature conditions
//double _delta_h ; // delta_h for one-phase/two-phase discrimination
//ExternalSaturationProperties *_satPropsClose2Crit; // saturation properties close to  critical conditions

CoolPropSolver::CoolPropSolver(const std::string &mediumName, const std::string &libraryName, const std::string &substanceName)
	: BaseSolver(mediumName, libraryName, substanceName){

	// Fluid name can be used to pass in other parameters.
	// The string can be composed like "Propane|enable_TTSE=1|calc_transport=0"
	std::vector<std::string> name_options = strsplit(substanceName,'|');

	// Set the defaults
	fluidType       = -1;
	enable_TTSE     = false;
	enable_BICUBIC  = false;
	debug_level     = 0;
	calc_transport  = true;
	extend_twophase = true;
	twophase_derivsmoothing_xend = 0;
	rho_smoothing_xend = 0;
	hmin = 0;
	hmax = 0;
	pmin = 0;
	pmax = 0;
	

	// Initialise the saturation and near-critical variables
	_p_eps   = 1e-3; // relative tolerance margin for subcritical pressure conditions
	_delta_h = 1e-1; // delta_h for one-phase/two-phase discrimination

	if (name_options.size()>1)
	{
		for (unsigned int i = 1; i<name_options.size(); i++)
		{
			// Split around the equals sign
			std::vector<std::string> param_val = strsplit(name_options[i],'=');
			if (param_val.size() != 2)
			{
				errorMessage((char*)format("Could not parse the option [%s], must be in the form param=value",name_options[i].c_str()).c_str());
			}

			// Check each of the options in turn
			if (!param_val[0].compare("enable_TTSE"))
			{
				if (!param_val[1].compare("1") || !param_val[1].compare("true"))
				{
					std::cout << "TTSE is on\n";
					enable_TTSE = true;
				}
				else if (!param_val[1].compare("0") || !param_val[1].compare("false"))
				{
					std::cout << "TTSE is off\n";
					enable_TTSE = false;
				}
				else
					errorMessage((char*)format("I don't know how to handle this option [%s]",name_options[i].c_str()).c_str());
					//throw NotImplementedError((char*)format("I don't know how to handle this option [%s]",name_options[i].c_str()).c_str());
			}
			else if (!param_val[0].compare("enable_BICUBIC"))
			{
				if (!param_val[1].compare("1") || !param_val[1].compare("true"))
				{
					std::cout << "BICUBIC is on\n";
					enable_BICUBIC = true;
				}
				else if (!param_val[1].compare("0") || !param_val[1].compare("false"))
				{
					std::cout << "BICUBIC is off\n";
					enable_BICUBIC = false;
				}
				else
					errorMessage((char*)format("I don't know how to handle this option [%s]",name_options[i].c_str()).c_str());
					//throw NotImplementedError((char*)format("I don't know how to handle this option [%s]",name_options[i].c_str()).c_str());
			}
			//Added this to prevent regenerating the LUT tables
			
			else if (!param_val[0].compare("hmin"))
			{
				if (enable_BICUBIC)
				{
					hmin = strtod(param_val[1].c_str(),NULL);
				}
			}
			else if (!param_val[0].compare("hmax"))
			{
				if (enable_BICUBIC)
				{
					hmax = strtod(param_val[1].c_str(),NULL);
				}
			}
			else if (!param_val[0].compare("pmin"))
			{
				if (enable_BICUBIC)
				{
					pmin = strtod(param_val[1].c_str(),NULL);
				}
			}
			else if (!param_val[0].compare("pmax"))
			{
				if (enable_BICUBIC)
				{
					pmax = strtod(param_val[1].c_str(),NULL);
				}
			}
			
			// End addition
			else if (!param_val[0].compare("calc_transport"))
			{
				if (!param_val[1].compare("1") || !param_val[1].compare("true"))
					calc_transport = true;
				else if (!param_val[1].compare("0") || !param_val[1].compare("false"))
					calc_transport = false;
				else
					errorMessage((char*)format("I don't know how to handle this option [%s]",name_options[i].c_str()).c_str());
			}
			else if (!param_val[0].compare("enable_EXTTP"))
			{
				if (!param_val[1].compare("1") || !param_val[1].compare("true"))
					extend_twophase = true;
				else if (!param_val[1].compare("0") || !param_val[1].compare("false"))
					extend_twophase = false;
				else
					errorMessage((char*)format("I don't know how to handle this option [%s]",name_options[i].c_str()).c_str());
			}
			else if (!param_val[0].compare("twophase_derivsmoothing_xend"))
			{
				twophase_derivsmoothing_xend = strtod(param_val[1].c_str(),NULL);
				if (twophase_derivsmoothing_xend<0 || twophase_derivsmoothing_xend > 1)
					errorMessage((char*)format("I don't know how to handle this twophase_derivsmoothing_xend value [%d]",param_val[0].c_str()).c_str());
			}
			else if (!param_val[0].compare("rho_smoothing_xend"))
			{
				rho_smoothing_xend = strtod(param_val[1].c_str(),NULL);
				if (rho_smoothing_xend<0 || rho_smoothing_xend > 1)
					errorMessage((char*)format("I don't know how to handle this rho_smoothing_xend value [%d]",param_val[0].c_str()).c_str());
			}
			else if (!param_val[0].compare("debug"))
			{
				debug_level = (int)strtol(param_val[1].c_str(),NULL,0);
				if (debug_level<0 || debug_level > 1000) {
					errorMessage((char*)format("I don't know how to handle this debug level [%s]",param_val[0].c_str()).c_str());
				} else {
					// TODO: Fix this segmentation fault!
					//set_debug_level(debug_level);
				}
			}
			else
			{
				errorMessage((char*)format("This option [%s] was not understood",name_options[i].c_str()).c_str());
			}

			// Some options were passed in, lets see what we have
			std::cout << param_val[0] << " has the value of " << param_val[1] << std::endl;
		}
	}
	// Handle the name and fill the fluid type
	if (debug_level > 5) std::cout << "Checking fluid " << name_options[0] << " against database." << std::endl;
	fluidType = getFluidType(name_options[0]); // Throws an error if unknown fluid
	if (debug_level > 5) std::cout << "Check passed, reducing " << substanceName << " to " << name_options[0] << std::endl;
	this->substanceName = name_options[0];
	state = new CoolPropStateClassSI(name_options[0]);
	this->setFluidConstants();
}


CoolPropSolver::~CoolPropSolver(){
	delete state;
	//delete _satPropsClose2Crit;
};


void CoolPropSolver::setFluidConstants(){
	if ((fluidType==FLUID_TYPE_PURE)||(fluidType==FLUID_TYPE_PSEUDOPURE)||(fluidType==FLUID_TYPE_REFPROP)){
		if (debug_level > 5) std::cout << format("Setting constants for fluid %s \n",substanceName.c_str());
		_fluidConstants.pc = PropsSI((char *)"pcrit"   ,(char *)"T",0,(char *)"P",0,(char *)substanceName.c_str());
		_fluidConstants.Tc = PropsSI((char *)"Tcrit"   ,(char *)"T",0,(char *)"P",0,(char *)substanceName.c_str());
		_fluidConstants.MM = PropsSI((char *)"molemass",(char *)"T",0,(char *)"P",0,(char *)substanceName.c_str());
		/* TODO: Fix this dirty, dirty workaround */
		if (_fluidConstants.MM > 1.0) _fluidConstants.MM *= 1e-3;
		_fluidConstants.dc = PropsSI((char *)"rhocrit" ,(char *)"T",0,(char *)"P",0,(char *)substanceName.c_str());
		// Now we fill the close to crit record
		if (debug_level > 5) std::cout << format("Setting near-critical saturation conditions for fluid %s \n",substanceName.c_str());
		_satPropsClose2Crit.psat = _fluidConstants.pc*(1.0-_p_eps); // Needs update, setSat_p relies on it
		setSat_p(_satPropsClose2Crit.psat, &_satPropsClose2Crit);

	}
	else if ((fluidType==FLUID_TYPE_INCOMPRESSIBLE_LIQUID)||(fluidType==FLUID_TYPE_INCOMPRESSIBLE_SOLUTION)){
		if (debug_level > 5) std::cout << format("Setting constants for incompressible fluid %s \n",substanceName.c_str());
		_fluidConstants.pc = NAN;
		_fluidConstants.Tc = NAN;
		_fluidConstants.MM = NAN;// throws a warning in Modelica
		_fluidConstants.dc = NAN;
	}
}


void CoolPropSolver::preStateChange(void) {
	/// Some common code to avoid pitfalls from incompressibles
	if ((fluidType==FLUID_TYPE_PURE)||(fluidType==FLUID_TYPE_PSEUDOPURE)||(fluidType==FLUID_TYPE_REFPROP)){
		try {
			if (enable_TTSE)
				state->enable_TTSE_LUT();
			else
				state->disable_TTSE_LUT();

			if (enable_BICUBIC)
			{
				//Added this to prevent creating tables based on user input or maybe
				if (hmin != 0 || hmax != 0 || pmin != 0 || pmax != 0)
					state->set_TTSESinglePhase_LUT_range(hmin,hmax,pmin,pmax);
					//errorMessage((char*)"Billy bob howdy");
				// End addition
				state->enable_TTSE_LUT();
				state->pFluid->TTSESinglePhase.set_mode(TTSE_MODE_BICUBIC);
			}

			if (extend_twophase)
				state->enable_EXTTP();
			else
				state->disable_EXTTP();
		}
		catch(std::exception &e)
		{
			errorMessage((char*)e.what());
			std::cout << format("Exception from state object: %s \n",(char*)e.what());
		}
	}
}

void CoolPropSolver::postStateChange(ExternalThermodynamicState *const properties) {
	/// Some common code to avoid pitfalls from incompressibles
	switch (fluidType) {
		case FLUID_TYPE_PURE:
		case FLUID_TYPE_PSEUDOPURE:
		case FLUID_TYPE_REFPROP:
			try{
				// Set the values in the output structure
				properties->p = state->p();
				properties->T = state->T();
				properties->d = state->rho();
				properties->h = state->h();
				properties->s = state->s();
				if (state->TwoPhase){
					properties->phase = 2;
				}
				else{
					properties->phase = 1;
				}
				properties->cp = state->cp();
				properties->cv = state->cv();
				properties->a = state->speed_sound();
				if (state->TwoPhase && state->Q() >= 0 && state->Q() <= twophase_derivsmoothing_xend && twophase_derivsmoothing_xend > 0.0)
				{
					// Use the smoothed derivatives between a quality of 0 and twophase_derivsmoothing_xend
					properties->ddhp = state->drhodh_constp_smoothed(twophase_derivsmoothing_xend); // [1/kPa -- > 1/Pa]
					properties->ddph = state->drhodp_consth_smoothed(twophase_derivsmoothing_xend); // [1/(kJ/kg) -- > 1/(J/kg)]
				}
				else if (state->TwoPhase && state->Q() >= 0 && state->Q() <= rho_smoothing_xend && rho_smoothing_xend > 0.0)
				{
					// Use the smoothed density between a quality of 0 and rho_smoothing_xend
					double rho_spline;
					double dsplinedh;
					double dsplinedp;
					state->rho_smoothed(rho_smoothing_xend, rho_spline, dsplinedh, dsplinedp) ;
					properties->ddhp = dsplinedh;
					properties->ddph = dsplinedp;
					properties->d = rho_spline;
				}
				else
				{
					properties->ddhp = state->drhodh_constp();
					properties->ddph = state->drhodp_consth();
				}
				properties->kappa = state->isothermal_compressibility();
				properties->beta = state->isobaric_expansion_coefficient();

				if (calc_transport)
				{
					properties->eta = state->viscosity();
					properties->lambda = state->conductivity(); //[kW/m/K --> W/m/K]
				} else {
					properties->eta    = NAN;
					properties->lambda = NAN;
				}
			}
			catch(std::exception &e)
			{
				errorMessage((char*)e.what());
			}
			break;
		case FLUID_TYPE_INCOMPRESSIBLE_LIQUID:
		case FLUID_TYPE_INCOMPRESSIBLE_SOLUTION:
			try{
				// Set the values in the output structure
				properties->p = state->p();
				properties->T = state->T();
				properties->d = state->rho();
				properties->h = state->h();
				properties->s = state->s();
				properties->phase = 1;
				properties->cp = state->cp();
				properties->cv = state->cv();
				properties->a     = NAN;
				properties->ddhp = state->drhodh_constp();
				properties->ddph = 0.0; // TODO: Fix this
				properties->kappa = NAN;
				properties->beta  = NAN;
				if (calc_transport)
				{
					properties->eta = state->viscosity();
					properties->lambda = state->conductivity(); //[kW/m/K --> W/m/K]
				} else {
					properties->eta    = NAN;
					properties->lambda = NAN;
				}
			}
			catch(std::exception &e)
			{
				errorMessage((char*)e.what());
			}
			break;
		default:
			errorMessage((char*)"Invalid fluid type!");
			break;
	}
	if (debug_level > 50) std::cout << format("At the end of %s \n","postStateChange");
	if (debug_level > 50) std::cout << format("Setting pressure to %f \n",properties->p);
	if (debug_level > 50) std::cout << format("Setting temperature to %f \n",properties->T);
	if (debug_level > 50) std::cout << format("Setting density to %f \n",properties->d);
	if (debug_level > 50) std::cout << format("Setting enthalpy to %f \n",properties->h);
	if (debug_level > 50) std::cout << format("Setting entropy to %f \n",properties->s);
}


void CoolPropSolver::setSat_p(double &p, ExternalSaturationProperties *const properties){

	if (debug_level > 5)
		std::cout << format("setSat_p(%0.16e)\n",p);

	if (p > _satPropsClose2Crit.psat) { // supercritical conditions
		properties->Tsat  = _satPropsClose2Crit.Tsat;  // saturation temperature
		properties->dTp   = _satPropsClose2Crit.dTp;   // derivative of Ts by pressure
		properties->ddldp = _satPropsClose2Crit.ddldp; // derivative of dls by pressure
		properties->ddvdp = _satPropsClose2Crit.ddvdp; // derivative of dvs by pressure
		properties->dhldp = _satPropsClose2Crit.dhldp; // derivative of hls by pressure
		properties->dhvdp = _satPropsClose2Crit.dhvdp; // derivative of hvs by pressure
		properties->dl    = _satPropsClose2Crit.dl;    // bubble density
		properties->dv    = _satPropsClose2Crit.dv;    // dew density
		properties->hl    = _satPropsClose2Crit.hl;    // bubble specific enthalpy
		properties->hv    = _satPropsClose2Crit.hv;    // dew specific enthalpy
		properties->psat  = _satPropsClose2Crit.psat;  // saturation pressure
		properties->sigma = _satPropsClose2Crit.sigma; // Surface tension
		properties->sl    = _satPropsClose2Crit.sl;    // Specific entropy at bubble line (for pressure ps)
		properties->sv    = _satPropsClose2Crit.sv;    // Specific entropy at dew line (for pressure ps)
	} else {
	  this->preStateChange();
	  try {
		state->update(iP,p,iQ,0); // quality only matters for pseudo-pure fluids
		//! Saturation temperature
		properties->Tsat = state->TL(); // Not correct for pseudo-pure fluids
		//! Derivative of Ts wrt pressure
		properties->dTp = state->dTdp_along_sat();
		//! Derivative of dls wrt pressure
		properties->ddldp = state->drhodp_along_sat_liquid();
		//! Derivative of dvs wrt pressure
		properties->ddvdp = state->drhodp_along_sat_vapor();
		//! Derivative of hls wrt pressure
		properties->dhldp = state->dhdp_along_sat_liquid();
		//! Derivative of hvs wrt pressure
		properties->dhvdp = state->dhdp_along_sat_vapor();
		//! Density at bubble line (for pressure ps)
		properties->dl = state->rhoL();
		//! Density at dew line (for pressure ps)
		properties->dv = state->rhoV();
		//! Specific enthalpy at bubble line (for pressure ps)
		properties->hl = state->hL();
		//! Specific enthalpy at dew line (for pressure ps)
		properties->hv = state->hV();
		//! Saturation pressure
		properties->psat = p;
		//! Surface tension
		properties->sigma = state->surface_tension();
		//! Specific entropy at bubble line (for pressure ps)
		properties->sl = state->sL();
		//! Specific entropy at dew line (for pressure ps)
		properties->sv = state->sV();
	  } catch(std::exception &e) {
		errorMessage((char*)e.what());
	  }
    }
}

void CoolPropSolver::setSat_T(double &T, ExternalSaturationProperties *const properties){

	if (debug_level > 5)
		std::cout << format("setSat_T(%0.16e)\n",T);

	if (T > _satPropsClose2Crit.Tsat) { // supercritical conditions
		properties->Tsat  = _satPropsClose2Crit.Tsat;  // saturation temperature
		properties->dTp   = _satPropsClose2Crit.dTp;   // derivative of Ts by pressure
		properties->ddldp = _satPropsClose2Crit.ddldp; // derivative of dls by pressure
		properties->ddvdp = _satPropsClose2Crit.ddvdp; // derivative of dvs by pressure
		properties->dhldp = _satPropsClose2Crit.dhldp; // derivative of hls by pressure
		properties->dhvdp = _satPropsClose2Crit.dhvdp; // derivative of hvs by pressure
		properties->dl    = _satPropsClose2Crit.dl;    // bubble density
		properties->dv    = _satPropsClose2Crit.dv;    // dew density
		properties->hl    = _satPropsClose2Crit.hl;    // bubble specific enthalpy
		properties->hv    = _satPropsClose2Crit.hv;    // dew specific enthalpy
		properties->psat  = _satPropsClose2Crit.psat;  // saturation pressure
		properties->sigma = _satPropsClose2Crit.sigma; // Surface tension
		properties->sl    = _satPropsClose2Crit.sl;    // Specific entropy at bubble line (for pressure ps)
		properties->sv    = _satPropsClose2Crit.sv;    // Specific entropy at dew line (for pressure ps)
	} else {
	  this->preStateChange();
	  try
	  {
		state->update(iT,T,iQ,0); // Quality only matters for pseudo-pure fluids

		properties->Tsat = T;
		properties->psat = state->pL();
		properties->dl = state->rhoL();
		properties->dv = state->rhoV();
		properties->hl = state->hL();
		properties->hv = state->hV();
		properties->dTp = state->dTdp_along_sat();

		properties->ddldp = state->drhodp_along_sat_liquid();
		properties->ddvdp = state->drhodp_along_sat_vapor();
		properties->dhldp = state->dhdp_along_sat_liquid();
		properties->dhvdp = state->dhdp_along_sat_vapor();

		properties->sigma = state->surface_tension(); // Surface tension
		properties->sl    = state->sL();    // Specific entropy at bubble line (for pressure ps)
		properties->sv    = state->sV();    // Specific entropy at dew line (for pressure ps)


	  } catch(std::exception &e) {
		errorMessage((char*)e.what());
	  }
	}
}

/// Set bubble state
void CoolPropSolver::setBubbleState(ExternalSaturationProperties *const properties, int phase, ExternalThermodynamicState *const bubbleProperties){
	double hl;
	if (phase == 0)
		hl = properties->hl;
	else if (phase == 1) // liquid phase
		hl = properties->hl-_delta_h;
	else                 // two-phase mixture
		hl = properties->hl+_delta_h;

	setState_ph(properties->psat, hl, phase, bubbleProperties);
}

/// Set dew state
void CoolPropSolver::setDewState(ExternalSaturationProperties *const properties, int phase, ExternalThermodynamicState *const dewProperties){
	double hv;
	if (phase == 0)
		hv = properties->hv;
	else if (phase == 1) // gaseous phase
		hv = properties->hv+_delta_h;
	else                 // two-phase mixture
		hv = properties->hv-_delta_h;

	setState_ph(properties->psat, hv, phase, dewProperties);
}

// Note: the phase input is currently not supported
void CoolPropSolver::setState_ph(double &p, double &h, int &phase, ExternalThermodynamicState *const properties){

	if (debug_level > 5)
		std::cout << format("setState_ph(p=%0.16e,h=%0.16e)\n",p,h);

	this->preStateChange();

	try{
		// Update the internal variables in the state instance
		state->update(iP,p,iH,h);

		if (!ValidNumber(state->rho()) || !ValidNumber(state->T()))
		{
			throw ValueError(format("p-h [%g, %g] failed for update",p,h));
		}

		// Set the values in the output structure
		this->postStateChange(properties);
	}
	catch(std::exception &e)
	{
		errorMessage((char*)e.what());
	}
}

void CoolPropSolver::setState_pT(double &p, double &T, ExternalThermodynamicState *const properties){

	if (debug_level > 5)
		std::cout << format("setState_pT(p=%0.16e,T=%0.16e)\n",p,T);

	this->preStateChange();

	try{
		// Update the internal variables in the state instance
		state->update(iP,p,iT,T);

		// Set the values in the output structure
		this->postStateChange(properties);
	}
	catch(std::exception &e)
	{
		errorMessage((char*)e.what());
	}
}

// Note: the phase input is currently not supported
void CoolPropSolver::setState_dT(double &d, double &T, int &phase, ExternalThermodynamicState *const properties)
{

	if (debug_level > 5)
		std::cout << format("setState_dT(d=%0.16e,T=%0.16e)\n",d,T);

	this->preStateChange();

	try{

		// Update the internal variables in the state instance
		state->update(iD,d,iT,T);

		// Set the values in the output structure
		this->postStateChange(properties);
	}
	catch(std::exception &e)
	{
		errorMessage((char*)e.what());
	}
}

// Note: the phase input is currently not supported
void CoolPropSolver::setState_ps(double &p, double &s, int &phase, ExternalThermodynamicState *const properties){

	if (debug_level > 5)
		std::cout << format("setState_ps(p=%0.16e,s=%0.16e)\n",p,s);

	this->preStateChange();

	try{
		// Update the internal variables in the state instance
		state->update(iP,p,iS,s);

		// Set the values in the output structure
		this->postStateChange(properties);
	}
	catch(std::exception &e)
	{
		errorMessage((char*)e.what());
	}
}


// Note: the phase input is currently not supported
void CoolPropSolver::setState_hs(double &h, double &s, int &phase, ExternalThermodynamicState *const properties){

	if (debug_level > 5)
		std::cout << format("setState_hs(h=%0.16e,s=%0.16e)\n",h,s);

	this->preStateChange();

	try{
		// Update the internal variables in the state instance
		state->update(iH,h,iS,s);

		// Set the values in the output structure
		this->postStateChange(properties);
	}
	catch(std::exception &e)
	{
		errorMessage((char*)e.what());
	}
}

double CoolPropSolver::partialDeriv_state(const string &of, const string &wrt, const string &cst, ExternalThermodynamicState *const properties){
	if (debug_level > 5)
		std::cout << format("partialDeriv_state(of=%s,wrt=%s,cst=%s,state)\n",of.c_str(),wrt.c_str(),cst.c_str());

	long derivTerm = makeDerivString(of,wrt,cst);
	double res = NAN;

	try{
		//res = DerivTerms(derivTerm, properties->d, properties->T, this->substanceName);
		state->update(iT,properties->T,iD,properties->d);
		// Get the output value
		res = state->keyed_output(derivTerm);
	} catch(std::exception &e) {
		errorMessage((char*)e.what());
	}
	return res;
}

long CoolPropSolver::makeDerivString(const string &of, const string &wrt, const string &cst){
	std::string derivTerm;
	     if (!of.compare("d")){ derivTerm = "drho"; }
	else if (!of.compare("p")){ derivTerm = "dp"; }
	else {
		errorMessage((char*) format("Internal error: Derivatives of %s are not defined in the Solver object.",of.c_str()).c_str());
	}
	if      (!wrt.compare("p")){ derivTerm.append("dp"); }
	else if (!wrt.compare("h")){ derivTerm.append("dh"); }
	else if (!wrt.compare("T")){ derivTerm.append("dT"); }
	else {
		errorMessage((char*) format("Internal error: Derivatives with respect to %s are not defined in the Solver object.",wrt.c_str()).c_str());
	}
	if      (!cst.compare("p")){ derivTerm.append("|p"); }
	else if (!cst.compare("h")){ derivTerm.append("|h"); }
	else if (!cst.compare("d")){ derivTerm.append("|rho"); }
	else {
		errorMessage((char*) format("Internal error: Derivatives at constant %s are not defined in the Solver object.",cst.c_str()).c_str());
	}
	long iOutput = get_param_index(derivTerm);
	return iOutput;
}


double CoolPropSolver::Pr(ExternalThermodynamicState *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: Pr() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: Pr() not implemented in the Solver object");
	return NAN;
}

double CoolPropSolver::T(ExternalThermodynamicState *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: T() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: T() not implemented in the Solver object");
	return NAN;
}

double CoolPropSolver::a(ExternalThermodynamicState *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: a() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: a() not implemented in the Solver object");
	return NAN;
}

double CoolPropSolver::beta(ExternalThermodynamicState *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: beta() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: beta() not implemented in the Solver object");
	return NAN;
}

double CoolPropSolver::cp(ExternalThermodynamicState *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: cp() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: cp() not implemented in the Solver object");
	return NAN;
}

double CoolPropSolver::cv(ExternalThermodynamicState *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: cv() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: cv() not implemented in the Solver object");
	return NAN;
}

double CoolPropSolver::d(ExternalThermodynamicState *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: d() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: d() not implemented in the Solver object");
	return NAN;
}

double CoolPropSolver::ddhp(ExternalThermodynamicState *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: ddhp() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: ddhp() not implemented in the Solver object");
	return NAN;
}

double CoolPropSolver::ddph(ExternalThermodynamicState *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: ddph() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: ddph() not implemented in the Solver object");
	return NAN;
}

double CoolPropSolver::eta(ExternalThermodynamicState *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: eta() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: eta() not implemented in the Solver object");
	return NAN;
}

double CoolPropSolver::h(ExternalThermodynamicState *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: h() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: h() not implemented in the Solver object");
	return NAN;
}

double CoolPropSolver::kappa(ExternalThermodynamicState *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: kappa() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: kappa() not implemented in the Solver object");
	return NAN;
}

double CoolPropSolver::lambda(ExternalThermodynamicState *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: lambda() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: lambda() not implemented in the Solver object");
	return NAN;
}

double CoolPropSolver::p(ExternalThermodynamicState *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: p() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: p() not implemented in the Solver object");
	return NAN;
}

int CoolPropSolver::phase(ExternalThermodynamicState *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: phase() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: phase() not implemented in the Solver object");
	return -1;
}

double CoolPropSolver::s(ExternalThermodynamicState *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: s() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: s() not implemented in the Solver object");
	return NAN;
}

double CoolPropSolver::d_der(ExternalThermodynamicState *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: d_der() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: d_der() not implemented in the Solver object");
	return NAN;
}

double CoolPropSolver::isentropicEnthalpy(double &p, ExternalThermodynamicState *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: isentropicEnthalpy() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: isentropicEnthalpy() not implemented in the Solver object");
	return NAN;
}

double CoolPropSolver::dTp(ExternalSaturationProperties *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: dTp() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: dTp() not implemented in the Solver object");
	return NAN;
}

double CoolPropSolver::ddldp(ExternalSaturationProperties *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: ddldp() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: ddldp() not implemented in the Solver object");
	return NAN;
}

double CoolPropSolver::ddvdp(ExternalSaturationProperties *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: ddvdp() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: ddvdp() not implemented in the Solver object");
	return NAN;
}

double CoolPropSolver::dhldp(ExternalSaturationProperties *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: dhldp() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: dhldp() not implemented in the Solver object");
	return NAN;
}

double CoolPropSolver::dhvdp(ExternalSaturationProperties *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: dhvdp() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: dhvdp() not implemented in the Solver object");
	return NAN;
}

double CoolPropSolver::dl(ExternalSaturationProperties *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: dl() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: dl() not implemented in the Solver object");
	return NAN;
}

double CoolPropSolver::dv(ExternalSaturationProperties *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: dv() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: dv() not implemented in the Solver object");
	return NAN;
}

double CoolPropSolver::hl(ExternalSaturationProperties *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: hl() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: hl() not implemented in the Solver object");
	return NAN;
}

double CoolPropSolver::hv(ExternalSaturationProperties *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: hv() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: hv() not implemented in the Solver object");
	return NAN;
}

double CoolPropSolver::sigma(ExternalSaturationProperties *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: sigma() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: sigma() not implemented in the Solver object");
	return NAN;
}

double CoolPropSolver::sl(ExternalSaturationProperties *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: sl() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: sl() not implemented in the Solver object");
	return NAN;
}

double CoolPropSolver::sv(ExternalSaturationProperties *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: sv() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: sv() not implemented in the Solver object");
	return NAN;
}

double CoolPropSolver::psat(ExternalSaturationProperties *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: psat() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: psat() not implemented in the Solver object");
	return NAN;
}

double CoolPropSolver::Tsat(ExternalSaturationProperties *const properties){
    // Base function returns an error if called - should be redeclared by the solver object
	errorMessage((char*)"Internal error: Tsat() not implemented in the Solver object");
	//throw NotImplementedError((char*)"Internal error: Tsat() not implemented in the Solver object");
	return NAN;
}

