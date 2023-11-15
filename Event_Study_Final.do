*******************Event Study Data*******************
****************Last Updated: Nov 12, 2023***************

local stata_data "/Users/salman/Library/CloudStorage/OneDrive-ClaremontGraduateUniversity/Police Paper/Cleaned_Data"
local temp_data "/Users/salman/Library/CloudStorage/OneDrive-ClaremontGraduateUniversity/Police Paper/Temporary_Data"
local output "/Users/salman/Library/CloudStorage/OneDrive-ClaremontGraduateUniversity/Police Paper/Output"
set more off

******************Relevant Trainings*******************

use "`stata_data'/DPD_Training_Clean_Badge.dta", clear
drop if cfs_off_badge == .
replace use_of_force_training = 1 if CourseT == "POLICEONE- DE-ESCALATION AND MINIMIZING USE OF FOR"
replace use_of_force_training = 1 if CourseT == "USE OF FORCE (INTERMEDIATE)"
replace use_of_force_training = 1 if CourseT == "USE OF FORCE (NON-INTERMEDIATE CORE COURSE)"
replace use_of_force_training = 1 if CourseT == "USE OF FORCE"
replace use_of_force_training = 1 if CourseT == "OSS - DE-ESCALATION OF FORCE"
replace use_of_force_training = 1 if CourseT == "POLICEONE- USE OF FORCE SITUATIONS"
replace use_of_force_training = 1 if CourseT == "USE OF FORCE IN A JAIL SETTING (INTERMEDIATE)"
replace use_of_force_training = 1 if CourseT == "USE OF FORCE IN CORRECTIONS (DE)"
replace use_of_force_training = 1 if CourseT == "LEXIPOL-DE-ESCALATION & REASONABLE USE OF FORCE"
replace use_of_force_training = 1 if CourseT == "LEXIPOL-USE OF FORCE"
replace use_of_force_training = 1 if CourseT == "OSS - USE OF FORCE AND DEADLY FORCE"
replace use_of_force_training = 1 if CourseT == "VATX USE OF FORCE AND LIABILITY ISSUES"
replace use_of_force_training = 1 if CourseT == "VATX USE OF FORCE"

replace Deescalation_training = 1 if CourseT == "POLICEONE- DE-ESCALATION AND MINIMIZING USE OF FOR"
replace Deescalation_training = 1 if CourseT == "DE-ESCALATION TECH (SB 1849)"
replace Deescalation_training = 1 if CourseT == "OSS - DE-ESCALATION OF FORCE"
replace Deescalation_training = 1 if CourseT == "LEXIPOL-DE-ESCALATION & REASONABLE USE OF FORCE"
replace Deescalation_training = 1 if CourseT == "MENTAL ILLNES-DE-ESCALATION TECHNIQUES MISSION"
replace Deescalation_training = 1 if CourseT == "OSS - NAPPI TOATAL VERBAL DEESCALATION"
replace Deescalation_training = 1 if CourseT == "VATX DE-ESCALATION VERBAL JUDO"

replace crisis_Intervention_training = 1 if CourseT == "CRISIS INTERVENTION"
replace crisis_Intervention_training = 1 if CourseT == "CRISIS INTERVENTION TRAINING"
replace crisis_Intervention_training = 1 if CourseT == "CRISIS INTERVENTION TRAINING 40HR"
replace crisis_Intervention_training = 1 if CourseT == "POLICEONE- CRISIS INTERVENTION TRAINING OVERVIEW"

gen any_relevant_training = 1 if (use_of_force_training == 1) | (Deescalation_training == 1) | (crisis_Intervention_training == 1)
keep if any_relevant_training == 1
label variable any_relevant_training "Either Use of Force, De-Escalation or Crisis Intervention Training"

******************Any Relevant Trainings Data*******************

