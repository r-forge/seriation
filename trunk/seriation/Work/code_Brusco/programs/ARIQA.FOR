      PROGRAM SAJUMP4
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)
      DOUBLE PRECISION A(400,400), B(400,400), 
     1       D(400,400), R1(80000), R2(80000)
      REAL S1,RCRIT
      INTEGER S(400), UNSEL, STEMP(400),
     1        QSET(400), TRIG, TRIG2, Q, BL,
     1        IBLOCK(400)
      CHARACTER JNK$
      OPEN(1, FILE = 'DATASET')  ! SYMMETRIC DISSIMILARIY MATRIX
      OPEN(2, FILE = 'OUTPUT')
      OPEN(3, FILE = 'PERMUT')   ! INITIAL PERMUTATION
C      OPEN(4, FILE = 'RUNCNT')
      OPEN(5, FILE='FINPERM')    ! FINAL PERMUTATION
      CALL GETTIM (IHR, IMIN, ISEC, I100)
      CALL GETDAT (IYR, IMON, IDAY)  
      TIMEA = DFLOAT(86400*IDAY+3600*IHR+60*IMIN+ISEC)+DFLOAT(I100)/100.  
      ZMIN = 9.9d+09
      ZMAX = 0.0d0
      ASUM = 0.0D0
      READ(1,*) N
      READ(1,*) JNK$
      READ(1,*) ((A(I,J),J=1,N),I=1,N)
      ICT = 0
      DO I = 1,N-1
        DO J = I+1,N
          ICT = ICT + 1
          D(I,J) = DFLOAT(J-I)
          D(J,I) = D(I,J)
          R1(ICT) = D(I,J)
          R2(ICT) = A(I,J)
        END DO
      END DO
      DO I = 1, ICT-1
        DO J = I+1,ICT
          IF(R1(J).GT.R1(I)) THEN
            RDUM = R1(J)
            R1(J) = R1(I)
            R1(I) = RDUM
          END IF
          IF(R2(J).GT.R2(I)) THEN
            RDUM = R2(J)
            R2(J) = R2(I)
            R2(I) = RDUM
          END IF
        END DO
      END DO
      ASUM = 0.0D0
      DO I = 1,ICT
        ASUM = ASUM + R1(I) * R2(I)
      END DO
      EPS = 1.0D-08
      BL = 10
      NREPS = 1
C      READ(4,*) IPROB
C      DO K = 1,IPROB
        READ(3,*) IJUNK
        DO I = 1,IJUNK
          READ(3,*) ijnk,S(I)
        END DO
C      END DO
C      REWIND 4
C      WRITE(4,*) IPROB + 1
      Z = 0.0D0
      DO I = 1,N-1
        K = S(I)
        DO J = 1+I,N
          L = S(J)
          Z = Z + D(I,J) * A(K,L)
        END DO
      END DO
c      go to 2700
C
 2100 TRIG2=0
 2200 TRIG=0            
      DO 50 I = 1,N-1
        DO 51 J = I + 1,N
          K = S(I)
          M = S(J)
          DELTA = 0.0D0
          DO 1250 L1 = 1,N
            IF(L1.EQ.I.OR.L1.EQ.J) GO TO 1250
            L=S(L1)
            DELTA=DELTA+(D(L1,I)-D(L1,J))*(A(L,M)-A(L,K))
 1250     CONTINUE
          IF(DELTA.GT.EPS) THEN
            TRIG = 1
            TRIG2 = 1
            Z = Z + DELTA
            S(I) = M
            S(J) = K
C            ict1 = ict1+1
          END IF
 51     CONTINUE
 50   CONTINUE
      IF(TRIG.EQ.1) GO TO 2200
C      go to 2700
C
 2300 TRIG = 0
      DO 59 LL = 1,BL
        DO 60 I = 1,N
          ILAST = I+LL-1
          IF(ILAST.GT.N) GO TO 60
          DO JJ = 1,N
            STEMP(JJ) = S(JJ)
          END DO
          DO 61 J = 1,N
            IF(I.EQ.J) GO TO 61
            DO JJ = I,ILAST
              IBLOCK(JJ-I+1) = STEMP(JJ)
            END DO
            DO JJ = I,N-BL
              STEMP(JJ) =STEMP(JJ+BL)
            END DO
            DO JJ = N,J+BL-1,-1
              STEMP(JJ) = STEMP(JJ-BL)
            END DO
            DO JJ = J,J+BL-1
              STEMP(JJ) = IBLOCK(JJ-J+1)
            END DO
            ZTEST = 0.0D0
            DO II = 1,N-1
              DO JJ = II+1,N
                ZTEST = ZTEST + D(II,JJ)*A(STEMP(II),STEMP(JJ))
              END DO
            END DO
            DELTA = ZTEST - Z
            IF(DELTA.GT.EPS) THEN
              TRIG = 1
              TRIG2 = 1
              Z = ZTEST
              DO JJ = 1,N
                S(JJ) = STEMP(JJ)
              END DO
              GO TO 60
            END IF
 61       CONTINUE
 60     CONTINUE
 59   CONTINUE
      IF(TRIG.EQ.1) GO TO 2300
      go to 2600
C
 2400   TRIG=0
        DO 159 IBL = 4,N-1
          DO 160 L = 1,N-IBL+1
            DELTA = 0.0D0
            DO 161 LL = L,L+IBL-2
              DO 162 LLL = LL+1,L+IBL-1
                K = S(LL)
                M = S(LLL)
                DELTA = DELTA + B(K,M)
 162          CONTINUE
 161        CONTINUE
            IF(DELTA.GT.EPS) THEN
              TRIG=1
              TRIG2=1
              IC=L-1
              DO LL = L+IBL-1,L,-1
                IC=IC+1
                IBLOCK(IC)=S(LL)
              END DO
              DO LL = L,L+IBL-1
                S(LL)=IBLOCK(LL)
              END DO
C              ICT4=ICT4+1
            END IF
 160      CONTINUE
 159    CONTINUE
        IF(TRIG.EQ.1) GO TO 2400
 2600   IF(TRIG2.EQ.1) GO TO 2100
C
 2700 CONTINUE
        
      CALL GETTIM (IHR, IMIN, ISEC, I100)  
      CALL GETDAT (IYR, IMON, IDAY)  
      TIMEB = DFLOAT(86400*IDAY+3600*IHR+60*IMIN+ISEC)+DFLOAT(I100)/100.  
      TIMTOT = TIMEB - TIMEA
      WRITE(5,*) N
      DO I = 1,N
        WRITE(5,*) I,S(I)
      END DO
      IBEST = 0
      WRITE(2,202) Z, Z/ASUM, TIMTOT
      WRITE(*,202) Z, Z/ASUM, TIMTOT
  201 FORMAT(9X,'MAX',5X,'LINDX',7X,'TIME')
  202 FORMAT(F14.4,F11.8,F8.2)
  889 continue
      END
