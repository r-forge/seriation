      PROGRAM SANNEAL
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)
      DOUBLE PRECISION A(400,400), ASUM(400), SLEFT(400),
     1       X(400), COORD(400), SOLS(100), SOLS2(100), RMED(100)
      REAL S1,RCRIT
      INTEGER U(400), S(400), UNSEL, T(100,400), SB(400), Q, GB(400)
      CHARACTER JNK$
C
C ####################################################################
C  DHA.FOR IS A DISCRETE SIMULATED ANNEALING CODE FOR LEAST-SQAURES
C      UNIDIMENSIONAL SCALING BASED ON THE DEFAYS STRATEGY. THE CODE
C      USE PAIRWISE INTERCHANGE AND SINGLE-OBJECT INSERTIONS TO
C      GENERATE NEIGHBORING SOLUTIONS.
C   - 20 REPLICATIONS FROM RANDOM STARTS
C   - SUMMARY STATISTICS COMPUTED BY PROGRAM
C INPUT FILE: "MATFULL" AN N X N SYMMETRIC DISSIMILARITY MATRIX WHERE
C             THE FIRST ELEMENT IN THE FILE IS N.
C OUTPUT FILES: "OUTPUT" IS A SOLUTION SUMMARY
C               "STARTS" CONTAINS THE PERMUTATIONS FOR EACH REPLICATE,
C               WHICH CAN BE READ BY A POSTPROCESSOR SUCH AS THE "HAM"
C               STRATEGY.
C ####################################################################

      OPEN(1, FILE = 'DATASET')
      OPEN(2, FILE = 'OUTPUT')
      OPEN(3, FILE = 'PERMUT')
      OPEN(4, FILE = 'SUMMARY')
      CALL GETTIM (IHR, IMIN, ISEC, I100)
      CALL GETDAT (IYR, IMON, IDAY)  
      TIMEA = DFLOAT(86400*IDAY+3600*IHR+60*IMIN+ISEC)+DFLOAT(I100)/100.  
      RULE = .5D0    ! PROB OF SELECTING PAIRWISE INTERCHANGE
      READ(1,*) N
      READ(1,*) JNK$
      READ(1,*) ((A(I,J),J=1,N),I=1,N)
      WRITE(*,177)
      WRITE(2,177)
      DO I = 1,N
        ASUM(I)=0.
      END DO
      EPS = 1.0D-08
      ZNORM = 0.0D0
      DO I = 1,N
        DO J = 1,N
          ASUM(I) = ASUM(I) + A(I,J)
          IF(I.LT.J) ZNORM = ZNORM + A(I,J)**2
        END DO
      END DO
      NREPS = 20
      DO 999 III = 1,NREPS
        DO I = 1,N
          U(I) = I
          T(III,I) = 0
        END DO
        UNSEL = N
        DO 1 I = 1,N
          CALL RANDOM(S1)
          ISET = S1 * FLOAT(UNSEL) + 1.
          IF(ISET.GT.UNSEL) ISET = UNSEL
          T(III,I) = U(ISET)
          DO J = ISET,UNSEL
            U(J) = U(J+1)
          END DO
          UNSEL = UNSEL - 1
  1     CONTINUE
 999  CONTINUE
C
      ZMIN = 9.9D+12
      ZAVG = 0.
      ZMAX = 0.
      DO 1000 III = 1,NREPS
        DO I = 1,N
          S(I) = T(III,I)
          SLEFT(I) = 0.0D0
        END DO
        Z = 0.0D0
        DO I = 1,N
          K = S(I)
          DO J = 1,I-1
            L = S(J)
            SLEFT(K) = SLEFT(K) + A(K,L)
          END DO
          Z = Z + (ASUM(K)-2*SLEFT(K))**2
        END DO
        ZBEST = Z
        TMAX = 0.0D0
        DO LLL = 1,5000
          CALL RANDOM(S1)
          I1 = S1 * FLOAT(N) + 1.
          IF(I1.GT.N) I1 = N
 199      CALL RANDOM(S1)
          J1 = S1 * FLOAT(N) + 1.
          IF(J1.GT.N) J1 = N
          IF(I1.EQ.J1) GO TO 199
          IF(I1.GT.J1) THEN
            JDUM = J1
            J1 = I1
            I1 = JDUM
          END IF
          K = S(I1)
          M = S(J1)
          DELTA = 0.0D0
          XK = 0.0D0
          XM = 0.0D0
          DO L = I1+1,J1
            Q = S(L)
            XK = XK + A(K,Q)
          END DO
          DO L = I1, J1-1
            Q = S(L)
            XM = XM - A(M,Q)
          END DO
          XK2 = XK * XK
          XM2 = XM * XM
          DELTA = DELTA + 4*XM2 + 8*XM*SLEFT(M) - 4*XM*ASUM(M)
          DELTA = DELTA + 4*XK2 + 8*XK*SLEFT(K) - 4*XK*ASUM(K)
          DO L = I1+1,J1-1
            Q = S(L)
            X(L) = A(M,Q) - A(K,Q)
            XL2 = X(L) * X(L)
            DELTA = DELTA + 4*XL2 + 8*X(L)*SLEFT(Q) - 4*X(L)*ASUM(Q)
          END DO
          IF(DELTA.LT.0) THEN
            IF(ABS(DELTA).GT.TMAX) TMAX = ABS(DELTA)
          END IF
        END DO
        COOL = .95
        TMIN = .0001d0
