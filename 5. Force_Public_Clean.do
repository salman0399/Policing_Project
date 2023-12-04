*******************Cleaning Force Public*******************
*****************Last Updated: Feb 23, 2021****************
local raw_data "/Users/salman/Dropbox (DeAngelo Consulting)/DeAngelo Consulting Team Folder/Dallas Police CJL/1-raw_data"
local stata_data "/Users/salman/Dropbox (DeAngelo Consulting)/DeAngelo Consulting Team Folder/Dallas Police CJL/2-stata_data"
local temp_data "/Users/salman/Dropbox (DeAngelo Consulting)/DeAngelo Consulting Team Folder/Dallas Police CJL/2-stata_data/temp_files"
* Improting the data files into STATA
clear
set more off
gen x = . 
save "`temp_data'/DPD_force-public.dta", replace 	//Creating a file in which we will import all the requested force data

forvalues i = 13/19 {
		import excel "`raw_data'/DPD_Force-Public/Police_Response_to_Resistance_20`i'.xlsx", firstrow allstring clear
		gen fileyear = 20`i'
		append using "`temp_data'/DPD_force-public.dta"
		save "`temp_data'/DPD_force-public.dta", replace
	}
drop x
replace OCCURRED_T = OCCURRED_TM if fileyear == 2014 	// The variable names of these two variables were different in year 2014 
replace Address = ARC_Street if fileyear == 2014		// as compared to 2013. Keeping variable names of year 2013

replace OBJECTID = ID if fileyear == 2015				//These variable name are different in 2015 file as compared
replace OCCURRED_D = OCCURRED_DT if fileyear == 2015 	// to 2013 file. Keeping variable names of year 2013
replace OCCURRED_T = OCCURRED_TM if fileyear == 2015
replace CURRENT_BA = CURRENT_BADGE_NO if fileyear == 2015
replace OFF_INJURE = OFF_INJURED if fileyear == 2015
replace OffCondTyp = OffCondType if fileyear == 2015
replace OFF_HOSPIT = OFF_HOSPITAL if fileyear == 2015
replace SERVICE_TY = SERVICE_TYPE if fileyear == 2015
replace ForceEffec = ForceEffective if fileyear == 2015
replace CIT_INJURE = CIT_INJURED if fileyear == 2015
replace CitCondTyp = CitCondType if fileyear == 2015
replace CIT_ARREST = CIT_ARRESTED if fileyear == 2015
replace CIT_INFL_A = CIT_INFL_ASSMT if fileyear == 2015
replace CitChargeT = CitChargeType if fileyear == 2015
replace Address = ARC_Street if fileyear == 2015
replace CURRENT_BA = CURRENT_BAxx if fileyear == 2018
replace CouncilDistrict = DIST_NAME if CouncilDistrict == ""
drop ID OCCURRED_DT OCCURRED_TM CURRENT_BADGE_NO OFF_INJURED OffCondType OFF_HOSPITAL SERVICE_TYPE ForceEffective CIT_INJURED CitCondType CIT_ARRESTED CIT_INFL_ASSMT CitChargeType ARC_Street Latitude Longitude DIST_NAME CURRENT_BAxx
save "`temp_data'/DPD_force-public.dta", replace

* Cleaning and Encoding Categorical Variables 
encode OffSex, gen(Officer_Sex)
	label variable Officer_Sex "Gender of the Officer"
	drop OffSex

encode OffRace, gen(Officer_Race) 
	label variable Officer_Race "Race of the Officer" 
	drop OffRace

replace OFF_INJURE = "Yes" if OFF_INJURE == "true"
	replace OFF_INJURE = "No" if OFF_INJURE == "false"
	encode OFF_INJURE, gen(Officer_Injured) 
	label variable Officer_Injured "Did the officer injure?"
	drop OFF_INJURE

replace OFF_HOSPIT = "Yes" if OFF_HOSPIT == "true"
	replace OFF_HOSPIT = "No" if OFF_HOSPIT == "false"
	encode OFF_HOSPIT, gen(Officer_Hospital) 
	label variable Officer_Hospital "Did the officer get hospitalized?"
	drop OFF_HOSPIT
	
replace SERVICE_TY = "" if SERVICE_TY == "NULL" // Assuming Null to be missing 
	replace SERVICE_TY = "Other" if SERVICE_TY == "Other ( In Narrative)" // Others services are listed in the narrative 
	encode SERVICE_TY, gen(Service_Type)
	label variable Service_Type "Service Performed by the Officer" 
	drop SERVICE_TY
	
replace UOF_REASON = "" if UOF_REASON == "NULL" // Assuming Null to be missing 
	encode UOF_REASON, gen(Uof_Reason)
	label variable Uof_Reason "Use of Force - Reason" 
	drop UOF_REASON

replace CitRace = "" if CitRace == "NULL"	// Assuming Null to be missing 
	encode CitRace, gen(Citizen_Race) 		// There is an Unknown Category -> What to do with that?
	label variable Citizen_Race "Race of the Citizen" 
	drop CitRace

replace CitSex = "" if CitSex == "NULL"		// Assuming Null to be missing 
	encode CitSex, gen(Citizen_Sex) 		// There is an Unknown Category -> What to do with that?
	label variable Citizen_Sex "Gender of the Citizen" 
	drop CitSex

