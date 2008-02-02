      PROGRAM SAJUMP4
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)
      DOUBLE PRECISION A(400,400), ASUM(400), SLEFT(400), SLEFTRY(400),
     1   X(400), COORD(400), SOLS(1000),SOLS2(1000), X1(400),RMED(1000)
      REAL S1,RCRIT
      INTEGER S(400), STRY(400),
     1        QSET(400), TRIG, TRIG2, Q, BL,
     1        IBLOCK(400)
      CHARACTER JNK$
      OPEN(1, FILE = 'DATASET')   ! SYMMETRIC DISSIMILARITY MATRIX
      OPEN(2, FILE = 'OUTPUT')
      OPEN(3, FILE = 'PERMUT')    ! INITIAL PERMUTATION
      OPEN(5, FILE = 'FINPERM')   ! FINAL PERMUTATION
C      OPEN(4, FILE = 'RUNCNT')
      CALL GETTIM (IHR, IMIN, ISEC, I100)
      CALL GETDAT (IYR, IMON, IDAY)  
      TIMEA = DFLOAT(86400*IDAY+3600*IHR+60*IMIN+ISEC)+DFLOAT(I100)/100.  
      ZMAX=0.0D0
      ZMIN=9.9D+09
      READ(1,*) N
      READ(1,*) JNK$
      READ(1,*) ((A(I,J),J=1,N),I=1,N)
      DO I = 1,N
        ASUM(I)=0.
      END DO
      EPS = 1.0D-08
      BL = 10
      DO I = 1,N
        DO J = 1,N
          ASUM(I) = ASUM(I) + A(I,J)
        END DO
      END DO
C      READ(4,*) IPROB
C      DO K = 1,IPROB
        READ(3,*) IJNK
        DO I = 1,IJNK
          READ(3,*) IX,S(I)
        END DO
C      END DO
C      REWIND 4
C      WRITE(4,*) IPROB + 1
      NREPS = 1
C
      DO 1000 III = 1,NREPS
        do i = 1,n
          SLEFT(I)=0.0D0
        end do
        Z = 0.0D0
        DO I = 1,N
          K = S(I)
          DO J = 1,I-1
            L = S(J)
            SLEFT(K) = SLEFT(K) + A(K,L)
          END DO
          Z = Z + (ASUM(K)-2*SLEFT(K))**2
        END DO
C        WRITE(*,*) Z
C        go to 2700
C
 2100   TRIG2=0
 2200   TRIG=0            
        DO 50 I = 1,N-1
          DO 51 J = I + 1,N
            K = S(I)
            M = S(J)
            DELTA = 0
            DO L = I,J
              Q = S(L)
              DELTA = DELTA - (ASUM(Q)-2.*SLEFT(Q))**2
            END DO
            XK = SLEFT(K)
            DO L = I+1,J
              Q = S(L)
              XK = XK + A(K,Q)
            END DO
            DELTA = DELTA + (ASUM(K)-2.*XK)**2
            XM = SLEFT(M)
            DO L = I,J-1
              Q = S(L)
              XM = XM - A(M,Q)
            END DO
            DELTA = DELTA + (ASUM(M)-2.*XM)**2
            DO L = I+1,J-1
              Q = S(L)
              X(L) = SLEFT(Q) + A(M,Q) - A(K,Q)
              DELTA = DELTA + (ASUM(Q)-2.*X(L))**2
            END DO
            IF(DELTA.GT.EPS) THEN
              TRIG = 1
              TRIG2 = 1
              Z = Z + DELTA
              SLEFT(K) = XK
              SLEFT(M) = XM
              DO L = I+1,J-1
                Q = S(L)
                SLEFT(Q) = X(L)
              END DO
              S(I) = M
              S(J) = K
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
                X1(JJ-I+1) = SLEFT(IBLOCK(JJ-I+1))
              END DO
              DELTA = 0.0D0
              DO 63 K = J,I-1
                K3 = S(K)
                X(K) = SLEFT(K3)
                DO JJ = 1,LL
                  K1 = IBLOCK(JJ)
                  X(K) = X(K) + A(K1,K3)
                  X1(JJ) = X1(JJ) - A(K1,K3)
                END DO
                DELTA = DELTA - (ASUM(K3)-2.*SLEFT(K3))**2
                DELTA = DELTA + (ASUM(K3)-2.*X(K))**2
 63           CONTINUE
              DO JJ = 1,LL
                K1 = IBLOCK(JJ)
                DELTA = DELTA - (ASUM(K1)-2.*SLEFT(K1))**2
                DELTA = DELTA + (ASUM(K1)-2.*X1(JJ))**2
              END DO
              IF(DELTA.GT.EPS) THEN
                TRIG = 1
                TRIG2 = 1
                DO JJ = 1,LL
                  K1 = IBLOCK(JJ)
                  SLEFT(K1) = X1(JJ)
                END DO
                DO K = J,I-1
                  K3 = S(K)
                  SLEFT(K3) = X(K)
                END DO
                DO K = I,J+1,-1
                  S(K+LL-1) = S(K-1)
                END DO
                DO K = J,J+LL-1
                  S(K) = IBLOCK(K-J+1)
                END DO
                Z = Z + DELTA
                GO TO 60
              END IF
 61         CONTINUE

 70         DO 62 J = N,ILAST+1,-1
              DO JJ = I,I+ILAST
                IBLOCK(JJ-I+1) = S(JJ)
                X1(JJ-I+1) = SLEFT(IBLOCK(JJ-I+1))
              END DO
              DELTA = 0.0D0
              DO K = J,ILAST+1,-1
                K3 = S(K)
                X(K) = SLEFT(K3)
                DO JJ = 1,LL
                  K1 = IBLOCK(JJ)
                  X(K) = X(K) - A(K1,K3)
                  X1(JJ) = X1(JJ) + A(K1,K3)
                END DO
                DELTA = DELTA - (ASUM(K3)-2.*SLEFT(K3))**2
                DELTA = DELTA + (ASUM(K3)-2.*X(K))**2
              END DO
              DO JJ = 1,LL
                K1 = IBLOCK(JJ)
                DELTA = DELTA - (ASUM(K1)-2.*SLEFT(K1))**2
                DELTA = DELTA + (ASUM(K1)-2.*X1(JJ))**2
              END DO
              IF(DELTA.GT.EPS) THEN
                TRIG = 1
                TRIG2 = 1
                DO JJ = 1,LL
                  K1 = IBLOCK(JJ)
                  SLEFT(K1) = X1(JJ)
                END DO
                DO K = J,ILAST+1,-1
                  K3 = S(K)
                  SLEFT(K3) = X(K)
                END DO
                DO K = I,J-LL
                  S(K) = S(K+LL)
                END DO
                DO K = J-LL+1,J
                  S(K)=IBLOCK(K-J+LL)
                END DO
                Z = Z + DELTA
                GO TO 60
              END IF
 62         CONTINUE
 60       CONTINUE
 59     CONTINUE
        IF(TRIG.EQ.1) GO TO 2300
        IF(TRIG2.EQ.1) GO TO 2100
