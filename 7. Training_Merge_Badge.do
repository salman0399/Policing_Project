**********Merging Training Data with Personnel File*********
*****************Last Updated: March 31, 2021***************
local raw_data "/Users/salman/Dropbox (DeAngelo Consulting)/DeAngelo Consulting Team Folder/Dallas Police CJL/1-raw_data"
local stata_data "/Users/salman/Dropbox (DeAngelo Consulting)/DeAngelo Consulting Team Folder/Dallas Police CJL/2-stata_data"
local temp_data "/Users/salman/Dropbox (DeAngelo Consulting)/DeAngelo Consulting Team Folder/Dallas Police CJL/2-stata_data/temp_files"


use "`temp_data'/Training_Clean.dta", clear
	keep off_full_name service_start_date service_end_date
	sort off_full_name service_start_date service_end_date
	duplicates drop off_full_name, force
	gen id = _n
	save "`temp_data'/training_unique_name.dta", replace

use "`stata_data'/DPD_officer_personel.dta", clear
	gen off_full_name = off_name_first + " " + off_name_mid  + " " +off_name_last  + " " + off_name_suffix
	label variable off_full_name "Full Name" 
	keep off_age cfs_off_badge off_full_name off_hire_date off_term_date
	destring cfs_off_badge, replace
	save "`temp_data'/personnel.dta", replace


merge 1:1 off_full_name using "`temp_data'/training_unique_name.dta"
	preserve 
	keep cfs_off_badge off_full_name id _merge
	keep if _merge == 3
	drop _merge
	save "`temp_data'/training_matched1.dta", replace
	restore

keep if _merge == 1 
	drop id service_end_date service_start_date _merge
	matchit cfs_off_badge off_full_name using "`temp_data'/training_unique_name.dta", idusing(id) txtusing(off_full_name) override
	merge m:1 off_full_name using "`temp_data'/personnel.dta"
	keep if _merge == 3
	rename off_full_name p_off_full_name
	rename off_full_name1 off_full_name
	drop _merge
	merge m:1 off_full_name using "`temp_data'/training_unique_name.dta"
	keep if _merge == 3
	rename off_full_name t_off_full_name
	drop _merge
	sort p_off_full_name similscore
	save "`temp_data'/unmatched.dta", replace
	keep if similscore > 0.9
	isid t_off_full_name
	rename t_off_full_name off_full_name
	keep off_full_name cfs_off_badge
	append using "`temp_data'/training_matched1.dta"
	drop if off_full_name == "JOSE A GUZMAN " & id != .
	drop if off_full_name == "REGINALD L JONES " & id != .
	save "`temp_data'/training_matched1.dta", replace
	
use "`temp_data'/unmatched.dta", clear
	merge m:1 cfs_off_badge using "`temp_data'/training_matched1.dta"
	keep if _merge == 1
	drop _merge off_full_name 
	keep if off_hire_date == service_start_date
	drop if similscore < 0.8
	isid t_off_full_name
	rename t_off_full_name off_full_name
	keep off_full_name cfs_off_badge
	append using "`temp_data'/training_matched1.dta"
	save "`temp_data'/training_matched1.dta", replace

use "`temp_data'/unmatched.dta", clear
	merge m:1 cfs_off_badge using "`temp_data'/training_matched1.dta"
	keep if _merge == 1
	drop _merge off_full_name 
	keep if  off_term_date ==  service_end_date
	keep if similscore > 0.8
	isid cfs_off_badge
	drop if service_end_date == .
	gen hiredifference = abs(off_hire_date - service_start_date)
	keep if hired <= 30
	rename t_off_full_name off_full_name
	keep off_full_name cfs_off_badge
	append using "`temp_data'/training_matched1.dta"
	save "`temp_data'/training_matched1.dta", replace

