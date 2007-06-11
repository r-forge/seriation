      PROGRAM SANNEAL
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)
      DOUBLE PRECISION A(400,400), B(400,400), SOLS(100), RMED(100)
      REAL S1,RCRIT
      INTEGER U(400), S(400), UNSEL, T(100,400), SB(400), Q, GB(400)
C
C ####################################################################
C  SADOM.FOR IS A DISCRETE SIMULATED ANNEALING CODE FOR SERIATION
C      OF ASYMMETRIC MATRICES BASED ON THE DOMINANCE INDEX. THE CODE
C      USES PAIRWISE INTERCHANGE AND SINGLE-OBJECT INSERTIONS TO
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
C      OPEN(4, FILE = 'RULE')
      CALL GETTIM (IHR, IMIN, ISEC, I100)
      CALL GETDAT (IYR, IMON, IDAY)  
      TIMEA = DFLOAT(86400*IDAY+3600*IHR+60*IMIN+ISEC)+DFLOAT(I100)/100.  
C      READ(4,*) RULE     ! .5 = BOTH, -.5 = INSERTION, 1.5 = INTERCHANGE
      RULE = .5
      READ(1,*)
      READ(1,*) N
      READ(1,*) ((A(I,J),J=1,N),I=1,N)
      ASUM = 0.0D0
      DO I = 1,N-1
        DO J = I+1,N
          B(I,J)=A(J,I)-A(I,J)
          B(J,I)=A(I,J)-A(J,I)
          ASUM = ASUM + A(I,J) + A(J,I)
        END DO
      END DO
      EPS = 1.0D-08
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
      ZMIN = 9.9D+20
      ZAVG = 0.
      ZMAX = 0.
      DO 1000 III = 1,NREPS
        DO I = 1,N
          S(I) = T(III,I)
        END DO
        Z = 0.0D0
        DO I = 1,N-1
          K = S(I)
          DO J = 1+I,N
            L = S(J)
            Z = Z + A(K,L)
          END DO
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
          DELTA=B(K,M)
          DO L = I1+1,J1-1
            Q = S(L)
             DELTA = DELTA + B(K,Q) + B(Q,M)
          END DO
          IF(DELTA.LT.0) THEN
            IF(ABS(DELTA).GT.TMAX) TMAX = ABS(DELTA)
          END IF
        END DO
        COOL = .95
        TMIN = .05d0
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
            IF(S1.LE.RULE) THEN     ! INTERCHANGE / INSERTION / OR BOTH
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
            DELTA=B(K,M)
            DO L = I1+1,J1-1
              Q = S(L)
              DELTA = DELTA + B(K,Q) + B(Q,M)
            END DO
            IF(DELTA.GT.-EPS) THEN
              Z = Z + DELTA
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
            IF(J1.GT.I1) THEN
              DO L = I1+1,J1
                Q = S(L)
                DELTA = DELTA + B(K,Q)
              END DO
            ELSE
              DO L = I1-1,J1,-1
                Q = S(L)
                DELTA = DELTA + B(Q,K)
              END DO 
            END IF  
            IF(DELTA.GT.-EPS) THEN
              Z = Z + DELTA
              IF(J1.GT.I1) THEN
                DO L = I1,J1-1
                  S(L)=S(L+1)
                END DO
                S(J1) = K
              ELSE
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
                IF(J1.GT.I1) THEN
                  DO L = I1,J1-1
                    S(L)=S(L+1)
                  END DO
                  S(J1) = K
                ELSE
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
C        DO I = 1,N
C          WRITE(3,*) SB(I)
C        END DO
        SOLS(III) = ZBEST
        RMED(III) = ZBEST
        ZSUM = ZSUM + ZBEST
        IF(ZBEST.LT.ZMIN) ZMIN = ZBEST
        IF(ZBEST.GT.ZMAX) THEN
          ZMAX = ZBEST
          DO I = 1,N
            GB(I) = SB(I)
          END DO
        END IF
        WRITE(*,77) iii,zbest
 1000 CONTINUE
      CALL GETTIM (IHR, IMIN, ISEC, I100)  
      CALL GETDAT (IYR, IMON, IDAY)  
      TIMEB = DFLOAT(86400*IDAY+3600*IHR+60*IMIN+ISEC)+DFLOAT(I100)/100.  
      TIMTOT = TIMEB - TIMEA
      ZSUM = ZSUM/DFLOAT(NREPS)
C      TIMTOT = TIMTOT / DFLOAT(NREPS)
      IBEST = 0
      DO I = 1,NREPS
        IF(SOLS(I).GT.ZMAX-1) IBEST = IBEST + 1
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
C      WRITE(2,201)
C      WRITE(*,201)
C      WRITE(2,202) ZMIN, ZSUM, RMN, ZMAX,ATTR,TIMTOT
C      WRITE(*,202) ZMIN, ZSUM, RMN, ZMAX,ATTR,TIMTOT
      WRITE(2,203) ZMAX,ZMAX/ASUM,ATTR,TIMTOT/20.
      WRITE(*,203) ZMAX,ZMAX/ASUM,ATTR,TIMTOT/20.
   77 format(I5,f15.4)
  200 FORMAT(I3,2F20.6)
  201 FORMAT(9X,'MIN',11X,'AVG',11X,'MED',10X,'MAX',5X,'ATT',3X,'TIME')
  202 FORMAT(4F18.2,F5.0,F7.2)
  203 FORMAT(F20.4,F11.8,F5.0,F7.2)
  889 continue
      END