preserve
bysort cfs_off_badge: egen earliest_course_date = min(Course_Date)
replace Course_Date = . if earliest_course_date == Course_Date
bysort cfs_off_badge: egen second_course_date = min(Course_Date)
replace Course_Date = . if second_course_date == Course_Date
bysort cfs_off_badge: egen third_course_date = min(Course_Date)
replace Course_Date = . if third_course_date == Course_Date
bysort cfs_off_badge: egen fourth_course_date = min(Course_Date)
replace Course_Date = . if fourth_course_date == Course_Date
bysort cfs_off_badge: egen fifth_course_date = min(Course_Date)
replace Course_Date = . if fifth_course_date == Course_Date
bysort cfs_off_badge: egen sixth_course_date = min(Course_Date)
replace Course_Date = . if sixth_course_date == Course_Date
bysort cfs_off_badge: egen seventh_course_date = min(Course_Date)
replace Course_Date = . if seventh_course_date == Course_Date

format earliest_course_date %td
format second_course_date %td
format third_course_date %td
format fourth_course_date %td
format fifth_course_date %td
format sixth_course_date %td
format seventh_course_date %td

label variable earliest_course_date "Earliest Data on which an officer took the training" 
label variable second_course_date "Date on which an officer took the second training" 
label variable third_course_date "Date on which an officer took the third training" 
label variable fourth_course_date "Date on which an officer took the fourth training" 
label variable fifth_course_date "Date on which an officer took the fifth training" 
label variable sixth_course_date "Date on which an officer took the sixth training" 
label variable seventh_course_date "Date on which an officer took the Seventh training" 

duplicates drop cfs_off_badge, force
keep cfs_off_badge service_start_date service_end_date Instructor Academy earliest_course_date second_course_date third_course_date fourth_course_date fifth_course_date sixth_course_date seventh_course_date any_relevant_training
save "`temp_data'/Relevant_Trainings.dta", replace
restore

******************Use of Force Trainings Data*******************

preserve
keep if use_of_force_training == 1
bysort cfs_off_badge: egen earliest_course_date = min(Course_Date)
replace Course_Date = . if earliest_course_date == Course_Date
bysort cfs_off_badge: egen second_course_date = min(Course_Date)
replace Course_Date = . if second_course_date == Course_Date
bysort cfs_off_badge: egen third_course_date = min(Course_Date)
replace Course_Date = . if third_course_date == Course_Date
bysort cfs_off_badge: egen fourth_course_date = min(Course_Date)
replace Course_Date = . if fourth_course_date == Course_Date
bysort cfs_off_badge: egen fifth_course_date = min(Course_Date)
replace Course_Date = . if fifth_course_date == Course_Date
bysort cfs_off_badge: egen sixth_course_date = min(Course_Date)
replace Course_Date = . if sixth_course_date == Course_Date

format earliest_course_date %td
format second_course_date %td
format third_course_date %td
format fourth_course_date %td
format fifth_course_date %td
format sixth_course_date %td

label variable earliest_course_date "Earliest Data on which an officer took the training" 
label variable second_course_date "Date on which an officer took the second training" 
label variable third_course_date "Date on which an officer took the third training" 
label variable fourth_course_date "Date on which an officer took the fourth training" 
label variable fifth_course_date "Date on which an officer took the fifth training" 
label variable sixth_course_date "Date on which an officer took the sixth training" 

duplicates drop cfs_off_badge, force
keep cfs_off_badge service_start_date service_end_date Instructor Academy earliest_course_date second_course_date third_course_date fourth_course_date fifth_course_date sixth_course_date use_of_force_training
save "`temp_data'/UOF_Trainings.dta", replace
restore

******************De-Escalation Trainings Data*******************

preserve
keep if Deescalation_training == 1
bysort cfs_off_badge: egen earliest_course_date = min(Course_Date)
replace Course_Date = . if earliest_course_date == Course_Date
bysort cfs_off_badge: egen second_course_date = min(Course_Date)
replace Course_Date = . if second_course_date == Course_Date
bysort cfs_off_badge: egen third_course_date = min(Course_Date)
replace Course_Date = . if third_course_date == Course_Date
bysort cfs_off_badge: egen fourth_course_date = min(Course_Date)
replace Course_Date = . if fourth_course_date == Course_Date

format earliest_course_date %td
format second_course_date %td
format third_course_date %td
format fourth_course_date %td

label variable earliest_course_date "Earliest Data on which an officer took the training" 
label variable second_course_date "Date on which an officer took the second training" 
label variable third_course_date "Date on which an officer took the third training" 
label variable fourth_course_date "Date on which an officer took the fourth training" 

