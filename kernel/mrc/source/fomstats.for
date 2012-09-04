C 
C  Written by Richard Henderson, with additions from Vinzenz Unger
C
C  FOMSTAT :  READS IN OUTPUT FROM AVRGAMPHS AND DOES
C             (1) CALCULATION OF PHASE ERRORS IN A SPECIFIED
C                 NUMBER OF RESOLUTION BANDS.
C                 IF TWOFOLD SYMMETRY CONSTRAINS PHASES, THE
C                 PHASE ERRORS ARE CALCUALTED VS 0/180 DEG.
C                 IF NO TWOFOLD SYMMETRY CAN BE USED TO FIGURE THE
C                 ABSOLUTE PHASE ERRORS THE BEST ONE CAN DO IS TO
C                 ASSUME THAT THE AVERAGED PHASES ARE THE TRUE
C                 PHASES AND TO CALCULATE THE MEAN OF THE AVERAGING ERROR
C                 FOR ALL REFLECTIONS IN SAME RESOLUTION BAND
C
C             (2) IF TWOFOLD SYMMETRY IMPOSES PHASE CONSTRAINTS
C                 THE FOM'S OBTAINED BY AVRGAMPHS ARE ADJUSTED
C                 FOR DEVIATION OF AVERGE PHASE FROM THEORETICAL
C                 CENTROSYMMETRIC VALUE (0/180 DEG) AND A NEW SPOTLIST
C                 IS WRITTEN OUT IN WHICH THE PHASES HAVE BEEN SET TO
C                 THE CLOSER CENTROSYMMETRIC VALUE
C
C             (3) LOGICALS FOR POSSIBLE TWOFOLD SCREW-AXES ALONG A AND B
C                 CONTROL THAT "ABSENT" REFLECTIONS ARE NOT PASSED ON
C                 TO PHASE ERROR CALCULATION AND OUTPUTFILE.
C************************************************************************************
C  INPUT PARAMETERS
C      CARD 1    ISER
C      CARD 2    CUTOFF (T/F)
C      CARD 3    IMIN IMAX
C      CARD 4    A,B,GAMMA
C      CARD 5    TWOFOLD(T/F),IHSCR(T/F),IKSCR(T/F)
C      CARD 6    RESOL,IBAND
C
C         ISER    - SERIAL NUMBER AT HEAD OF OUTPUT FILE.
C
C         CUTOFF  - LOGICAL (T OR F)
C                   IF=T REFLECTIONS WITH PHASE VALUES BETWEEN
C                        "IMIN/IMAX" ARE REJECTED IF "TWOFOLD=T".
C                   IF=F NO SPOTS ARE REJECTED BASED ON THEIR PHASE
C                        VALUES; I.E. ALL DATA PASSED ON.
C                        ANY "IMIN/IMAX" VALUES GIVEN ON NEXT CARD ARE
C                        IGNORED
C         IMIN    - LOWER CUTOFF LIMIT FOR CONSTRAINING PHASES;
C                   |PHASES|<IMIN WILL BE SET TO 0 DEG IF "TWOFOLD=T"
C         IMAX    - UPPER CUTOFF LIMIT FOR CONSTRAINING PHASES;
C                   |PHASES|>IMAX WILL BE SET TO 180 DEG IF "TWOFOLD=T"
C     A,B,GAMMA   - REAL SPACE UNIT CELL DIMENSIONS
C       TWOFOLD   - LOGICAL (T OR F)
C                   IF=T CALCULATES PHASE ERROR VS 0/180 DEG, ADJUSTS THE
C                        FOM'S FROM PROGRAM "AVRGAMPHS" FOR DEVIATION OF
C                        PHASE FROM 0/180 DEG AND WRITES A NEW SPOT LIST
C                        WITH THE ADJUSTED FOM'S AND ALL PHASES BEING SET
C                        TO CLOSER OF 0/180 VALUE.
C                        REFLECTIONS WITH PHASES BETWEEN "IMIN/IMAX" ARE
C                        IGNORED FOR CALCULATION OF PHASE ERROR AND
C                        ARE ALSO NOT PASSED ON TO NEW SPOTLIST.
C                   IF=F "PHASE ERRORS" ARE THE MEAN OF THE ERRORS FROM
C                        DATA AVERAGING. NO CUTOFFS ARE ALOWED IN THIS CASE
C                        BECAUSE THERE ARE NOT PHASE CONSTRAINTS. ACCORDINGLY,
C                        ONLY MEAN AND OVERALL ERROR ARE WRITTEN OUT.
C         IHSCR   - LOGICAL (T OR F)
C                   IF=T ODD (H,0,0) ARE IGNORED FOR CALCULATION OF
C                        PHASE ERROR AND FOR NEW SPOT LIST IF REQUESTED
C         IKSCR   - LOGICAL (T OR F)
C                   IF=T ODD (0,K,0) ARE IGNORED FOR CALCULATION OF
C                        PHASE ERROR AND FOR NEW SPOT LIST IF REQUESTED
C         RESOL   - RESOLUTION CUTOFF FOR CALCULATIONS
C         IBAND   - NUMBER OF RESOLUTION BANDS USED FOR BINNING REFLECTIONS
C
C   INPUT  DATASTREAM  'IN'
C   OUTPUT DATASTREAM  'OUT' UNIT3: new spot list
C   OUTPUT DATASTREAM  'OUT2' UNIT4: LIST OF AVERAGE PHASE ERRORS FOR REFLECTIONS
C                                    BINNED IN RQUESTED NUMBER OF RESOLUTION BANDS
C*********************************************************************************
C
       PROGRAM FOMSTAT
       LOGICAL*1 CUTOFFS,TWOFOLD,IHSCR,IKSCR