use "`temp_data'/unmatched.dta", clear
	merge m:1 cfs_off_badge using "`temp_data'/training_matched1.dta"
	keep if _merge == 1
	drop off_full_name _merge
	sort p_off_full_name  service_start_date service_end_date
	drop if cfs_off_badge == 2581 & id != 380
	drop if cfs_off_badge != 2581 & id == 380
	drop if cfs_off_badge == 7590 & id != 1
	drop if cfs_off_badge != 7590 & id == 1
	drop if cfs_off_badge == 7162 & id != 96
	drop if cfs_off_badge != 7162 & id == 96
	drop if cfs_off_badge == 5597 
	drop if cfs_off_badge == 6044 & id != 112
	drop if cfs_off_badge != 6044 & id == 112
	drop if cfs_off_badge == 10471 & id != 167
	drop if cfs_off_badge != 10471 & id == 167
	drop if cfs_off_badge == 8818 & id != 180
	drop if cfs_off_badge != 8818 & id == 180
	drop if cfs_off_badge == 8615 & id != 184
	drop if cfs_off_badge != 8615 & id == 184
	drop if cfs_off_badge == 8063 & id != 200
	drop if cfs_off_badge != 8063 & id == 200
	drop if cfs_off_badge == 9230 & id != 215
	drop if cfs_off_badge != 9230 & id == 215
	drop if cfs_off_badge == 9265 & id != 218
	drop if cfs_off_badge != 9265 & id == 218
	drop if cfs_off_badge == 4369 & id != 6011
	drop if cfs_off_badge != 4369 & id == 6011
	drop if cfs_off_badge == 10971 & id != 262
	drop if cfs_off_badge != 10971 & id == 262
	drop if cfs_off_badge == 10229 & id != 286
	drop if cfs_off_badge != 10229 & id == 286
	drop if cfs_off_badge == 7829 & id != 353
	drop if cfs_off_badge != 7829 & id == 353
	drop if cfs_off_badge == 10477 & id != 355
	drop if cfs_off_badge != 10477 & id == 355
	drop if cfs_off_badge == 10458 & id != 364
	drop if cfs_off_badge != 10458 & id == 364
	drop if cfs_off_badge == 10109 & id != 392
	drop if cfs_off_badge != 10109 & id == 392
	drop if cfs_off_badge == 10891 & id != 390
	drop if cfs_off_badge != 10891 & id == 390
	drop if cfs_off_badge == 10606 & id != 406
	drop if cfs_off_badge != 10606 & id == 406
	drop if cfs_off_badge == 10194 & id != 401
	drop if cfs_off_badge != 10194 & id == 401
	drop if cfs_off_badge == 5863 
	drop if cfs_off_badge == 4569 & id != 608
	drop if cfs_off_badge != 4569 & id == 608
	drop if cfs_off_badge == 5796 & id != 458
	drop if cfs_off_badge != 5796 & id == 458
	drop if cfs_off_badge == 9050 & id != 521
	drop if cfs_off_badge != 9050 & id == 521
	drop if cfs_off_badge == 6044 & id != 112
	drop if cfs_off_badge != 6044 & id == 112
	drop if cfs_off_badge == 6917
	drop if cfs_off_badge == 6838 & id != 532
	drop if cfs_off_badge != 6838 & id == 532
	drop if cfs_off_badge == 6044 & id != 112
	drop if cfs_off_badge != 6044 & id == 112
	drop if cfs_off_badge == 5503 & id != 535
	drop if cfs_off_badge != 5503 & id == 535
	drop if cfs_off_badge == 10857 & id != 594
	drop if cfs_off_badge != 10857 & id == 594
	drop if cfs_off_badge == 10754 & id != 697
	drop if cfs_off_badge != 10754 & id == 697
	drop if cfs_off_badge == 4638 & id != 1216
	drop if cfs_off_badge != 4638 & id == 1216
	drop if cfs_off_badge == 5569 & id != 905
	drop if cfs_off_badge != 5569 & id == 905
	drop if cfs_off_badge == 5390 & id != 1033
	drop if cfs_off_badge != 5390 & id == 1033
	drop if cfs_off_badge == 5084 & id != 1100
	drop if cfs_off_badge != 5084 & id == 1100
	drop if cfs_off_badge == 10711
	drop if cfs_off_badge == 8527 & id != 778
	drop if cfs_off_badge != 8527 & id == 778
	drop if cfs_off_badge == 8792 & id != 844
	drop if cfs_off_badge != 8792 & id == 844
	drop if cfs_off_badge == 5275 & id != 848
	drop if cfs_off_badge != 5275 & id == 848
	drop if cfs_off_badge == 9693 & id != 846
	drop if cfs_off_badge != 9693 & id == 846
	drop if cfs_off_badge == 7999 & id != 852
	drop if cfs_off_badge != 7999 & id == 852
	drop if cfs_off_badge == 7916 & id != 896
	drop if cfs_off_badge != 7916 & id == 896
	drop if cfs_off_badge == 8643
	drop if cfs_off_badge == 9619 & id != 756
	drop if cfs_off_badge != 9619 & id == 756
	drop if cfs_off_badge == 11180 & id != 952
	drop if cfs_off_badge != 11180 & id == 952
	drop if cfs_off_badge == 9523 & id != 957
	drop if cfs_off_badge != 9523 & id == 957
	drop if cfs_off_badge == 9359 & id != 1008
	drop if cfs_off_badge != 9359 & id == 1008
	drop if cfs_off_badge == 10035 & id != 1007
	drop if cfs_off_badge != 10035 & id == 1007
	drop if cfs_off_badge == 10511
	drop if cfs_off_badge == 10535 & id != 963
	drop if cfs_off_badge != 10535 & id == 963
	drop if cfs_off_badge == 10365 & id != 1200
	drop if cfs_off_badge != 10365 & id == 1200
	drop if cfs_off_badge == 6741 & id != 986
	drop if cfs_off_badge != 6741 & id == 986
	drop if cfs_off_badge == 7836 & id != 1358
	drop if cfs_off_badge != 7836 & id == 1358
	drop if cfs_off_badge == 5073 & id != 1425
	drop if cfs_off_badge != 5073 & id == 1425
	drop if cfs_off_badge == 8865 & id != 1426
	drop if cfs_off_badge != 8865 & id == 1426
	drop if cfs_off_badge == 10692 & id != 1413
	drop if cfs_off_badge != 10692 & id == 1413
	drop if cfs_off_badge == 7037 & id != 1551
	drop if cfs_off_badge != 7037 & id == 1551
	drop if cfs_off_badge == 8140 & id != 1593
	drop if cfs_off_badge != 8140 & id == 1593
	drop if cfs_off_badge == 10445 & id != 1606
	drop if cfs_off_badge != 10445 & id == 1606
	drop if cfs_off_badge == 10678 & id != 1611
	drop if cfs_off_badge != 10678 & id == 1611
	drop if cfs_off_badge == 5750 & id != 1665
	drop if cfs_off_badge != 5750 & id == 1665
	drop if cfs_off_badge == 8226 & id != 1958
	drop if cfs_off_badge != 8226 & id == 1958
	drop if cfs_off_badge == 4160 & id != 1833
	drop if cfs_off_badge != 4160 & id == 1833
	drop if cfs_off_badge == 6991 & id != 1936
	drop if cfs_off_badge != 6991 & id == 1936
	drop if cfs_off_badge == 5484
	drop if cfs_off_badge == 10338 & id != 1737
	drop if cfs_off_badge != 10338 & id == 1737
	drop if cfs_off_badge == 11153
	drop if cfs_off_badge == 8346 & id != 1761
	drop if cfs_off_badge != 8346 & id == 1761
	drop if cfs_off_badge == 6968
	drop if cfs_off_badge == 6685
	drop if cfs_off_badge == 9780 & id != 6023
	drop if cfs_off_badge != 9780 & id == 6023
	drop if cfs_off_badge == 7693 & id != 6031
	drop if cfs_off_badge != 7693 & id == 6031
	drop if cfs_off_badge == 10751 & id != 1935
	drop if cfs_off_badge != 10751 & id == 1935
	drop if cfs_off_badge == 8358
	drop if cfs_off_badge == 5028 & id != 2010
	drop if cfs_off_badge != 5028 & id == 2010
	drop if cfs_off_badge == 6703 & id != 2079
	drop if cfs_off_badge != 6703 & id == 2079
	drop if cfs_off_badge == 10894 & id != 2044
	drop if cfs_off_badge != 10894 & id == 2044
	drop if cfs_off_badge == 10844 & id != 2121
	drop if cfs_off_badge != 10844 & id == 2121
	drop if cfs_off_badge == 10361 & id != 2126
	drop if cfs_off_badge != 10361 & id == 2126
	drop if cfs_off_badge == 7441
	drop if cfs_off_badge == 8450
	drop if cfs_off_badge == 10246 & id != 6046
	drop if cfs_off_badge != 10246 & id == 6046
	drop if cfs_off_badge == 11026 & id != 6056
	drop if cfs_off_badge != 11026 & id == 6056
	drop if cfs_off_badge == 8566 & id != 6058
	drop if cfs_off_badge != 8566 & id == 6058
	drop if cfs_off_badge == 10484
	drop if cfs_off_badge == 9247
	drop if cfs_off_badge == 8638
	drop if cfs_off_badge == 10409 & id != 2321
	drop if cfs_off_badge != 10409 & id == 2321
	drop if cfs_off_badge == 5168 & id != 2829
	drop if cfs_off_badge != 5168 & id == 2829
	drop if cfs_off_badge == 8386 & id != 2376
	drop if cfs_off_badge != 8386 & id == 2376
	drop if cfs_off_badge == 11232 & id != 2386
	drop if cfs_off_badge != 11232 & id == 2386
	drop if cfs_off_badge == 10336 & id != 2532
	drop if cfs_off_badge != 10336 & id == 2532
	drop if cfs_off_badge == 7008
	drop if cfs_off_badge == 10627
	drop if cfs_off_badge == 8648
	drop if cfs_off_badge == 9193 & id != 2618
	drop if cfs_off_badge != 9193 & id == 2618
	drop if cfs_off_badge == 10604 & id != 2640
	drop if cfs_off_badge != 10604 & id == 2640
	drop if cfs_off_badge == 10378 & id != 2643
	drop if cfs_off_badge != 10378 & id == 2643
	drop if cfs_off_badge == 10729 & id != 2714
	drop if cfs_off_badge != 10729 & id == 2714
	drop if cfs_off_badge == 9023 & id != 2724
	drop if cfs_off_badge != 9023 & id == 2724
	drop if cfs_off_badge == 7777 & id != 2731
	drop if cfs_off_badge != 7777 & id == 2731
	drop if cfs_off_badge == 10945 & id != 2379
	drop if cfs_off_badge != 10945 & id == 2379
	drop if cfs_off_badge == 8665 & id != 2808
	drop if cfs_off_badge != 8665 & id == 2808
	drop if cfs_off_badge == 3585
	drop if cfs_off_badge == 8350
	drop if cfs_off_badge == 4294 & id != 2932
	drop if cfs_off_badge != 4294 & id == 2932
	drop if cfs_off_badge == 10533 & id != 2940
	drop if cfs_off_badge != 10533 & id == 2940
	drop if cfs_off_badge == 9445 & id != 2999
	drop if cfs_off_badge != 9445 & id == 2999
	drop if cfs_off_badge == 10681 & id != 2993
	drop if cfs_off_badge != 10681 & id == 2993
	drop if cfs_off_badge == 10030 & id != 3057
	drop if cfs_off_badge != 10030 & id == 3057
	drop if cfs_off_badge == 7609 & id != 3065
	drop if cfs_off_badge != 7609 & id == 3065
	drop if cfs_off_badge == 8862 & id != 3069
	drop if cfs_off_badge != 8862 & id == 3069
	drop if cfs_off_badge == 9398 & id != 3090
	drop if cfs_off_badge != 9398 & id == 3090
	drop if cfs_off_badge == 10591 & id != 3096
	drop if cfs_off_badge != 10591 & id == 3096
	drop if cfs_off_badge == 10797 & id != 2882
	drop if cfs_off_badge != 10797 & id == 2882
	drop if cfs_off_badge == 11036 & id != 3216
	drop if cfs_off_badge != 11036 & id == 3216
	drop if cfs_off_badge == 11087
	drop if cfs_off_badge == 7786
	drop if cfs_off_badge == 10280 & id != 3311
	drop if cfs_off_badge != 10280 & id == 3311
	drop if cfs_off_badge == 9069 & id != 3317
	drop if cfs_off_badge != 9069 & id == 3317
	drop if cfs_off_badge == 8759 & id != 3395
	drop if cfs_off_badge != 8759 & id == 3395
	drop if cfs_off_badge == 4792 & id != 3477
	drop if cfs_off_badge != 4792 & id == 3477
	drop if cfs_off_badge == 6846
	drop if cfs_off_badge == 6886 & id != 3551
	drop if cfs_off_badge != 6886 & id == 3551
	drop if cfs_off_badge == 7423 & id != 3560
	drop if cfs_off_badge != 7423 & id == 3560
	drop if cfs_off_badge == 10268 & id != 3569
	drop if cfs_off_badge != 10268 & id == 3569
	drop if cfs_off_badge == 9546 & id != 3590
	drop if cfs_off_badge != 9546 & id == 3590
	drop if cfs_off_badge == 10468 & id != 3602
	drop if cfs_off_badge != 10468 & id == 3602
	drop if cfs_off_badge == 6513 & id != 3603
	drop if cfs_off_badge != 6513 & id == 3603
	drop if cfs_off_badge == 5250 & id != 3604
	drop if cfs_off_badge != 5250 & id == 3604
	drop if cfs_off_badge == 6830 & id != 3705
	drop if cfs_off_badge != 6830 & id == 3705
	drop if cfs_off_badge == 9319 & id != 3666
	drop if cfs_off_badge != 9319 & id == 3666
	drop if cfs_off_badge == 8057 & id != 3668
	drop if cfs_off_badge != 8057 & id == 3668
	drop if cfs_off_badge == 9503 & id != 3679
	drop if cfs_off_badge != 9503 & id == 3679
	drop if cfs_off_badge == 10424 & id != 3682
	drop if cfs_off_badge != 10424 & id == 3682
	drop if cfs_off_badge == 10453 & id != 3683
	drop if cfs_off_badge != 10453 & id == 3683
	drop if cfs_off_badge == 10787 & id != 3801
	drop if cfs_off_badge != 10787 & id == 3801
	drop if cfs_off_badge == 5791 & id != 3804
	drop if cfs_off_badge != 5791 & id == 3804
	drop if cfs_off_badge == 11011 & id != 3809
	drop if cfs_off_badge != 11011 & id == 3809
	drop if cfs_off_badge == 11162
	drop if cfs_off_badge == 5201 & id != 4335
	drop if cfs_off_badge != 5201 & id == 4335
	drop if cfs_off_badge == 6990
	drop if cfs_off_badge == 10642
	drop if cfs_off_badge == 9671
	drop if cfs_off_badge == 6777 & id != 4357
	drop if cfs_off_badge != 6777 & id == 4357
	drop if cfs_off_badge == 10204 & id != 4401
	drop if cfs_off_badge != 10204 & id == 4401
	drop if cfs_off_badge == 10374
	drop if cfs_off_badge == 10928 & id != 4408
	drop if cfs_off_badge != 10928 & id == 4408
	drop if cfs_off_badge == 7167 & id != 4411
	drop if cfs_off_badge != 7167 & id == 4411
	drop if cfs_off_badge == 8629 & id != 4415
	drop if cfs_off_badge != 8629 & id == 4415
	drop if cfs_off_badge == 7694
	drop if cfs_off_badge == 8156 & id != 4426
	drop if cfs_off_badge != 8156 & id == 4426
	drop if cfs_off_badge == 8996 & id != 4428
	drop if cfs_off_badge != 8996 & id == 4428
	drop if cfs_off_badge == 7039 & id != 4509
	drop if cfs_off_badge != 7039 & id == 4509
	drop if cfs_off_badge == 6751 & id != 4634
	drop if cfs_off_badge != 6751 & id == 4634
	drop if cfs_off_badge == 8363 & id != 4554
	drop if cfs_off_badge != 8363 & id == 4554
	drop if cfs_off_badge == 7615 & id != 4602
	drop if cfs_off_badge != 7615 & id == 4602
	drop if cfs_off_badge == 5618
	drop if cfs_off_badge == 10756 & id != 4684
	drop if cfs_off_badge != 10756 & id == 4684
	drop if cfs_off_badge == 10463 & id != 4710
	drop if cfs_off_badge != 10463 & id == 4710
	drop if cfs_off_badge == 11022 & id != 4777
	drop if cfs_off_badge != 11022 & id == 4777
	drop if cfs_off_badge == 7806
	drop if cfs_off_badge == 10954 & id != 4869
	drop if cfs_off_badge != 10954 & id == 4869
	drop if cfs_off_badge == 11091 & id != 4879
	drop if cfs_off_badge != 11091 & id == 4879
	drop if cfs_off_badge == 11250 & id != 4969
	drop if cfs_off_badge != 11250 & id == 4969
	drop if cfs_off_badge == 5650 & id != 4957
	drop if cfs_off_badge != 5650 & id == 4957
	drop if cfs_off_badge == 10416 & id != 4977
	drop if cfs_off_badge != 10416 & id == 4977
	drop if cfs_off_badge == 9332 & id != 5217
	drop if cfs_off_badge != 9332 & id == 5217
	drop if cfs_off_badge == 10310 & id != 5224
	drop if cfs_off_badge != 10310 & id == 5224
	drop if cfs_off_badge == 4860 & id != 5584
	drop if cfs_off_badge != 4860 & id == 5584
	drop if cfs_off_badge == 11043 & id != 5308
	drop if cfs_off_badge != 11043 & id == 5308
	drop if cfs_off_badge == 8070 & id != 5400
	drop if cfs_off_badge != 8070 & id == 5400
	drop if cfs_off_badge == 8272 & id != 5417
	drop if cfs_off_badge != 8272 & id == 5417
	drop if cfs_off_badge == 8952 & id != 5426
	drop if cfs_off_badge != 8952 & id == 5426
	drop if cfs_off_badge == 8097 & id != 5440
	drop if cfs_off_badge != 8097 & id == 5440
	drop if cfs_off_badge == 5280 & id != 5456
	drop if cfs_off_badge != 5280 & id == 5456
	drop if cfs_off_badge == 7492 & id != 5499
	drop if cfs_off_badge != 7492 & id == 5499
	drop if cfs_off_badge == 10579
	drop if cfs_off_badge == 9658 & id != 5511
	drop if cfs_off_badge != 9658 & id == 5511
	drop if cfs_off_badge == 8355 & id != 5520
	drop if cfs_off_badge != 8355 & id == 5520
	drop if cfs_off_badge == 7469
	drop if cfs_off_badge == 9568 & id != 5549
	drop if cfs_off_badge != 9568 & id == 5549
	drop if cfs_off_badge == 9558 & id != 5620
	drop if cfs_off_badge != 9558 & id == 5620
	drop if cfs_off_badge == 7683 & id != 5663
	drop if cfs_off_badge != 7683 & id == 5663
	drop if cfs_off_badge == 7467
	drop if cfs_off_badge == 6985 & id != 5792
	drop if cfs_off_badge != 6985 & id == 5792
	drop if cfs_off_badge == 5595 & id != 5878
	drop if cfs_off_badge != 5595 & id == 5878
	drop if cfs_off_badge == 10827 & id != 5706
	drop if cfs_off_badge != 10827 & id == 5706
	drop if cfs_off_badge ==  7713 & id != 5735 
	drop if cfs_off_badge !=  7713 & id == 5735
	drop if cfs_off_badge ==  8395 & id != 5708 
	drop if cfs_off_badge !=  8395 & id == 5708
	drop if cfs_off_badge ==  10859 & id != 5786 
	drop if cfs_off_badge !=  10859 & id == 5786
	drop if cfs_off_badge ==  9149 & id != 5811 
	drop if cfs_off_badge !=  9149 & id == 5811
	drop if cfs_off_badge ==  6278 & id != 5932 
	drop if cfs_off_badge !=  6278 & id == 5932
	drop if cfs_off_badge ==  3850 & id != 6118 
	drop if cfs_off_badge !=  3850 & id == 6118
	drop if cfs_off_badge ==  7674 & id != 6101 
	drop if cfs_off_badge !=  7674 & id == 6101
	drop if cfs_off_badge ==  7716 & id != 6191 
	drop if cfs_off_badge !=  7716 & id == 6191
	drop if cfs_off_badge ==  10746 & id != 6157 
	drop if cfs_off_badge !=  10746 & id == 6157
	drop if cfs_off_badge ==  4510 & id != 6158 
	drop if cfs_off_badge !=  4510 & id == 6158
	drop if cfs_off_badge ==  8006 & id != 5813 
	drop if cfs_off_badge !=  8006 & id == 5813
	drop if cfs_off_badge ==  9449 & id != 6204 
	drop if cfs_off_badge !=  9449 & id == 6204
	drop if cfs_off_badge ==  10684 & id != 6212 
	drop if cfs_off_badge !=  10684 & id == 6212
	drop if cfs_off_badge ==  7041 & id != 6241 
	drop if cfs_off_badge !=  7041 & id == 6241
	rename t_off_full_name off_full_name
	keep off_full_name cfs_off_badge
	append using "`temp_data'/training_matched1.dta"
	duplicates drop off_full_name, force
	drop id
	save "`temp_data'/training_matched1.dta", replace
	
merge 1:m off_full_name using "`temp_data'/Training_Clean.dta"
	drop _merge 
	label variable off_full_name "Full Name of the Officer"
	label variable cfs_off_badge "Badge Number of the Officer"
	save "`stata_data'/DPD_Training_Clean_Badge.dta", replace
	
// Matching Result 
// Problemetic (Personnel files have 3877 record and Training File have 6243 unique names)
// Considering Personnel file as a master file to match with training file 
// 1:1 merge -> 3241 out of 3877
// 327 personel matched out of 636 merging for similarity index > 0.9 
// exactly equal hiredate and similarity index > 0.8 matched 102 out of 309 
// exactly equal enddate, hire date difference < 30 and similarity index > 0.8 matched 3 out of 207 
// 165/204 personnel manually matched
// 35 personnel still unmatched
// In the complete training file 481,886 out of 639,318 -> 75 percent matched 

