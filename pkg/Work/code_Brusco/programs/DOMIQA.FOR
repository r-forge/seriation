      PROGRAM SAJUMP4
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)
      DOUBLE PRECISION A(400,400), B(400,400), SOLS(1000),
     1       RMED(1000)
      REAL S1,RCRIT
      INTEGER S(400), UNSEL, STRY(400),
     1        QSET(400), TRIG, TRIG2, Q, BL,
     1        IBLOCK(400)
      OPEN(1, FILE = 'DATASET')   ! ASYMMETRIC MATRIX
      OPEN(2, FILE = 'OUTPUT')
      OPEN(3, FILE = 'PERMUT')    ! INITIAL PERMUTATION
      OPEN(4, FILE = 'FINPERM')   ! FINAL PERMUTATION
      CALL GETTIM (IHR, IMIN, ISEC, I100)
      CALL GETDAT (IYR, IMON, IDAY)  
      TIMEA = DFLOAT(86400*IDAY+3600*IHR+60*IMIN+ISEC)+DFLOAT(I100)/100.  
      ZMIN = 9.9d+09
      ZMAX = 0.0d0
      ASUM = 0.0D0
      READ(1,*)
      READ(1,*) N
      READ(1,*) ((A(I,J),J=1,N),I=1,N)
      DO I = 1,N-1
        DO J = I+1,N
          B(I,J) = A(J,I)-A(I,J)
          B(J,I) = A(I,J)-A(J,I)
          ASUM = ASUM + A(I,J) + A(J,I)
        END DO
      END DO
      EPS = 1.0D-08
      BL = 10
      NREPS = 1
C
      DO 1000 III = 1,NREPS
C        ICT1=0
C        ICT2=0
C        ICT3=0
        READ(3,*) IJUNK
        DO I = 1,N
          READ(3,*) ijnk,S(I)
        END DO
        Z = 0.0D0
        DO I = 1,N-1
          K = S(I)
          DO J = I+1,N
            L = S(J)
            Z = Z + A(K,L)
          END DO
        END DO
C
 2100   TRIG2=0
 2200   TRIG=0            
        DO 50 I = 1,N-1
          DO 51 J = I + 1,N
            K = S(I)
            M = S(J)
            DELTA = B(K,M)
            DO L = I+1,J-1
              Q = S(L)
              DELTA = DELTA + B(K,Q) + B(Q,M)
            END DO
            IF(DELTA.GT.EPS) THEN
              TRIG = 1
              TRIG2 = 1
              Z = Z + DELTA
              S(I) = M
              S(J) = K
C              ict1 = ict1+1
            END IF
 51       CONTINUE
 50     CONTINUE
        IF(TRIG.EQ.1) GO TO 2200
C
 2300   TRIG = 0
        DO 59 LL = 1,BL
          DO 60 I = 1,N
            ILAST = I+LL-1
            IF(ILAST.GT.N) GO TO 60
            DO 61 J = 1,I-1
              DO JJ = I,ILAST
                IBLOCK(JJ-I+1) = S(JJ)
              END DO
              DELTA = 0.0D0
              DO 63 K = J,I-1
                K3 = S(K)
                DO JJ = 1,LL
                  K1 = IBLOCK(JJ)
                  DELTA = DELTA + B(K3,K1)
                END DO
 63           CONTINUE
              IF(DELTA.GT.EPS) THEN
                TRIG = 1
                TRIG2 = 1
                DO JJ = 1,LL
                  K1 = IBLOCK(JJ)
                END DO
                DO K = I,J+1,-1
                  S(K+LL-1) = S(K-1)
                END DO
                DO K = J,J+LL-1
                  S(K) = IBLOCK(K-J+1)
                END DO
                Z = Z + DELTA
C                ict2 = ict2+1
                GO TO 60
              END IF
 61         CONTINUE

 70         DO 62 J = N,ILAST+1,-1
              DO JJ = I,I+ILAST
                IBLOCK(JJ-I+1) = S(JJ)
              END DO
              DELTA = 0.0D0
              DO K = J,ILAST+1,-1
                K3 = S(K)
                DO JJ = 1,LL
                  K1 = IBLOCK(JJ)
                  DELTA = DELTA + B(K1,K3)
                END DO
              END DO
              IF(DELTA.GT.EPS) THEN
                TRIG = 1
                TRIG2 = 1
                DO K = I,J-LL
                  S(K) = S(K+LL)
                END DO
                DO K = J-LL+1,J
                  S(K)=IBLOCK(K-J+LL)
                END DO
                Z = Z + DELTA
C                ict3 = ict3+1
                GO TO 60
              END IF
 62         CONTINUE
 60       CONTINUE
 59     CONTINUE
        IF(TRIG.EQ.1) GO TO 2300
C        go to 2600
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
 2700   SOLS(III) = Z
        RMED(III) = Z
        ZSUM = ZSUM + Z
        IF(Z.LT.ZMIN) ZMIN = Z
        IF(Z.GT.ZMAX) ZMAX = Z
C        write(*,77) z,ict1,ict2,ict3,ICT4
 1000 CONTINUE
      CALL GETTIM (IHR, IMIN, ISEC, I100)  
      CALL GETDAT (IYR, IMON, IDAY)  
      TIMEB = DFLOAT(86400*IDAY+3600*IHR+60*IMIN+ISEC)+DFLOAT(I100)/100.  
      TIMTOT = TIMEB - TIMEA
      ZSUM = ZSUM/DFLOAT(NREPS)
C      TIMTOT = TIMTOT / DFLOAT(NREPS)
      IBEST = 0
      DO I = 1,NREPS
        IF(SOLS(I).GT.ZMAX-EPS) IBEST = IBEST + 1
      END DO
      ATTR = 100.*(DFLOAT(IBEST) / DFLOAT(NREPS))
      DO I = 1,NREPS-1
        DO J = I + 1,NREPS
          IF(RMED(J).LT.RMED(I)) THEN
            RST = RMED(J)
            RMED(J) = RMED(I)
            RMED(I) = RST
          END IF
        END DO
      END DO
      NR = NREPS/2
      RMN = (RMED(NR)+RMED(NR+1))/2.0
C      WRITE(2,201)
      WRITE(*,201)
      WRITE(2,202) ZMAX, ZMAX/ASUM, TIMTOT
      WRITE(*,202) ZMAX, ZMAX/ASUM, TIMTOT
C      REWIND 3
      WRITE(4,*) N
      DO I = 1,N
        WRITE(4,*) I,S(I)
      END DO
  201 FORMAT(9X,'MAX',5X,'LINDX',7X,'TIME')
  202 FORMAT(F14.4,F11.8,F8.2)
  889 continue
      END