C        TMAX = Z
        ILOOP = 100*N
        NLOOP = (LOG(TMIN)-LOG(TMAX))/LOG(COOL)
C        WRITE(*,21) TMIN,TMAX,NLOOP
C  21    FORMAT(2F14.5,I6)
C        GO TO 889
        TEMP = TMAX
        DO I = 1,N
          SB(I) = S(I)
        END DO
C
        DO 2000 IJK = 1,NLOOP
          DO 2001 KKK = 1,ILOOP
            CALL RANDOM(S1)
            IF(S1.LE.RULE) THEN         ! INTERCHANGE
            CALL RANDOM(S1)
            I1 = S1 * FLOAT(N) + 1.
            IF(I1.GT.N) I1 = N
 99         CALL RANDOM(S1)
            J1 = S1 * FLOAT(N) + 1.
            IF(J1.GT.N) J1 = N
            IF(I1.EQ.J1) GO TO 99
            IF(I1.GT.J1) THEN
              JDUM = J1
              J1 = I1
              I1 = JDUM
            END IF
            K = S(I1)
            M = S(J1)
            DELTA = 0.0D0
            XK = 0.0D0
            XM = 0.0D0
            DO L = I1+1,J1
              Q = S(L)
              XK = XK + A(K,Q)
            END DO
            DO L = I1, J1-1
              Q = S(L)
              XM = XM - A(M,Q)
            END DO
            XK2 = XK * XK
            XM2 = XM * XM
            DELTA = DELTA + 4*XM2 + 8*XM*SLEFT(M) - 4*XM*ASUM(M)
            DELTA = DELTA + 4*XK2 + 8*XK*SLEFT(K) - 4*XK*ASUM(K)
            DO L = I1+1,J1-1
              Q = S(L)
              X(L) = A(M,Q) - A(K,Q)
              XL2 = X(L) * X(L)
              DELTA = DELTA + 4*XL2 + 8*X(L)*SLEFT(Q) - 4*X(L)*ASUM(Q)
            END DO
            IF(DELTA.GT.-EPS) THEN
              Z = Z + DELTA
              SLEFT(K) = SLEFT(K)+XK
              SLEFT(M) = SLEFT(M)+XM
              DO L = I1+1, J1-1
                Q = S(L)
                SLEFT(Q) = SLEFT(Q) + X(L)
              END DO
              S(I1) = M
              S(J1) = K
              IF(Z.GT.ZBEST) THEN
                ZBEST = Z
                DO I = 1,N
                  SB(I) = S(I)
                END DO
              END IF
            ELSE
              CALL RANDOM(S1)
              RCRIT = EXP(DELTA/TEMP)
              IF(S1.LE.RCRIT) THEN
                Z = Z + DELTA
                SLEFT(K) = SLEFT(K)+XK
                SLEFT(M) = SLEFT(M)+XM
                DO L = I1+1, J1-1
                  Q = S(L)
                  SLEFT(Q) = SLEFT(Q) + X(L)
                END DO
                S(I1) = M
                S(J1) = K
              END IF
            END IF

            ELSE                ! INSERTION

            CALL RANDOM(S1)
            I1 = S1 * FLOAT(N) + 1.      ! OBJECT POSITION IS I1
            IF(I1.GT.N) I1 = N
 599         CALL RANDOM(S1)
            J1 = S1 * FLOAT(N) + 1.
            IF(J1.GT.N) J1 = N
            IF(I1.EQ.J1) GO TO 599
            K = S(I1)
            DELTA = 0.0D0
            XK = 0.0D0
            IF(J1.GT.I1) THEN
              DO L = I1+1,J1
                Q = S(L)
                XK = XK + A(K,Q)
              END DO
            ELSE
              DO L = I1-1,J1,-1
                Q = S(L)
                XK = XK - A(K,Q)
              END DO
            END IF  
            XK2 = XK * XK
            DELTA = DELTA + 4*XK2 + 8*XK*SLEFT(K) - 4*XK*ASUM(K)
            IF(J1.GT.I1) THEN
              DO L = I1+1,J1
                Q = S(L)
                X(L) = -A(K,Q)
                XL2 = X(L) * X(L)
                DELTA=DELTA + 4*XL2 + 8*X(L)*SLEFT(Q) - 4*X(L)*ASUM(Q)
              END DO
            ELSE
              DO L = I1-1,J1,-1
                Q = S(L)
                X(L) = A(K,Q)
                XL2 = X(L) * X(L)
                DELTA=DELTA + 4*XL2 + 8*X(L)*SLEFT(Q) - 4*X(L)*ASUM(Q)
              END DO
            END IF
            IF(DELTA.GT.-EPS) THEN
              Z = Z + DELTA
              SLEFT(K) = SLEFT(K)+XK
              IF(J1.GT.I1) THEN
                DO L = I1+1, J1
                  Q = S(L)
                  SLEFT(Q) = SLEFT(Q) + X(L)
                END DO
                DO L = I1,J1-1
                  S(L)=S(L+1)
                END DO
                S(J1) = K
              ELSE
                DO L = I1-1,J1,-1
                  Q = S(L)
                  SLEFT(Q) = SLEFT(Q) + X(L)
                END DO
                DO L = I1,J1+1,-1
                  S(L)=S(L-1)
                END DO
                S(J1) = K
              END IF

              IF(Z.GT.ZBEST) THEN
                ZBEST = Z
                DO I = 1,N
                  SB(I) = S(I)
                END DO
              END IF
            ELSE
              CALL RANDOM(S1)
              RCRIT = EXP(DELTA/TEMP)
              IF(S1.LE.RCRIT) THEN
                Z = Z + DELTA
                SLEFT(K) = SLEFT(K)+XK
                IF(J1.GT.I1) THEN
                  DO L = I1+1, J1
                    Q = S(L)
                    SLEFT(Q) = SLEFT(Q) + X(L)
                  END DO
                  DO L = I1,J1-1
                    S(L)=S(L+1)
                  END DO
                  S(J1) = K
                ELSE
                  DO L = I1-1,J1,-1
                    Q = S(L)
                    SLEFT(Q) = SLEFT(Q) + X(L)
                  END DO
                  DO L = I1,J1+1,-1
                    S(L)=S(L-1)
                  END DO
                  S(J1) = K
                END IF
              END IF
            END IF

            END IF
 2001     CONTINUE
          TEMP = TEMP*COOL
 2000   CONTINUE