duplicates drop cfs_off_badge, force
keep cfs_off_badge service_start_date service_end_date Instructor Academy earliest_course_date second_course_date third_course_date fourth_course_date Deescalation_training
save "`temp_data'/DESC_Trainings.dta", replace
restore

******************Crisis Intervention Trainings Data*******************

preserve
keep if crisis_Intervention_training == 1
bysort cfs_off_badge: egen earliest_course_date = min(Course_Date)
replace Course_Date = . if earliest_course_date == Course_Date
bysort cfs_off_badge: egen second_course_date = min(Course_Date)
replace Course_Date = . if second_course_date == Course_Date
bysort cfs_off_badge: egen third_course_date = min(Course_Date)
replace Course_Date = . if third_course_date == Course_Date

format earliest_course_date %td
format second_course_date %td
format third_course_date %td

label variable earliest_course_date "Earliest Data on which an officer took the training" 
label variable second_course_date "Date on which an officer took the second training" 
label variable third_course_date "Date on which an officer took the third training" 

duplicates drop cfs_off_badge, force
keep cfs_off_badge service_start_date service_end_date Instructor Academy earliest_course_date second_course_date third_course_date crisis_Intervention_training
save "`temp_data'/CI_Trainings.dta", replace
restore

******************Sample Creation*******************
use "`stata_data'/DPD_officer_personel.dta", clear
destring badge, gen(cfs_off_badge)
keep cfs_off_badge
save "`temp_data'/sample_officers.dta", replace

use "`stata_data'/DPD_calls_for_service.dta", clear
destring cfs_off_badge, replace force	
drop if cfs_off_badge == .
gen arrived_date = dofc(cfs_arrived_datetime)
format arrived_date %td
gen year = year(arrived_date)
drop if year < 2013
gen hour = hh(cfs_arrived_datetime)
drop if arrived_date == .
keep inc_id cse_id cfs_off_badge arrived_date hour cfs_sector cfs_division cfs_off_unit
label variable cse_id "Case ID"
label variable arrived_date "The day at which officer arrived or responded"
merge m:1 cfs_off_badge using "`temp_data'/sample_officers.dta"
keep if _merge == 3
drop _merge
label variable hour "Hour of the Day"
save "`temp_data'/sample_officers_calls.dta", replace

******************Incorporating Different Trainings Data into the Sample*******************

preserve
merge m:1 cfs_off_badge using "`temp_data'/Relevant_Trainings.dta"
drop if _merge == 2
replace any_relevant_training=0 if any_relevant_training==.
drop Instructor Academy _merge
save "`temp_data'/sample_anyRT.dta", replace
restore

preserve
merge m:1 cfs_off_badge using "`temp_data'/UOF_Trainings.dta"
drop if _merge == 2
drop Instructor Academy _merge
replace use_of_force_training=0 if use_of_force_training==.
save "`temp_data'/sample_UOFT.dta", replace
restore  

preserve 
merge m:1 cfs_off_badge using "`temp_data'/DESC_Trainings.dta"
drop if _merge == 2
drop Instructor Academy _merge
replace Deescalation_training=0 if Deescalation_training==.
save "`temp_data'/sample_DESCT.dta", replace
restore

preserve 
merge m:1 cfs_off_badge using "`temp_data'/CI_Trainings.dta"
drop if _merge == 2
drop Instructor Academy _merge
replace crisis_Intervention_training=0 if crisis_Intervention_training==.
save "`temp_data'/sample_CIT.dta", replace
restore

******************Incorporating Outcomes in Each Training Data*******************

use "`stata_data'/DPD_force-redacted.dta", clear
rename frc_off_badge cfs_off_badge
drop if cse_id == ""
drop if cfs_off_badge == .
duplicates drop cfs_off_badge cse_id, force
gen use_of_force_officer = 1
label variable use_of_force_officer "Use of Force Event"
keep cfs_off_badge cse_id use_of_force_officer 	

*******************Use of Force - Officer*******************

