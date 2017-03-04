/* EXAMPLE
    Type        : Hash objects.
    Description : Using hash objects to hierarchically update a pivot table.
*/
* We create the sample data. ;
DATA TABLE_01;
  ID = 1;
  X  = 1;
  Y  = "  ";
  OUTPUT;
  ID = 2;
  X  = .;
  Y  = "02";
  OUTPUT;
RUN;
DATA TABLE_02;
  ID = 1;
  X  = 100;
  Y  = "01";
  OUTPUT;
  ID = 2;
  X  = 2;
  Y  = "  ";
  OUTPUT;
  ID = 3;
  X  = 3;
  Y  = "03";
  OUTPUT;
  ID = 4;
  X  = 4;
  Y  = "  ";
  OUTPUT;
RUN;
DATA TABLE_03;
  ID = 5;
  X  = 5;
  Y  = "05";
  OUTPUT;
  ID = 6;
  X  = 6;
  Y  = "06";
  OUTPUT;
RUN;
DATA TABLE_04;
  ID = 7;
  X  = 7;
  Y  = "  ";
  OUTPUT;
  ID = 8;
  X  = 8;
  Y  = "08";
  OUTPUT;
RUN;
* We want to find hierarchically the values X and Y for each ID in the 'PIVOT'
  table. ;
DATA PIVOT;
  INPUT ID;
DATALINES;
1
4
2
3
7
8
6
5
;
RUN;
%LET _MGT_LIST_TABLES = TABLE_01 TABLE_02 TABLE_03 TABLE_04;
%MACRO MFindIDHierarchically(NumberOfTables);
  %DO J = 1 %TO &NumberOfTables.;
    %LET _MLT_TABLE = %SCAN(&_MGT_LIST_TABLES., &J.);
    DATA FINAL_TABLE(DROP = _ X Y);
      LENGTH _X       8.
             _Y       $2.
             _TABLE_X
             _TABLE_Y $30.;
      IF _N_ = 1 THEN
        DO;
          IF 0 THEN SET &_MLT_TABLE.(KEEP = ID X Y);
          DECLARE HASH HASHOBJECT(DATASET: "&_MLT_TABLE.(KEEP = ID X Y)");
          HASHOBJECT.DEFINEKEY('ID');
          HASHOBJECT.DEFINEDATA(ALL:'YES');
          HASHOBJECT.DEFINEDONE();
        END;
      * We initialize the variables since we use the SET statement.;
      CALL MISSING(X, Y);
      %IF &J. = 1 %THEN
        SET PIVOT;
      %ELSE
        SET FINAL_TABLE;
      ;
      _ = HASHOBJECT.FIND();
      _X = COALESCE(_X, X);
      _Y = COALESCEC(_Y, Y);
      IF ~MISSING(_X) THEN _TABLE_X = COALESCEC(_TABLE_X, "&_MLT_TABLE.");
      IF ~MISSING(_Y) THEN _TABLE_Y = COALESCEC(_TABLE_Y, "&_MLT_TABLE.");
    RUN;
  %END;
%MEND MFindIDHierarchically;
%MFindIDHierarchically(4);
