/****************************************************************************

    OnsetDetection.udo
    Original author: Joachim Heintz
    COSMO adaptation: Bernt Isak Wærstad

    See original version at https://github.com/csudo/csudo/blob/master/misc/OnDtct.csd

    Arguments: Db_Diff, Min_Time, Min_Db [, Delay, Rms_Freq] 
    Defaults: 0.5, 0.5, 0.5

    Db_Diff - dB difference to signify an offset (default = 12)
    Min_Time - minimum time in seconds between two onsets (default = 0.1)
    Min_Db - minimum dB to detect an offset (default = -45)
    Delay_Time - time in seconds which is compared to the current rms (default = 0.025)
    Rms_Freq - approximate frequency for rms measurements (default = 50)
 
    Description:
    Detects onsets (attacks). 
****************************************************************************/

	; Default argument values
	#define Db_Diff #0.5# 
	#define Min_Time #0.5#
	#define Min_Db #0.5#
	#define Delay_Time #0.025#
    #define Rms_Freq #50#

	; Toggle printing on/off
	#define PRINT #0#

	; Max and minimum values
	#define MAX_DB_DIFF #24#
	#define MIN_DB_DIFF #6#	
	#define MAX_TIME_TRESH #0.2#
	#define MIN_TIME_TRESH #0.05#
    #define MAX_DB_TRESH #-96#
	#define MIN_DB_TRESH #-12#	

;*********************************************************************
; OnsetDetection - 1 in / 1 out
;*********************************************************************

opcode OnsetDetection, k, akkkOo
    aIn, kDbDiff, kMinTim, kMinDb, kDelTim, iRmsFreq xin
 
    // Resolving defaults
    kDelTim = (kDelTim==0) ? $Delay_Time : kDelTim
    iRmsFreq = (iRmsFreq==0) ? $Rms_Freq : iRmsFreq
 
     ; ******************************
  	; Controller value scalings
  	; ******************************

	kDbDiff scale kDbDiff, $MAX_DB_DIFF, $MIN_DB_DIFF
    kDbDiff limit kDbDiff, $MIN_DB_DIFF, $MAX_DB_DIFF

	kMinTim scale kMinTim, $MAX_TIME_TRESH, $MIN_TIME_TRESH
    kMinTim limit kMinTim, $MIN_TIME_TRESH, $MAX_TIME_TRESH

	kMinDb scale kMinDb, $MAX_DB_TRESH, $MIN_DB_TRESH
    kMinDb limit kMinDb, $MIN_DB_TRESH, $MAX_DB_TRESH

	if $PRINT == 1 then
		Sdb_diff sprintfk "Db difference for onset: %d", kDbDiff
			puts Sdb_diff, kDbDiff + 1
		Smintime sprintfk "Minimum time between onsets: %fs", kMinTim
			puts Smintime, kMinTim + 1
		Smindb sprintfk "Offset threshold in dB: %d", kMinDb
			puts Smindb, kMinDb + 1
    endif

    kPrevDetect init 0.1
    iMaxDelTim init 0.5
    kOnset init 0
    kRms rms aIn,iRmsFreq
    kDb = dbamp(kRms)
    kDelRms vdelayk kDb, kDelTim, iMaxDelTim
 
    if (kDb>kDelRms+kDbDiff) && (kDb>kMinDb) && (kPrevDetect>kMinTim) then
        kOnset = 1
        kPrevDetect = 0
    else
        kOnset = 0
    endif
        kPrevDetect += 1/kr
 
    xout kOnset
endop

;*********************************************************************
; OnsetDetection - 2 in / 1 out
;*********************************************************************

opcode OnsetDetection, k, aakkkOo
    aInL, aInR, kDbDiff, kMinTim, kMinDb, kDelTim, iRmsFreq xin

    kOnset OnsetDetection (aInL+aInR)*0.5, kDbDiff, kMinTim, kMinDb, kDelTim, iRmsFreq

    xout kOnset
endop

;*********************************************************************
; OnsetDetection - 2 in / 2 out
;*********************************************************************

opcode OnsetDetection, kk, aakkkOo
    aInL, aInR, kDbDiff, kMinTim, kMinDb, kDelTim, iRmsFreq xin

    kOnsetL OnsetDetection aInL, kDbDiff, kMinTim, kMinDb, kDelTim, iRmsFreq
    kOnsetR OnsetDetection aInR, kDbDiff, kMinTim, kMinDb, kDelTim, iRmsFreq

    xout kOnsetL, kOnsetR
endop