foreach x in anyRT UOFT DESCT CIT {
preserve
merge 1:m cfs_off_badge cse_id using "`temp_data'/sample_`x'.dta"
drop if _merge ==1
replace use_of_force_officer = 0 if use_of_force_officer == .
drop _merge
save "`stata_data'/Final_`x'", replace
restore
}

*******************Use of Force - Incident Level***************
use "`stata_data'/DPD_force-Final.dta", clear
keep inc_id
gen use_of_force_incident = 1
label variable use_of_force_incident "Use of Force Event at Incident Level"

foreach x in anyRT UOFT DESCT CIT {
preserve
merge 1:m inc_id using "`stata_data'/Final_`x'"
drop if _merge ==1
replace use_of_force_incident = 0 if use_of_force_incident == .
drop _merge
save "`stata_data'/Final_`x'", replace
restore
}

*******************Arrest***************
use "`stata_data'/DPD_Arrest_Charge.dta", clear
duplicates drop cse_id, force
drop if cse_id == ""
gen Arrest = 1
label variable Arrest "If Arrest has made or not"
keep cse_id Arrest

foreach x in anyRT UOFT DESCT CIT {
preserve
merge 1:m cse_id using "`stata_data'/Final_`x'"
drop if _merge ==1
replace Arrest = 0 if Arrest == .
drop _merge
save "`stata_data'/Final_`x'", replace
restore
}

******************Escalations***************
use "`stata_data'/force_text_count.dta", clear
drop if inc_id == ""
foreach x in anyRT UOFT DESCT CIT {
preserve
merge 1:m inc_id using "`stata_data'/Final_`x'"
keep if _merge ==3
replace esc_words_any = 0 if esc_words_any == .
replace esc_words_onscene = 0 if esc_words_onscene == .
drop _merge
bysort inc_id: gen max = _N
gen weight = 1/max
save "`stata_data'/Final_`x'", replace
restore
}

*************************Adding Relevant Training as Control*********************
foreach x in UOFT DESCT CIT {
use "`stata_data'/Final_`x'", clear
gen anyrelevanttraining = 0
save "`stata_data'/Final_`x'", replace
}

use "`temp_data'/UOF_Trainings.dta", clear
keep cfs_off_badge earliest_course_date second_course_date third_course_date fourth_course_date fifth_course_date sixth_course_date 
foreach x in earliest_course_date second_course_date third_course_date fourth_course_date fifth_course_date sixth_course_date  {
rename `x' any_`x'
}
foreach x in DESCT CIT {
preserve
merge 1:m cfs_off_badge using "`stata_data'/Final_`x'"
drop if _merge == 1

gen Event_Time_1 =  int((arrived_date - any_earliest_course_date)/7)
gen Event_Time_2 =  int((arrived_date - any_second_course_date)/7)
gen Event_Time_3 =  int((arrived_date - any_third_course_date)/7)
gen Event_Time_4 =  int((arrived_date - any_fourth_course_date)/7)
gen Event_Time_5 =  int((arrived_date - any_fifth_course_date)/7)
gen Event_Time_6 =  int((arrived_date - any_sixth_course_date)/7)

gen training_date = .
replace training_date = any_earliest_course_date if (min(abs(Event_Time_1),abs(Event_Time_2),abs(Event_Time_3),abs(Event_Time_4),abs(Event_Time_5),abs(Event_Time_6))) == abs(Event_Time_1) 
replace training_date = any_second_course_date if (min(abs(Event_Time_1),abs(Event_Time_2),abs(Event_Time_3),abs(Event_Time_4),abs(Event_Time_5),abs(Event_Time_6))) == abs(Event_Time_2) 
replace training_date = any_third_course_date if (min(abs(Event_Time_1),abs(Event_Time_2),abs(Event_Time_3),abs(Event_Time_4),abs(Event_Time_5),abs(Event_Time_6))) == abs(Event_Time_3) 
replace training_date = any_fourth_course_date if (min(abs(Event_Time_1),abs(Event_Time_2),abs(Event_Time_3),abs(Event_Time_4),abs(Event_Time_5),abs(Event_Time_6))) == abs(Event_Time_4) 
replace training_date = any_fifth_course_date if (min(abs(Event_Time_1),abs(Event_Time_2),abs(Event_Time_3),abs(Event_Time_4),abs(Event_Time_5),abs(Event_Time_6))) == abs(Event_Time_5) 
replace training_date = any_sixth_course_date if (min(abs(Event_Time_1),abs(Event_Time_2),abs(Event_Time_3),abs(Event_Time_4),abs(Event_Time_5),abs(Event_Time_6))) == abs(Event_Time_6) 

gen Event_Time = int(arrived_date - training_date)/7
replace anyrelevanttraining = 1 if (Event_Time < 13) & (Event_Time > -13)
drop any_earliest_course_date any_second_course_date any_third_course_date any_fourth_course_date any_fifth_course_date any_sixth_course_date Event_Time_* _merge training_date Event_Time
save "`stata_data'/Final_`x'", replace
restore
}

