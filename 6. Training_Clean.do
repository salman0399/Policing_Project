*******************Cleaning Training Data*******************
*****************Last Updated: March 16, 2021***************
local raw_data "/Users/salman/Dropbox (DeAngelo Consulting)/DeAngelo Consulting Team Folder/Dallas Police CJL/1-raw_data"
local stata_data "/Users/salman/Dropbox (DeAngelo Consulting)/DeAngelo Consulting Team Folder/Dallas Police CJL/2-stata_data"
local temp_data "/Users/salman/Dropbox (DeAngelo Consulting)/DeAngelo Consulting Team Folder/Dallas Police CJL/2-stata_data/temp_files"
local dofiles "/Users/salman/Dropbox (DeAngelo Consulting)/DeAngelo Consulting Team Folder/Dallas Police CJL/0-programs"

capture program drop clean

program define clean
	capture dropmiss, obs force
	foreach var of varlist *{
		capture replace `var'=upper(`var')
		capture replace `var'=trim(`var')
		capture replace `var'=strtrim(`var')
	}
end

** Improting File 
import excel "`raw_data'/Training_Data/Training_Records_from_Dallas-PD.xlsx", firstrow allstring clear

clean

drop if FirstName == "00:00:00.000"

ren FirstName off_name_first 
	ren MiddleInitial off_name_mid 
	ren LastName off_name_last 
	ren Suffix off_name_suffix
	gen off_full_name = off_name_first + " " + off_name_mid  + " " +off_name_last  + " " + off_name_suffix
	label variable off_full_name "Full Name" 

gen service_start_date = date(ServiceStartDate,"MDY")
	format service_start_date %td
	drop ServiceStartDate
	label variable service_start_date "Service Start Date"
	
replace ServiceEndDate = "" if ServiceEndDate == "NULL"
	gen service_end_date = date(ServiceEndDate,"MDY")
	format service_end_date %td
	drop ServiceEndDate
	label variable service_end_date "Service End Date"
	
replace CourseDate = "" if CourseDate == "NULL"
	gen Course_Date = date(CourseDate, "MDY")
	format Course_Date %td
	drop CourseDate
	label variable Course_Date "Course Date"
	
replace Academy = "" if Academy == "NULL"

replace CourseID = "" if CourseID == "NULL"
	destring CourseID, gen(Course_ID) 
	drop CourseID
	label variable Course_ID "Course ID" 
	
replace CourseTitle = "" if CourseTitle == "NULL"

replace Instructor = "" if Instructor == "NULL"

replace CourseHours = "" if CourseHours == "NULL"
	destring CourseHours, gen(Course_Hours) 
	drop CourseHours
	label variable Course_Hours "Course Hours" 
	
drop if Course_ID==. & CourseTitle == ""

order off_full_name off_name_first off_name_mid off_name_last off_name_suffix service_start_date service_end_date Course_ID CourseTitle Course_Hours Course_Date Instructor Academy

save "`temp_data'/Training_Clean.dta", replace

************* Categorizing Deesclation, Crisis Intervention & Use of Force Training *************

gen Deescalation_training = (Course_ID == 1849)

gen crisis_Intervention_training = (Course_ID == 1850)

gen use_of_force_training = (Course_ID == 2107)

gen Deescalation_training_add = 1 if Course_ID == 1849

gen crisis_Intervention_training_add = 1 if Course_ID == 1850

gen use_of_force_training_add = 1 if Course_ID == 2107

***********Identifying Deesclation Trainings************
foreach x in "Defensive Tactics" "Effective Commun. in Crisis or Conflict Situations" "PoliceOne- De-escalation and Minimizing Use of For" "OSS - De-Escalation of Force" {
	replace Deescalation_training_add = 1 if CourseTitle == "`x'" 
	}
	replace Deescalation_training_add = 0 if Deescalation_training_add == . & CourseTitle != ""
***********Identifying Crisis Intervention Trainings************
foreach x in "Crisis Intervention Training" "Crisis Training/Peer support" "PoliceOne- Crisis Intervention Training Overview" "Emergency Management for People with Disabilities" "Conflict Resolution" "OSS - Civil  Disturbance & Riot Control" "Crisis Negotiation" "AWR-148-W Crisis Management School based" "Crisis Intervention" "OSS - Negotiator Tactics" "Youth Crisis Intervention" {
	replace crisis_Intervention_training_add = 1 if CourseTitle == "`x'" 
	}
	replace crisis_Intervention_training_add = 0 if crisis_Intervention_training_add == . & CourseTitle != ""

***********Identifying Use of Force Trainings************
foreach x in "Use of Force (Non-Intermediate Core Course)" "Use of Force in Corrections (DE)" "PoliceOne- Use of Force Situations" "Use of Force - Response Network" "Use of Force in a Jail Setting (Intermediate)" "PoliceOne- Dealing with Armed Suspects" "OSS - Use of Force and Deadly Force" "Use of Force" "VATX Use of Force and Liability Issues" "VATX Use of Force " "LET641 TEEX Legal Issues for Use of Force Inst" "PoliceOne- Use Of Force in Corrections" "PoliceOne- Use of Less Lethal Force" {
	replace use_of_force_training_add = 1 if CourseTitle == "`x'" 
	}
	replace use_of_force_training_add = 0 if use_of_force_training_add == . & CourseTitle != ""

foreach x in Deescalation_training crisis_Intervention_training use_of_force_training {
	label variable `x' "`x' Courses"
	label variable `x'_add "Additional `x' Courses"
	}
save "`temp_data'/Training_Clean.dta", replace


// "Less Lethal Electronic Control Device Training " 
// "Officer Survival/Weapon Retent" 
// "Firearms" 
// "Less Lethal Impact Weapons Training (Bean Bag/Impa" 
// "OSS - Basic Firearms Safety" 
//  https://www.tcole.texas.gov/content/course-curriculum-materials-and-updates-0 
//  https://www.tcole.texas.gov/content/specific-course-reporting-numbers