C      PARAMETER NMAX=300,NSLOTS=200   does not show all refl. 6.11.02 JV
       PARAMETER (NMAX=1000)
       PARAMETER (NSLOTS=1000)
       DIMENSION IH(NMAX),IK(NMAX),IL(NMAX),AIN(NMAX),PIN(NMAX)
       DIMENSION FOM(NMAX),NSPOTDAT(NSLOTS)
       DIMENSION avrgfom(nslots),PHASERR(NSLOTS)
       DIMENSION TITLE(15),TITLEIN(15)
C
C
       WRITE(6,1)
1      FORMAT(/'  FOMSTATS V1.00 6/17/97   VMU'//)
C
       READ(5,99)ISER,TITLE
       READ(5,*)CUTOFFS
       READ(5,*)IMIN,IMAX
       READ(5,*)A,B,GAMMA
       READ(5,*)TWOFOLD,IHSCR,IKSCR
       READ(5,*)RESOL,IBAND
       WRITE(6,102)A,B,GAMMA
       WRITE(6,103)RESOL
       WRITE(6,104)IBAND
       WRITE(6,106)TWOFOLD,IHSCR,IKSCR
99     FORMAT(I10,15A4)
102    FORMAT(' CELL PARAMETER WERE:',3F8.2)
103    FORMAT(' RESOLUTION WAS LIMITTED TO',F8.2,' ANGSTROM')
104    FORMAT(' PHASE ERRORS WILL BE AVERAGED IN',I6,' RESOLUTION BANDS')
105    FORMAT(' CUTOFFS=T, SPOTS WITH PHASES BETWEEN',2I4,' DEG WILL BE',
     .       ' REJECTED FOR PHASE ERROR CALC & ROUNDING TO 0/180 DEGS')
106    FORMAT(' FLAGS: TWOFOLD,IHSCR,IKSCR WERE SET',3L)
C      CALL DOPEN(1,'IN','RO','F')       ! old vax open
C      CALL DOPEN(2,'OUT1','NEW','F')    !  "   "   "
C      CALL DOPEN(3,'OUT2','NEW','F')    !  "   "   "
C
      DEGTORAD=3.14159/180
      RADTODEG=180/3.14159
      ASTAR=1.0/(A*SIN(DEGTORAD*GAMMA))
      BSTAR=1.0/(B*SIN(DEGTORAD*GAMMA))
      GAMMASTAR=DEGTORAD*(180.0-GAMMA)
      RESTEP=10000/(RESOL**2*IBAND)
C
C CHECKS THAT SETTINGS OF FLAGS ARE OK, I.E. IF "TWOFOLD=F" NO CUTOFFS CAN
C BE APPLIED BECAUSE THERE AREN'T ANY PHASE CONTRAINTS (SPACE GROUPS P1&P3).
C FURTHERMORE, IF "CUTOFFS=T" IMIN/IMAX=90 SHOULD NOT BE DONE. IN THESE CASES
C PROGRAM WILL EXIT AND GIVE DIAGNOSTIC MESSAGE
C
      IF(CUTOFFS) THEN
      GOTO 199
      ENDIF
      GOTO 171
198   IF(IMIN.EQ.IMAX.AND.IMIN.EQ.90) THEN
      WRITE(6,408)
      STOP
      ENDIF
      GOTO 171
199   IF(TWOFOLD) THEN
      GOTO 198
      ELSE
      WRITE(6,409)
      STOP
      ENDIF
C
C ASSIGN UNITS FOR INPUT FILES AND OPEN OUTPUT FILE WITH STATISTICS
C
171   CALL CCPDPN(1,'IN','READONLY','F',0,0)
      CALL CCPDPN(2,'IN','READONLY','F',0,0)
      CALL CCPDPN(4,'OUT2','UNKNOWN','F',0,0)
C
C EVALUATE SETTINGS OF LOGICALS AND WRITE APPROPRIATE STATEMENTS
C INTO OUTPUT FILES, DEALING WITH IMIN=IMAX=90 SETTINGS IF CUTOFF=T
C WAS LEFT ACTIVE
C
      IF(IHSCR) THEN
        WRITE(4,207)
      ENDIF
      IF(IKSCR) THEN
        WRITE(4,208)
      ENDIF
      IF(CUTOFFS) THEN
        WRITE(6,105)IMIN,IMAX
        WRITE(4,209)IMIN,IMAX
      ENDIF
197   IF(TWOFOLD) THEN
        WRITE(4,206)
      ELSE
        WRITE(4,406)
        WRITE(4,407)
      ENDIF
      GOTO 174
C
C READ TITLES AND DATA ON INPUT FILE FOR PHASE ERROR CALCULATION
C
174   READ(1,99)NSER,TITLEIN
      DO 201 I=1,NMAX
      READ(1,*,END=160) IH(I),IK(I),IL(I),AIN(I),PIN(I),FOM(I)
201   CONTINUE
160   NDATA=I-1
      CLOSE(UNIT=1)
C
C DECIDE IF TWOFOLD PHASE CONSTRAINT SHOULD BE USED TO CALCULATE
C PHASE ERRORS
C
      IF(TWOFOLD) THEN
        GOTO 411
      ELSE
        DO 402 J=1,NSLOTS
        PHASERR(J)=0.0
402     NSPOTDAT(J)=0
      ENDIF
C
403     DO 480 I=1,NDATA
C
C
       DSTARSQ = IH(I)**2*ASTAR*ASTAR + IK(I)**2*BSTAR*BSTAR +
     .          2.0*IH(I)*IK(I)*ASTAR*BSTAR*COS(GAMMASTAR)
       IF(DSTARSQ.LT.1.0/RESOL**2) THEN
               IRES=DSTARSQ*10000.
               ISLOT= 1 + IRES/RESTEP
               IF(ISLOT.LT.1.OR.ISLOT.GT.NSLOTS) THEN
                       WRITE(6,20001)ISLOT
20001                   FORMAT(' ERROR, ISLOT=',I10)
                       STOP
               END IF
               ERROR= FOM(I)/100
               PHASERR(ISLOT) = PHASERR(ISLOT) + ERROR
               NSPOTDAT(ISLOT)= NSPOTDAT(ISLOT) + 1
       ENDIF
480    CONTINUE
       DO 404 J=1,NSLOTS
       IF(NSPOTDAT(J).NE.0) THEN
          AVRGFOM(J)=PHASERR(J)/NSPOTDAT(J)
          ISPOT=ISPOT+NSPOTDAT(J)
          PHASERR(J)=RADTODEG*ACOS(AVRGFOM(J))
          ERR=ERR+(NSPOTDAT(J)*PHASERR(J))
          TOT=ERR/ISPOT
C           WRITE(6,*)ISPOT,ERR,TOT
          JIRESTEP=J*RESTEP
          RESOUT=1.0/SQRT(JIRESTEP/10000.0)
          WRITE(4,405)J,RESOUT,NSPOTDAT(J),PHASERR(J)
        ENDIF
404   CONTINUE
      WRITE(4,410)ISPOT,TOT
405   FORMAT(I4,F8.1,I8,F8.1)
406   FORMAT(' TWOFOLD=F, PHASERR IS AVERAGE FOM OF REFLECTIONS IN DEG')
407   FORMAT('   N  RESOLUTION     NDAT  AVRGFOM[DEG]')
408   FORMAT(' CUTOFFS=T; IMIN/IMAX SHOULD BE DIFFERENT FROM 90 DEG; IF',
     .       ' YOU WISH TO KEEP THEM AT 90 DEG SET CUTOFFS=F')
409   FORMAT(' CUTOFFS=T AND TWOFOLD=F --> CUTOFFS ARE NOT ALLOWED',
     .       ' BECAUSE PHASES NOT CONSTRAINED; RESET APROPRIATE FLAG')
410   FORMAT(' THE OVERALL ERROR FOR',I4,' REFL. WAS:',F6.1,' DEG')
      GOTO 314
C
C IF TWOFOLD=T PHASE ERRORS ARE CALCULATED VS 0/180 DEG
C
411   DO 202 J=1,NSLOTS
      PHASERR(J)=0.0
202   NSPOTDAT(J)=0
      DO 180 I=1,NDATA
C
C SKIP ODD (0,K,0) AND ODD (H,0,0) REFLECTIONS IF THESE ARE
C IMAGINARY FOR CALCULATING PHASE ERRORS IN PROJECTION
C
         K2=IH(I)/2
         K3=IK(I)/2
         IF(IHSCR) THEN
              IF(IH(I).NE.2*K2.AND.IK(I).EQ.0) GOTO 180
         ENDIF
         IF(IKSCR) THEN
              IF(IK(I).NE.2*K3.AND.IH(I).EQ.0) GOTO 180
         ENDIF
C
C  SKIP REFLECTIONS THAT ARE BETWEEN "IMIN" AND "IMAX" CUTOFFS FOR
C  CALCULATING PHASE ERRORS.
C
        IF(CUTOFFS) THEN
             IF(ABS(PIN(I)).GE.IMIN.AND.ABS(PIN(I)).LE.IMAX) goto 180
        ENDIF
C
C
       DSTARSQ = IH(I)**2*ASTAR*ASTAR + IK(I)**2*BSTAR*BSTAR +
     .          2.0*IH(I)*IK(I)*ASTAR*BSTAR*COS(GAMMASTAR)
       IF(DSTARSQ.LT.1.0/RESOL**2) THEN
               IRES=DSTARSQ*10000.
               ISLOT= 1 + IRES/RESTEP
               IF(ISLOT.LT.1.OR.ISLOT.GT.NSLOTS) THEN
                       WRITE(6,20000)ISLOT
20000                   FORMAT(' ERROR, ISLOT=',I10)
                       STOP
               END IF
               ERROR=AMIN1(ABS(PIN(I)),ABS(180.0-ABS(PIN(I))))
               PHASERR(ISLOT) = PHASERR(ISLOT) + ERROR
               NSPOTDAT(ISLOT)= NSPOTDAT(ISLOT) + 1
       ENDIF
180    CONTINUE
       DO 204 J=1,NSLOTS
       IF(NSPOTDAT(J).NE.0) THEN
          PHASERR(J)=PHASERR(J)/NSPOTDAT(J)
          ISPOT=ISPOT+NSPOTDAT(J)
          ERR=ERR+(NSPOTDAT(J)*PHASERR(J))
          TOT=ERR/ISPOT
C           WRITE(6,*)ISPOT,ERR,TOT
          JIRESTEP=J*RESTEP
          RESOUT=1.0/SQRT(JIRESTEP/10000.0)
          WRITE(4,205)J,RESOUT,NSPOTDAT(J),PHASERR(J)
        ENDIF
204   CONTINUE
      WRITE(4,410)ISPOT,TOT
205   FORMAT(I4,F8.1,I8,F8.1)
206   FORMAT('   N  RESOLUTION     NDAT  PHASERR(0/180)')
207   FORMAT(' IHSCR=T, ODD (H,0,0) REFL. IGNORED FOR PHASE ERROR CALC')
208   FORMAT(' IKSCR=T, ODD (0,K,0) REFL. IGNORED FOR PHASE ERROR CALC')
209   FORMAT(' IMIN/IMAX=',2I4,' REFLECTIONS WITH PHASES WITHIN CUTOFF',
     .      ' WERE IGNORED FOR PHASE ERROR CALC')
C
C THIS PART FOR ADJUSTING THE FOM'S FOR THE DEVIATION FROM THEORETICAL
C CENTROSYMMETRIC VALUES (0/180 DEG) AND WRITE NEW SPOT LIST WITH
C ADJUSTED FOMS AND PHASES BEING SET TO CLOSER THEORETICAL VALUE
C
      IF(TWOFOLD) GOTO 300
      STOP
300   CALL CCPDPN(3,'OUT','UNKNOWN','F',0,0)
      READ(2,99)NSER,TITLEIN
      WRITE(3,99)ISER,TITLE
C
      DO 301 I=1,NMAX
        READ(2,*,END=310) IH(I),IK(I),IL(I),AIN(I),PIN(I),FOM(I)
C       write(6,*)IH(I),IK(I),IL(I),AIN(I),PIN(I),FOM(I)
C
C
C
C SKIP ODD (0,K,0) AND ODD (H,0,0) REFLECTIONS IF THESE ARE
C IMAGINARY, THESE WILL NOT BE PASSED ON TO OUTPUT DATA SET
C
        K2=IH(I)/2
        K3=IK(I)/2
        IF(IHSCR) THEN
             IF(IH(I).NE.2*K2.AND.IK(I).EQ.0) GOTO 301
        ENDIF
        IF(IKSCR) THEN
             IF(IK(I).NE.2*K3.AND.IH(I).EQ.0) GOTO 301
        ENDIF
C
C IF CUTOFFS=T AND IMIN/IMAX WERE SPECIFIED ALL SPOTS WITH PHASES
C BETWEEN IMIN AND IMAX WILL BE REJECTED HERE. THEY ALSO WILL NOT BE
C PASSED ON TO THE OUTPUT FILE USED FOR CALCULATING MAPS
C
        IF(CUTOFFS) THEN
              IF(ABS(PIN(I)).GE.IMIN.AND.ABS(PIN(I)).LE.IMAX) GOTO 301
        ENDIF
C
C ADJUST FOM FOR DEVIATION FROM THEORETICAL
C
        FOM(I)=FOM(I)*ABS(COS(DEGTORAD*PIN(I)))
C
C ROUNDING OF PHASES TO CLOSET CENTROSYMMETRIC VALUE (0/180 DEG) AND
C OUTPUT OF "SYMMETRIZIED" DATA. IF A REFLECTION HAPPENS TO HAVE A PHASE
C OF PRECISELY 90 DEG IT'S FOM WILL BE ZERO --> DOESN'T MATTER HOW THIS
C IS ROUNDED
C
        IF(ABS(PIN(I)).GT.90) PIN(I)=180.0
        IF(ABS(PIN(I)).LE.90) PIN(I)=0.0
        WRITE(3,1000) IH(I),IK(I),IL(I),AIN(I),PIN(I),FOM(I) ! O/P of SPOTS.
1000    FORMAT(1X,3I4,3F8.1)
301   CONTINUE
      STOP
310   close(2)
      close(3)
      close(4)
      STOP
314   END