use "`temp_data'/DESC_Trainings.dta", clear
keep cfs_off_badge earliest_course_date second_course_date third_course_date fourth_course_date 
foreach x in earliest_course_date second_course_date third_course_date fourth_course_date  {
rename `x' any_`x'
}
foreach x in UOFT CIT {
preserve
merge 1:m cfs_off_badge using "`stata_data'/Final_`x'"
drop if _merge == 1

gen Event_Time_1 =  int((arrived_date - any_earliest_course_date)/7)
gen Event_Time_2 =  int((arrived_date - any_second_course_date)/7)
gen Event_Time_3 =  int((arrived_date - any_third_course_date)/7)
gen Event_Time_4 =  int((arrived_date - any_fourth_course_date)/7)

gen training_date = .
replace training_date = any_earliest_course_date if (min(abs(Event_Time_1),abs(Event_Time_2),abs(Event_Time_3),abs(Event_Time_4))) == abs(Event_Time_1) 
replace training_date = any_second_course_date if (min(abs(Event_Time_1),abs(Event_Time_2),abs(Event_Time_3),abs(Event_Time_4))) == abs(Event_Time_2) 
replace training_date = any_third_course_date if (min(abs(Event_Time_1),abs(Event_Time_2),abs(Event_Time_3),abs(Event_Time_4))) == abs(Event_Time_3) 
replace training_date = any_fourth_course_date if (min(abs(Event_Time_1),abs(Event_Time_2),abs(Event_Time_3),abs(Event_Time_4))) == abs(Event_Time_4) 

gen Event_Time = int(arrived_date - training_date)/7
replace anyrelevanttraining = 1 if (Event_Time < 13) & (Event_Time > -13)
drop any_earliest_course_date any_second_course_date any_third_course_date any_fourth_course_date Event_Time_* _merge training_date Event_Time
save "`stata_data'/Final_`x'", replace
restore
}

use "`temp_data'/CI_Trainings.dta", clear
keep cfs_off_badge earliest_course_date second_course_date third_course_date  
foreach x in earliest_course_date second_course_date third_course_date   {
rename `x' any_`x'
}
foreach x in UOFT DESCT {
preserve
merge 1:m cfs_off_badge using "`stata_data'/Final_`x'"
drop if _merge == 1

gen Event_Time_1 =  int((arrived_date - any_earliest_course_date)/7)
gen Event_Time_2 =  int((arrived_date - any_second_course_date)/7)
gen Event_Time_3 =  int((arrived_date - any_third_course_date)/7)

gen training_date = .
replace training_date = any_earliest_course_date if (min(abs(Event_Time_1),abs(Event_Time_2),abs(Event_Time_3))) == abs(Event_Time_1) 
replace training_date = any_second_course_date if (min(abs(Event_Time_1),abs(Event_Time_2),abs(Event_Time_3))) == abs(Event_Time_2) 
replace training_date = any_third_course_date if (min(abs(Event_Time_1),abs(Event_Time_2),abs(Event_Time_3))) == abs(Event_Time_3) 

gen Event_Time = int(arrived_date - training_date)/7
replace anyrelevanttraining = 1 if (Event_Time < 13) & (Event_Time > -13)
drop any_earliest_course_date any_second_course_date any_third_course_date  Event_Time_* _merge training_date Event_Time
save "`stata_data'/Final_`x'", replace
restore
}
