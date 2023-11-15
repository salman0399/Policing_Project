*******************Relevant Trainings - Short Term*******************
****************Last Updated: Nov 13, 2023***************

local stata_data "/Users/salman/Library/CloudStorage/OneDrive-ClaremontGraduateUniversity/Police Paper/Cleaned_Data"
local temp_data "/Users/salman/Library/CloudStorage/OneDrive-ClaremontGraduateUniversity/Police Paper/Temporary_Data"
local output "/Users/salman/Library/CloudStorage/OneDrive-ClaremontGraduateUniversity/Police Paper/Output"
set more off

***************Any Relevant Training***************
use "`stata_data'/Final_anyRT.dta", clear
gen Event_Time_1 =  int((arrived_date - earliest_course_date)/7)
gen Event_Time_2 =  int((arrived_date - second_course_date)/7)
gen Event_Time_3 =  int((arrived_date - third_course_date)/7)
gen Event_Time_4 =  int((arrived_date - fourth_course_date)/7)
gen Event_Time_5 =  int((arrived_date - fifth_course_date)/7)
gen Event_Time_6 =  int((arrived_date - sixth_course_date)/7)
gen Event_Time_7 =  int((arrived_date - seventh_course_date)/7)
gen training_date = .
replace training_date = earliest_course_date if (min(abs(Event_Time_1),abs(Event_Time_2),abs(Event_Time_3),abs(Event_Time_4),abs(Event_Time_5),abs(Event_Time_6),abs(Event_Time_7))) == abs(Event_Time_1) 
replace training_date = second_course_date if (min(abs(Event_Time_1),abs(Event_Time_2),abs(Event_Time_3),abs(Event_Time_4),abs(Event_Time_5),abs(Event_Time_6),abs(Event_Time_7))) == abs(Event_Time_2) 
replace training_date = third_course_date if (min(abs(Event_Time_1),abs(Event_Time_2),abs(Event_Time_3),abs(Event_Time_4),abs(Event_Time_5),abs(Event_Time_6),abs(Event_Time_7))) == abs(Event_Time_3) 
replace training_date = fourth_course_date if (min(abs(Event_Time_1),abs(Event_Time_2),abs(Event_Time_3),abs(Event_Time_4),abs(Event_Time_5),abs(Event_Time_6),abs(Event_Time_7))) == abs(Event_Time_4) 
replace training_date = fifth_course_date if (min(abs(Event_Time_1),abs(Event_Time_2),abs(Event_Time_3),abs(Event_Time_4),abs(Event_Time_5),abs(Event_Time_6),abs(Event_Time_7))) == abs(Event_Time_5) 
replace training_date = sixth_course_date if (min(abs(Event_Time_1),abs(Event_Time_2),abs(Event_Time_3),abs(Event_Time_4),abs(Event_Time_5),abs(Event_Time_6),abs(Event_Time_7))) == abs(Event_Time_6) 
replace training_date = seventh_course_date if (min(abs(Event_Time_1),abs(Event_Time_2),abs(Event_Time_3),abs(Event_Time_4),abs(Event_Time_5),abs(Event_Time_6),abs(Event_Time_7))) == abs(Event_Time_7) 
drop Event_Time*
drop earliest_course_date second_course_date third_course_date fourth_course_date fifth_course_date sixth_course_date seventh_course_date
label variable training_date "Closet Training Date"
gen Event_Time = int(arrived_date - training_date)/7
drop if Event_Time > 12
replace Event_Time = -13 if Event_Time < -12
replace Event_Time = -13 if Event_Time == .
gen week = Event_Time + 14
label define week 1"13 Weeks or before Training" 2"12 Weeks Before Training" 3"11 Weeks Before Training" 4"10 Weeks Before Training" 5"9 Weeks Before Training" 6"8 Weeks Before Training" 7"7 Weeks Before Training" 8"6 Weeks Before Training" 9"5 Weeks Before Training" 10"4 Weeks Before Training" 11"3 Weeks Before Training" 12"2 Weeks Before Training" 13"1 Week Before Training" 14"Week of the Training" 15"1 Week After Training" 16"2 Weeks After Training" 17"3 Weeks After Training"  18"4 Weeks After Training" 19"5 Weeks After Training" 20"6 Weeks After Training" 21"7 Weeks After Training" 22"8 Weeks After Training" 23"9 Weeks After Training" 24"10 Weeks After Training" 25"11 Weeks After Training" 26"12 Weeks After Training" 
label values week week
drop if week == 14