C
 2700   ZLOSS = 0.0D0
        DO I = 1,N
          COORD(I) = 0.0D0
        END DO
        K = S(1)
        COORD(K) = 0.0D0
        DO I = 2,N
          K = S(I)
          K2 = S(I-1)
          CRIT = 0.0D0
          DO L = I,N
            K3 = S(L)
            CRIT = CRIT + A(K2,K3)
          END DO
          DO L = 1,I-2
            K3 = S(L)
            CRIT = CRIT - A(K2,K3)
          END DO
          DO L = I+1,N
            K3 = S(L)
            CRIT = CRIT - A(K,K3)
          END DO
          DO L = 1,I-1
            K3 = S(L)
            CRIT = CRIT + A(K,K3)
          END DO
          CRIT = CRIT / DFLOAT(N)
          COORD(K) = COORD(K2) + CRIT
        END DO
        DO I = 1,N-1
          DO J = I+1,N
            DIST = ABS(COORD(I) - COORD(J))
            ZLOSS = ZLOSS + (A(I,J) - DIST)**2
          END DO
        END DO
        SOLS(III) = Z
        SOLS2(III) = ZLOSS
        RMED(III) = ZLOSS
        ZSUM = ZSUM + ZLOSS
        IF(ZLOSS.LT.ZMIN) ZMIN = ZLOSS
        IF(ZLOSS.GT.ZMAX) ZMAX = ZLOSS
 1000 CONTINUE
      ZNORM = 0.0D0
      DO I = 1,N-1
        DO J = I+1,N
          ZNORM = ZNORM + A(I,J)**2
        END DO
      END DO
      CALL GETTIM (IHR, IMIN, ISEC, I100)  
      CALL GETDAT (IYR, IMON, IDAY)  
      TIMEB = DFLOAT(86400*IDAY+3600*IHR+60*IMIN+ISEC)+DFLOAT(I100)/100.  
      TIMTOT = TIMEB - TIMEA
      ZSUM = ZSUM/DFLOAT(NREPS)
C      TIMTOT = TIMTOT / DFLOAT(NREPS)
      IBEST = 0
      DO I = 1,NREPS
        IF(SOLS2(I).LT.ZMIN+EPS) IBEST = IBEST + 1
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
C      WRITE(*,201)
      WRITE(2,202) Z,ZMIN, ZMIN/ZNORM,TIMTOT
      WRITE(*,202) Z,ZMIN, ZMIN/ZNORM,TIMTOT
      WRITE(5,*) N
      DO I = 1,N
        WRITE(5,*) I,S(I)
      END DO
   77 format(2f20.4)
  200 FORMAT(I3,2F20.6)
  201 FORMAT(9X,'MIN',8X,'NORM',6X,'TIME')
  202 FORMAT(2F14.4,F11.8,F8.2)
  889 continue
      END
