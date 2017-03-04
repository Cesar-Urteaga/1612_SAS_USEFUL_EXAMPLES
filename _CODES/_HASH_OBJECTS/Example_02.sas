/* EXAMPLE
    Type        : Hash objects.
    Description : Using hash objects with multiple sets of data items per key
                  value so as to do an horizontal fuzzy match on dates.
*/
* We create a set of variables that define the observed period. ;
%LET _MGT_VARIABLES = /* Year 2016 */
                      VAR_20160131 VAR_20160229 VAR_20160331
                      VAR_20160430 VAR_20160531 VAR_20160630
                      VAR_20160731 VAR_20160831 VAR_20160930
                      VAR_20161031 VAR_20161130 VAR_20161231
                      /* Year 2017 */
                      VAR_20170131 VAR_20170228 VAR_20170331
                      VAR_20170430 VAR_20170531 VAR_20170630
                      VAR_20170731 VAR_20170831 VAR_20170930
                      VAR_20171031 VAR_20171130 VAR_20171231;
* We create the sample data. ;
DATA DATE_TABLE;
  FORMAT ID           $2.
         INITIAL_DATE
         FINAL_DATE   YYMMDD10.;
  INFILE DATALINES
         DSD DLM = ','
         MISSOVER;
  INPUT ID            $
        INITIAL_DATE  : YYMMDD8.
        FINAL_DATE    : YYMMDD8.;
  DATALINES;
01,20160102,20160130
01,20160412,20161016
01,20170115,20170527
01,20170329,20171112
03,20160714,20170224
04,20160221,20160503
04,20171123,20171201
05,20160118,20160128
05,20160129,20160306
;
/* N.B.: The last two intervals for ID 01 are overlapped, whereas the intervals
         for ID 05 do not overlap, but they occur in January. */
RUN;
PROC SORT DATA = DATE_TABLE; BY ID INITIAL_DATE FINAL_DATE; RUN;
DATA PIVOT_TABLE;
  FORMAT ID $2.;
  ARRAY VARIABLES[*] &_MGT_VARIABLES.;
  ID = "01"; OUTPUT;
  ID = "02"; OUTPUT;
  ID = "03"; OUTPUT;
  ID = "04"; OUTPUT;
  ID = "05"; OUTPUT;
RUN;
* We want to count the months reported in the DATE_TABLE for each ID and month
  in the PIVOT_TABLE using fuzzy match on dates (i.e., not exact). ;
DATA FUZZY_MATCH(DROP = _: INITIAL_DATE FINAL_DATE);
  IF _N_ = 1 THEN
    DO;
      IF 0 THEN SET DATE_TABLE;
      DECLARE HASH HASH_OBJECT;
      HASH_OBJECT = _NEW_ HASH(DATASET:   'DATE_TABLE',
                               ORDERED:   'YES',
                               MULTIDATA: 'YES');
      HASH_OBJECT.DEFINEKEY('ID');
      HASH_OBJECT.DEFINEDATA('INITIAL_DATE', 'FINAL_DATE');
      HASH_OBJECT.DEFINEDONE();
    END;
  CALL MISSING(INITIAL_DATE, FINAL_DATE);
  SET
      PIVOT_TABLE;
  ARRAY VARIABLES[*] &_MGT_VARIABLES.;
  DO _I = 1 TO HBOUND(VARIABLES);
    _DATE = INPUT(SUBSTR(VNAME(VARIABLES[_I]),
                         LENGTH(VNAME(VARIABLES[_I])) - 7),
                   YYMMDD8.);
    _ = HASH_OBJECT.FIND();
    DO UNTIL(_ ~= 0);
      IF INTNX('MONTH', INITIAL_DATE, 0) <= _DATE <=
         INTNX('MONTH', FINAL_DATE, 0, 'END') THEN
        VARIABLES[_I] + 1;
      _ = HASH_OBJECT.FIND_NEXT();
    END;
  END;
RUN;