gen running_week_temp = ""
replace running_week_temp = "A" if week==2|week==3|week==4
replace running_week_temp = "B" if week==5|week==6|week==7
replace running_week_temp = "C" if week==8|week==9|week==10
replace running_week_temp = "D" if week==11|week==12|week==13
replace running_week_temp = "E" if week==15|week==16|week==17
replace running_week_temp = "F" if week==18|week==19|week==20
replace running_week_temp = "G" if week==21|week==22|week==23
replace running_week_temp = "H" if week==24|week==25|week==26

gen running_week = 0
replace running_week = 1 if running_week_temp=="A"
replace running_week = 2 if running_week_temp=="B"
replace running_week = 3 if running_week_temp=="C"
replace running_week = 4 if running_week_temp=="D"
replace running_week = 5 if running_week_temp=="E"
replace running_week = 6 if running_week_temp=="F"
replace running_week = 7 if running_week_temp=="G"
replace running_week = 8 if running_week_temp=="H"

xi: reg use_of_force_officer i.running_week 
label variable _Irunning_w_1 "10 - 12 Weeks Before" 
label variable _Irunning_w_2 "7 - 9 Weeks Before" 
label variable _Irunning_w_3 "4 - 6 Weeks Before" 
label variable _Irunning_w_4 "1 - 3 Weeks Before" 
label variable _Irunning_w_5 "1 - 3 Weeks After" 
label variable _Irunning_w_6 "4 - 6 Weeks After" 
label variable _Irunning_w_7 "7 - 9 Weeks After" 
label variable _Irunning_w_8 "10 - 12 Weeks After" 

gen week_num = wofd(arrived_date) - wofd(td(31dec2012))
gen dayofweek = dow(arrived_date)
gen year = year(arrived_date)
drop if year == 2013
drop if year == 2019

***************** Level Graphs *****************
reghdfe use_of_force_officer _Irunning_w_* [aweight = weight] , absorb(week_num dayofweek cfs_off_badge cfs_sector hour) cluster(cfs_off_badge)
coefplot, keep(_Irunning_w_*) xlabel(,labsize(tiny)) yline(0) vertical mfcolor(white) title(Effect of Relevant Trainings on Use of Force at Officers Level) note("With Officer, Week of the year, Day of the week, Time of the Day and Sector Fixed Effects") xline(4.5) xtitle(Weeks before/After Training) ytitle(Coefficient Size) 
graph export "`output'/12_week_anyRT_UOFO.png", replace

reghdfe use_of_force_inc _Irunning_w_* [aweight = weight] , absorb(week_num dayofweek cfs_off_badge cfs_sector hour) cluster(cfs_off_badge)
coefplot, keep(_Irunning_w_*) xlabel(,labsize(tiny)) yline(0) vertical mfcolor(white) title(Effect of Relevant Trainings on Use of Force Incidents) note("With Officer, Week of the year, Day of the week, Time of the Day and Sector Fixed Effects") xline(4.5) xtitle(Weeks before/After Training) ytitle(Coefficient Size) 
graph export "`output'/12_week_anyRT_UOFI.png", replace

reghdfe esc_words_onscene _Irunning_w_* [aweight = weight] , absorb(week_num dayofweek cfs_off_badge cfs_sector hour) cluster(cfs_off_badge)
coefplot, keep(_Irunning_w_*) xlabel(,labsize(tiny)) yline(0) vertical mfcolor(white) title(Effect of Relevant Trainings on Escalation Events) note("With Officer, Week of the year, Day of the week, Time of the Day and Sector Fixed Effects") xline(4.5) xtitle(Weeks before/After Training) ytitle(Coefficient Size) 
graph export "`output'/12_week_anyRT_ESCondcene.png", replace