replace CIT_INJURE = "Yes" if CIT_INJURE == "true"
	replace CIT_INJURE = "No" if CIT_INJURE == "false"
	encode CIT_INJURE, gen(Citizen_Injured)
	label variable Citizen_Injured "Did Citizen get Injured?"
	drop CIT_INJURE
	
replace CIT_ARREST = "Yes" if CIT_ARREST == "true"
	replace CIT_ARREST = "No" if CIT_ARREST == "false"
	encode CIT_ARREST, gen(Citizen_Arrested)
	label variable Citizen_Arrested "Did Citizen get Arrested?"
	drop CIT_ARREST
	
replace CIT_INFL_A = "" if CIT_INFL_A == "NULL" // Assuming Null to be missing
	encode CIT_INFL_A, gen(Citizen_INFL_A) 			// What is CIT_INFL_A
	label variable Citizen_INFL_A "Citizen INFL_A"
	drop CIT_INFL_A									// Consider decreasing categories -> 
	
encode DIVISION, gen (Division)
	label variable Division "Division"				// Is there O/T Division?? 0.09 percent in the sample
	drop DIVISION

encode CouncilDistrict, gen(Council_District) 		// Available only for one year -> WHat is this -> What to do with the rest
	drop CouncilDistrict

save "`temp_data'/DPD_force-public.dta", replace

* Converting Continuous Variables into Numeric Variables

destring OBJECTID, gen(ObjectID) // WHat is Object ID here?
	drop OBJECTID
	
destring ZIP, gen(Zip_Code)  // This is only available for one year
	drop ZIP

destring CURRENT_BA, gen(Current_BA) // 
	drop CURRENT_BA

destring CitNum, gen(Citizen_Number) force // 292 Citizen Number either have "NULL" value or multiple number seperated by ",". -> What to do with it? 
	label variable Citizen_Number "Citizen ID" 
	
destring RA, gen (RA_Num) force // What is this? There are RA = O/T that is string -> What does this mean -> How to handle this? 
	label variable RA_Num "RA Number" 

destring (BEAT), gen(Beat_Num) force
	label variable Beat_Num "Beat Number" //There are Beat = O/T that is string -> What does this mean -> How to handle this?  

destring (SECTOR), gen(Sector_Num) force
	label variable Sector_Num "Sector Number" //There are Sector = O/T that is string -> What does this mean -> How to handle this?  

br RA RA_Num BEAT Beat_Num SECTOR Sector_Num if Sector_Num == . & SECTOR != ""

destring X, gen(X_Coordinates)
	destring Y, gen(Y_Coordinates)
	drop X Y
	label variable X_Coordinates "X Coordinates" // Half of the sampel does not have this 
	label variable Y_Coordinates "Y Coordinates" // Half of the sampel does not have this
	
save "`temp_data'/DPD_force-public.dta", replace


* Converting Data and Time Variables into Proper Format

replace OCCURRED_D = subinstr(OCCURRED_D," 12:00","",1)
	replace OCCURRED_D = subinstr(OCCURRED_D,":00 AM","",1)
	gen Occured_Date = date(OCCURRED_D,"MDY")
	label variable Occured_Date "Date of the Incident" 
	format Occured_Date %td 
	drop OCCURRED_D

replace HIRE_DT = subinstr(HIRE_DT," 12:00","",1)
	replace HIRE_DT = subinstr(HIRE_DT,":00 AM","",1)
	gen Hire_Date = date(HIRE_DT,"MDY")
	label variable Hire_Date "Date of Hiring of the Officer" 
	format Hire_Date %td 
	drop HIRE_DT
	
gen  Occurred_Time = Clock(OCCURRED_T,"hm")
	replace  Occurred_Time = Clock(OCCURRED_T,"hms") if Occurred_Time == .
	gen hour1 = Occurred_Time/(1000*60*60)
	gen hours = int(hour1)
	gen minutes1 = (hour1 - hours)*60 
	gen minutes = round(minutes)
	gen Date_Time_Incident = dhms(Occured_Date,hours,minutes,0)
	label variable Date_Time_Incident "Date and Time of the Incident" 
	format Date_Time_Incident %tc
	drop hour1 hours minutes minutes1 Occurred_Time OCCURRED_T
	
	
order fileyear ObjectID FILENUM UOFNum Occured_Date  Date_Time_Incident Current_BA Officer_Sex Officer_Race Hire_Date Officer_Injured Officer_Hospital Service_Type OffCondTyp ForceType ForceEffec Uof_Reason CitNum Citizen_Number CitCondTyp CitChargeT Citizen_Race Citizen_Sex Citizen_Injured Citizen_Arrested Citizen_INFL_A RA RA_Num BEAT Beat_Num SECTOR Sector_Num Division Council_District Address Zip_Code GeoLocation X_Coordinates Y_Coordinates STREET_N STREET street_g street_t  Zip_Code GeoLocation Match_addr TAAG_Name 

drop if FILENUM == ""

save "`stata_data'/DPD_force-public.dta", replace


* Questions and Tasks

// FileNum -> Correct syntax? 
// UOFNUM -> Multiple UFONUM -> What to do with it
// Officer Condition Type -> Decision
// Citizen Condition Type -> Decision
// Force Type -> Decision
// Cycles_Num -> What is this? How to clean this? 
// Force Effec -> Decision
// CitChargeT -> Decision
// What is TAAG_Name? 
// What is Match_Addr -> only for 2013 -> Seems like it comes from matching from ARC GIS
