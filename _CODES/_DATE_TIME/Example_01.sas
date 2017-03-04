/* EXAMPLE
    Type        : Date and time problems.
    Description : Using date and time functions to make tallies.
*/
DATA INTNX_FUNCTION;
  FORMAT X W Y Z YYMMDD10.;
  X = '28DEC2015'D;               /*Result:20151228                           */
  W = INTNX('MONTH', X, 0);       /*Result:20151201; default is the beginning.*/
  Y = INTNX('MONTH', X, 0, 'END');/*Result:20151231                           */
  Z = INTNX('MONTH', Y, 0, 'END');/*Result:20151231; same as 'Y'.             */
RUN;

/* Please refer to the following Web site in order to get more examples:
    http://www.sascommunity.org/wiki/INTCK_function_examples
*/
* N.B.: The INTCK function just returns the change in time units without
        considering the lenght of time between dates.  I found this is
        particularly useful to classify dates into time buckets. ;
DATA INTCK_FUNCTION;
  A = INTCK('MONTH','01JAN2009'D,'01JAN2009'D);/*Result: 0                    */
  B = INTCK('MONTH','01JAN2009'D,'31JAN2009'D);/*Result: 0                    */
  C = INTCK('MONTH','01JAN2009'D,'01FEB2009'D);/*Result: 1                    */
  D = INTCK('MONTH','31JAN2009'D,'01FEB2009'D);/*Result: 1                    */
  E = INTCK('MONTH','01JAN2009'D,'31DEC2008'D);/*Result:-1                    */
RUN;
