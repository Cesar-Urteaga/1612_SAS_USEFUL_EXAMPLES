/* EXAMPLE
    Type        : PROC FCMP functions.
    Description : Using the PROC FCMP procedure, we define a function which
                  indicates if two time intervals are overlapped.
*/
* We define the FCMP function in a package named DATES within the WORK.FUNCTIONS
  dataset. ;
PROC FCMP OUTLIB = WORK.FUNCTIONS.DATES;
  * The AreIntervalsOverlapped function check if two intervals are overlapped.
  * Returns:
             . : If some parameters are missing.
            -1 : If the input intervals are not well-defined.
             1 : If the intervals overlap.
             0 : If the intervals do not overlap. ;
  FUNCTION AreIntervalsOverlapped(FirstIntervalInitialDate,
                                  FirstIntervalFinalDate,
                                  SecondIntervalInitialDate,
                                  SecondIntervalFinalDate);
    SELECT;
      WHEN(MISSING(FirstIntervalInitialDate)  !
           MISSING(FirstIntervalFinalDate)    !
           MISSING(SecondIntervalInitialDate) !
           MISSING(SecondIntervalFinalDate))
        DO;
          PUT "WARNING: Some parameters are missing.";
          RETURN(.);
        END;
      WHEN(FirstIntervalInitialDate  > FirstIntervalFinalDate !
           SecondIntervalInitialDate > SecondIntervalFinalDate)
        DO;
          PUT "ERROR: The input intervals are not well-defined (check them).";
          RETURN(-1);
        END;
      WHEN(FirstIntervalInitialDate  <= SecondIntervalInitialDate <=
           FirstIntervalFinalDate)
        RETURN(1);
      WHEN(FirstIntervalInitialDate  <= SecondIntervalFinalDate   <=
           FirstIntervalFinalDate)
        RETURN(1);
      WHEN(SecondIntervalInitialDate < FirstIntervalInitialDate   &
           FirstIntervalFinalDate    < SecondIntervalFinalDate)
        RETURN(1);
      OTHERWISE
        RETURN(0);
    END;
  ENDSUB;
* We establish the dataset where SAS will look up the above function. ;
OPTIONS CMPLIB = WORK.FUNCTIONS;
* We want to know the overlapping type for each of the following examples using
  the PROC FCMP function that we have already defined. ;
DATA TEST_DATA;
  FORMAT FI_ID
         FI_FD
         SI_ID
         SI_FD YYMMDD10.;
  * Example 01: Missing parameters. ;
  FI_ID = .;
  FI_FD = "15NOV2017"D;
  SI_ID = "02FEB2017"D;
  SI_FD = "13DEC2017"D;
  TEST  = AreIntervalsOverlapped(FI_ID, FI_FD,
                                 SI_ID, SI_FD);
  OUTPUT;
  * Example 02: First interval is incorrect (i.e., an error). ;
  FI_ID = "01JAN2018"D;
  FI_FD = "15NOV2017"D;
  SI_ID = "02FEB2017"D;
  SI_FD = "13DEC2017"D;
  TEST  = AreIntervalsOverlapped(FI_ID, FI_FD,
                                 SI_ID, SI_FD);
  OUTPUT;
  * Example 03: First date of second interval overlaps with first interval. ;
  FI_ID = "01JAN2017"D;
  FI_FD = "15NOV2017"D;
  SI_ID = "02FEB2017"D;
  SI_FD = "13DEC2017"D;
  TEST  = AreIntervalsOverlapped(FI_ID, FI_FD,
                                 SI_ID, SI_FD);
  OUTPUT;
  * Example 04: Second date of second interval overlaps with first interval. ;
  FI_ID = "01MAR2017"D;
  FI_FD = "31DEC2017"D;
  SI_ID = "02FEB2017"D;
  SI_FD = "13DEC2017"D;
  TEST  = AreIntervalsOverlapped(FI_ID, FI_FD,
                                 SI_ID, SI_FD);
  OUTPUT;
  * Example 05: Second interval contains first interval. ;
  FI_ID = "01JAN2017"D;
  FI_FD = "15NOV2017"D;
  SI_ID = "02FEB2015"D;
  SI_FD = "13DEC2018"D;
  TEST  = AreIntervalsOverlapped(FI_ID, FI_FD,
                                 SI_ID, SI_FD);
  OUTPUT;
  * Example 06: No overlapping between first and second interval. ;
  FI_ID = "01JAN2017"D;
  FI_FD = "15NOV2017"D;
  SI_ID = "02FEB2018"D;
  SI_FD = "13DEC2019"D;
  TEST  = AreIntervalsOverlapped(FI_ID, FI_FD,
                                 SI_ID, SI_FD);
  OUTPUT;
RUN;