C
        ZLOSS = 0.0D0
C        WRITE(3,*) N
        DO I = 1,N
          COORD(I) = 0.0D0
C          WRITE(3,*) I,SB(I)
        END DO
        K = SB(1)
        COORD(K) = 0.0D0
        DO I = 2,N
          K = SB(I)
          K2 = SB(I-1)
          CRIT = 0.0D0
          DO L = I,N
            K3 = SB(L)
            CRIT = CRIT + A(K2,K3)
          END DO
          DO L = 1,I-2
            K3 = SB(L)
            CRIT = CRIT - A(K2,K3)
          END DO
          DO L = I+1,N
            K3 = SB(L)
            CRIT = CRIT - A(K,K3)
          END DO
          DO L = 1,I-1
            K3 = SB(L)
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
        SOLS(III) = ZBEST
        SOLS2(III) = ZLOSS
        RMED(III) = ZLOSS
        ZSUM = ZSUM + ZLOSS
        IF(ZLOSS.LT.ZMIN) THEN
          ZMIN = ZLOSS
          DO I = 1,N
            GB(I) = SB(I)
          END DO
        END IF
        IF(ZLOSS.GT.ZMAX) ZMAX = ZLOSS
        WRITE(*,77) iii,zbest,zloss,zloss/znorm
        WRITE(2,77) iii,zbest,zloss,zloss/znorm
 1000 CONTINUE
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
      WRITE(3,*) N
      DO I = 1,N
        WRITE(3,*) I,GB(I)
      END DO
      WRITE(2,*)
      WRITE(*,*)
      WRITE(2,201)
      WRITE(*,201)
      WRITE(2,202) ZMIN, ZSUM, RMN, ZMAX,ATTR,TIMTOT/20.
      WRITE(*,202) ZMIN, ZSUM, RMN, ZMAX,ATTR,TIMTOT/20.
      WRITE(2,203) ZMIN/ZNORM, ZSUM/ZNORM, RMN/ZNORM, ZMAX/ZNORM
      WRITE(4,204) ZMIN/ZNORM, ZSUM/ZNORM, RMN/ZNORM, ZMAX/ZNORM, ATTR,
     1             TIMTOT/20.
      WRITE(*,203) ZMIN/ZNORM, ZSUM/ZNORM, RMN/ZNORM, ZMAX/ZNORM
  177 FORMAT(2X,'REP',4X,'DEFAYS CRIT',2X,'L2 LOSS VALUE')
   77 format(I5,2f15.4,f12.8)
  200 FORMAT(I3,2F20.6)
  201 FORMAT(9X,'MIN',11X,'AVG',11X,'MED',10X,'MAX',5X,'ATT',3X,'TIME')
  202 FORMAT(4F14.4,F5.0,F7.2)
  203 FORMAT(4F14.8)
  204 FORMAT(4F14.8,F5.0,F7.2)
  889 continue
      END
