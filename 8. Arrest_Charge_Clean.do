*******************Cleaning Arrest at Charge Level*******************
*****************Last Updated: Mar 09, 2021****************
local raw_data "/Users/salman/Dropbox (DeAngelo Consulting)/DeAngelo Consulting Team Folder/Dallas Police CJL/1-raw_data"
local stata_data "/Users/salman/Dropbox (DeAngelo Consulting)/DeAngelo Consulting Team Folder/Dallas Police CJL/2-stata_data"
local temp_data "/Users/salman/Dropbox (DeAngelo Consulting)/DeAngelo Consulting Team Folder/Dallas Police CJL/2-stata_data/temp_files"
set more off

***** Importing Police_Arrest_Charges_7_19_19.csv *******
import delimited "/Users/salman/Dropbox (DeAngelo Consulting)/DeAngelo Consulting Team Folder/Dallas Police CJL/1-raw_data/DPD_Arrest/Police_Arrest_Charges_7_19_19.csv", encoding(ISO-8859-1) clear


***** Cleaning all the dates and time variables ******* 

gen arrestdate2 = clock(arrestdate, "MDYhms")
	format arrestdate2 %tc
	drop arrestdate
	rename arrestdate2 arrestdate
	label variable arrestdate "Arrest Date and Time"

gen arbkdate2 = subinstr(arbkdate," +0000","",1)
	gen arbkdate3 = clock(arbkdate2, "MDYhms")
	format arbkdate3 %tc
	drop arbkdate arbkdate2
	rename arbkdate3 arbkdate
	label variable arbkdate "arbk Date and Time"
	
gen warrantissueddate2 = clock(warrantissueddate, "MDYhms")
	drop warrantissueddate
	ren warrantissueddate2 warrantissueddate
	label variable warrantissueddate "Warrent Issued Date and Time"
	format warrantissueddate %tc
	
gen changedate2 = clock(changedate, "MDYhms")
	drop changedate
	ren changedate2 changedate
	format changedate %tc
	label variable changedate "Changed Date and Time" 

gen Report_Write_Date = clock(ofcr_rpt_written_by_date, "MDYhms")
	format Report_Write_Date %tc
	label variable Report_Write_Date "Date and Time when the report was written"
	drop ofcr_rpt_written_by_date
	
gen Approved_Date2 = subinstr(ofcr_approved_by_date," +0000","",1)
	gen Approved_Date = clock(Approved_Date2, "MDYhms")
	format Approved_Date %tc
	label variable Approved_Date "Officer Approved Date and Time"
	drop Approved_Date2 ofcr_approved_by_date
	
gen Recieved_Date2 = subinstr(ofcr_received_by_date," +0000","",1)
	gen Recieved_Date = clock(Recieved_Date2, "MDYhms")
	format Recieved_Date %tc
	label variable Recieved_Date "Officer Received Date and Time"
	drop Recieved_Date2 ofcr_received_by_date
	
gen Apprehended_Date =  clock(apprehended_date, "MDYhms")
	format Apprehended_Date %tc
	label variable Apprehended_Date "Apprehended Date and Time"
	drop apprehended_date
	
gen Final_Display_Date = subinstr(final_disp_date," 00:00:00.0000000","",1)
	gen Final_Display_Date2 = date(Final_Display_Date,"YMD")
	drop Final_Display_Date final_disp_date
	ren Final_Display_Date2 Final_Display_Date
	label variable Final_Display_Date "Final Display Date" 	
	format Final_Display_Date %td

gen upzdate2 = clock(upzdate,"MDYhms")
	drop upzdate
	ren upzdate2 upzdate
	format upzdate %tc
	label variable upzdate "upz date and time" 
	
***** Cleaning all the categorical variables ******* 

gen arrestday1 = .	
	local j = 1
	foreach x in "Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday" "Sunday" {	
		replace arrestday1 = `j' if arrestday == "`x'" 
		local j = `j' + 1
		}
	label define day 1"Monday" 2"Tuesday" 3"Wednesday" 4"Thursday" 5"Friday" 6"Saturday" 7"Sunday"
	label values arrestday1 day
	drop arrestday
	ren arrestday1 arrestday
	
gen arbkday1 = .	
	local j = 1
	foreach x in "Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday" "Sunday" {	
		replace arbkday1 = `j' if arbkday == "`x'" 
		local j = `j' + 1
		}
	label values arbkday1 day
	drop arbkday
	ren arbkday1 arbkday
	label variable arbkday "Day of the arbk"
	
replace chargeflag = "County" if chargeflag == "'County"
	encode chargeflag, gen(chargeflag1)
	drop chargeflag
	ren chargeflag1 chargeflag
	
encode severity, gen(severity1)
	drop severity 
	rename severity1 severity

encode pclass, gen(pclass1)
	drop pclass
	ren pclass1 pclass
	label variable pclass "PCLASS"

	
replace bailorigamt = subinstr(bailorigamt,"$","",1)
	destring bailorigamt, gen(bail_amount)
	drop bailorigamt
	label variable bail_amount "Bail Amount in Dollars"

encode warranttype, gen(warrant_type)
	drop warranttype 
	label variable warrant_type "Warrant Type" 
	
encode final_disp, gen(finaldisp)
	drop final_disp
	label variable finaldisp "Final Disp"

replace nibrs_type = "Not Coded" if nibrs_type == "No Coded"
	encode nibrs_type, gen(nibrstype) 
	drop nibrs_type

***** Cleaning Incident Number ******* 
rename ïincidentnum  cse_id
	label variable cse_id "Incident Number" 

split cse_id, parse("-")
	drop cse_id3
	replace cse_id2 = "2014" if cse_id2 == "204" | cse_id2 == "2104" | cse_id2 == "2012"
	replace cse_id2 = "2015" if cse_id2 == "2105"
	replace cse_id2 = "2016" if cse_id2 == "2106" | cse_id2 == "2916" | cse_id2 == "1016"
	replace cse_id2 = "2019" if cse_id2 == "2109"
	destring cse_id1, replace force
	tostring cse_id1, replace force
	replace cse_id1="" if cse_id1=="."
	replace cse_id = "" if cse_id1 ==""
	replace cse_id=cse_id1+"-"+cse_id2 if cse_id1!=""
	drop cse_id1 cse_id2
order cse_id arrestyr arrestnumber archgnumid archargect arrestdate arbkdate arrestday arbkday offensecode chargeflag chargedesc ucrarrestchg ucr ucrword ucroffense finaldisp pclass severity ucr_archg cjis type holdtype bail_amount releasetype warrantnum warrantissueddate changedate Report_Write_Date Approved_Date Recieved_Date Apprehended_Date Final_Display_Date upzdate warrantissuedagency warrant_type jailsgtid arlpremise araction dispcode nibrs_group nibrs_crime_category nibrs_crime nibrs_code nibrs_crimeagainst chargesynopsis

save "`temp_data'/Arrest_Charge.dta", replace


	
***** Question ******* 
// What are these variables -> Archargect, offensecode, pclass, ucr
// Do we need warrent Issued Agency 
// archgnumid uniquely define this data set
	
	