reghdfe Arrest _Irunning_w_* [aweight = weight] , absorb(week_num dayofweek cfs_off_badge cfs_sector hour) cluster(cfs_off_badge)
coefplot, keep(_Irunning_w_*) xlabel(,labsize(tiny)) yline(0) vertical mfcolor(white) title(Effect of Relevant Trainings on Arrests) note("With Officer, Week of the year, Day of the week, Time of the Day and Sector Fixed Effects") xline(4.5) xtitle(Weeks before/After Training) ytitle(Coefficient Size) 
graph export "`output'/12_week_anyRT_Arrest.png", replace


***************** Proportion Graphs *****************

bysort cfs_off_badge arrived_date: gen  use_of_force_inc_p = (sum(use_of_force_inc)/_N)*100
bysort cfs_off_badge arrived_date: gen  use_of_force_officer_p = (sum(use_of_force_officer)/_N)*100
bysort cfs_off_badge arrived_date: gen  esc_words_onscene_p = (sum(esc_words_onscene)/_N)*100
bysort cfs_off_badge arrived_date: gen  Arrest_p = (sum(Arrest)/_N)*100

reghdfe use_of_force_officer_p _Irunning_w_* [aweight = weight] , absorb(week_num dayofweek cfs_off_badge cfs_sector hour) cluster(cfs_off_badge)
coefplot, keep(_Irunning_w_*) xlabel(,labsize(tiny)) yline(0) vertical mfcolor(white) title(Effect of Relevant Trainings on Daily Percentage of Use of Force by Officer, tstyle(size(small))) note("With Officer, Week of the year, Day of the week, Time of the Day and Sector Fixed Effects") xline(4.5) xtitle(Weeks before/After Training) ytitle(Coefficient Size)
graph export "`output'/12_week_anyRT_UOFO_p.png", replace

reghdfe use_of_force_inc_p _Irunning_w_* [aweight = weight] , absorb(week_num dayofweek cfs_off_badge cfs_sector hour) cluster(cfs_off_badge) 
coefplot, keep(_Irunning_w_*) xlabel(,labsize(tiny)) yline(0) vertical mfcolor(white) title(Effect of Relevant Trainings on Daily Percentage of Use of Force Incidence, tstyle(size(small))) note("With Officer, Week of the year, Day of the week, Time of the Day and Sector Fixed Effects") xline(4.5) xtitle(Weeks before/After Training) ytitle(Coefficient Size)
graph export "`output'/12_week_anyRT_UOFI_p.png", replace

reghdfe esc_words_onscene_p _Irunning_w_* [aweight = weight] , absorb(week_num dayofweek cfs_off_badge cfs_sector hour) cluster(cfs_off_badge)
coefplot, keep(_Irunning_w_*) xlabel(,labsize(tiny)) yline(0) vertical mfcolor(white) title(Effect of Relevant Trainings on Daily Percentage of Escalated Events, tstyle(size(small))) note("With Officer, Week of the year, Day of the week, Time of the Day and Sector Fixed Effects") xline(4.5) xtitle(Weeks before/After Training) ytitle(Coefficient Size)
graph export "`output'/12_week_anyRT_ESConcene_p.png", replace


reghdfe Arrest_p _Irunning_w_* [aweight = weight] , absorb(week_num dayofweek cfs_off_badge cfs_sector hour) cluster(cfs_off_badge)
coefplot, keep(_Irunning_w_*) xlabel(,labsize(tiny)) yline(0) vertical mfcolor(white) title(Effect of Relevant Trainings on Daily Percentage of Arrests, tstyle(size(small))) note("With Officer, Week of the year, Day of the week, Time of the Day and Sector Fixed Effects") xline(4.5) xtitle(Weeks before/After Training) ytitle(Coefficient Size)
graph export "`output'/12_week_anyRT_Arrest_p.png", replace

