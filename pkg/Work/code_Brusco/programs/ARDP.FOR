      PROGRAM DPAR
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)
      DOUBLE PRECISION X(250,250), D(250,250), R1(80000), R2(80000), 
     1                 A(20,20), B(20,20), TIMEA, TIMEB
      INTEGER P(250),Q(20), R(20)
      CHARACTER JNK$
      OPEN(1, FILE = 'DATASET')  ! SYMMETRIC DISSIMILARITY MATRIX
      OPEN(2, FILE = 'PERMUT')   ! INITIAL PERMUTATION
C      OPEN(3, FILE = 'RUNCNT')
      OPEN(4, FILE = 'FINPERM')  ! FINAL PERMUTATION
C      READ(3,*) IPROB
      READ(1,*) N
      READ(1,*) JNK$
      READ(1,*) ((X(I,J),J=1,N),I=1,N)    ! FULL DATA MATRIX
C      READ(2,*) (P(I),I=1,N)              ! INITIAL PERMUTATION
C      DO K = 1,IPROB
        READ(2,*) IK
        DO I = 1,IK
          READ(2,*) IJNK,P(I)
        END DO
C      END DO
C      REWIND 3
C      WRITE(3,*) IPROB + 1
      CALL GETTIM (IHR, IMIN, ISEC, I100)
      CALL GETDAT (IYR, IMON, IDAY)
      TIMEA=DFLOAT(86400*IDAY+3600*IHR+60*IMIN+ISEC)+DFLOAT(I100)/100.
      DO I = 1,N-1
        DO J = I+1,N
          ICT = ICT + 1
          D(I,J) = DFLOAT(J-I)
          D(J,I) = D(I,J)
          R1(ICT) = D(I,J)
          R2(ICT) = X(I,J)
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
      NMAX = 15                           ! MAX OBJ SIZE
C
 1750 ITRIG = 0
      DO II = 1,N-NMAX+1                  ! FOR ALL BLOCKS SIZE NMAX
        DO I = II,II+NMAX-1
          DO J = II,II+NMAX-1
            I1 = P(I)                     ! A IS SUBMATRIX FOR DP
            J1 = P(J)
            A(I-II+1,J-II+1) = X(I1,J1)
          END DO
        END DO
        DO I = 1,NMAX
          DO J = 1,NMAX
            B(I,J) = 0.0D0                ! EXTERNAL CONTIBUTION OF
          END DO                          ! PUTTING OBJECT I IN
        END DO                            ! POSITION J
        DO I = II,II+NMAX-1               ! OBJECT TO BE TESTED
          I1 = P(I)                       ! IN DIFF POSITIONS
          DO J = II,II+NMAX-1             ! POSITION TO BE TESTED
            DO K = 1,II-1                 ! LEFT EXTERNALS
             K1 = P(K)
             B(I-II+1,J-II+1) = B(I-II+1,J-II+1) + X(I1,K1)*DFLOAT(J-K)
            END DO
            DO K = II+NMAX,N              ! RIGHT EXTERNALS
             K1 = P(K)
             B(I-II+1,J-II+1) = B(I-II+1,J-II+1) + X(I1,K1)*DFLOAT(K-J)
            END DO
          END DO
        END DO
        DO I = II,II+NMAX-1
          I1 = P(I)
          R(I-II+1) = I1                  ! PERMUTATION OF BLOCK
        END DO
        CALL DP(A,  B, NMAX, Q)
C        WRITE(*,24) (Q(I),I=1,NMAX)
        DO I = II,II+NMAX-1
          P(I) = R(Q(I-II+1))                 ! UPDATE PERM
        END DO
        DO I = 1,NMAX
          IF(Q(I).NE.I) ITRIG = 1
        END DO
      END DO
      IF(ITRIG.EQ.1) GO TO 1750
      ZLOSS = 0.0D0
      DO I = 1,N-1
        I1 = P(I)
        DO J = I+1,N
          J1 = P(J)
          ZLOSS = ZLOSS + X(I1,J1)*D(I,J)
        END DO
      END DO
      ZN = ZLOSS/ASUM
      CALL GETTIM (IHR, IMIN, ISEC, I100)
      CALL GETDAT (IYR, IMON, IDAY)
      TIMEB=DFLOAT(86400*IDAY+3600*IHR+60*IMIN+ISEC)+DFLOAT(I100)/100.
      WRITE(*,25) ZLOSS, ZN, TIMEB-TIMEA
      WRITE(4,*) N
      DO I = 1,N
        WRITE(4,*) I,P(I)
      END DO
C      write(*,24) (p(i),i=1,n)
 25   FORMAT(F15.5,F12.8,F7.2)
 24   FORMAT(15I4)
 889  continue
      END

      SUBROUTINE DP(A, B, N, IPERM)
      IMPLICIT INTEGER(A-Z)
      DOUBLE PRECISION A(20,20),U(2000000),SUM,
     1                 B(20, 20),TEMP,SL(20)
      INTEGER V(2000000),S(20),SCOMP(20),IPERM(20)
C
C #####################################################################
C                    DYNAMIC PROGRAMMING ALGORITHM
C  OBJECTIVE: MAXIMIZE THE DEFAYS CRITERION
C #####################################################################
C
      NSUM = 2**N - 1
      DO I = 1,NSUM
        U(I) = 0.0D0 ! -9.9D+12
      END DO
      DO I = 1,N
        INDEX = 2**(I-1)
        V(INDEX) = I
        U(INDEX) = B(I,1)  ! (B(I)-2*SL(I))**2     ! B(I)**2
      END DO
C
      MTC = 0
      DO 70 K = 1,N-1
        NFIRST = 0
        IF(MTC.EQ.0) THEN
          M2 = 0
          DO J = 1,K
            S(J) = M2 + J
          END DO
          IF(S(1).NE.N-K+1) MTC = 1
        END IF
 
 75     IF(MTC.EQ.0) GO TO 70
        IF(NFIRST.EQ.1) THEN
          IF(M2.LT.N-NH) NH = 0
          NH = NH + 1
          M2 = S(K+1-NH)
          DO J = 1,NH
            S(K+J-NH) = M2 + J
          END DO
          MTC = 1
          IF(S(1).EQ.N-K+1) MTC = 0
        END IF
        IF(NFIRST.EQ.0) NFIRST = 1
        INDEX = 0
        DO I = 1,K
          INDEX = INDEX + 2**(S(I)-1)
        END DO 
C      
        JJ = 1
        DO I = 1,N
          SCOMP(I) = 0
        END DO
        IDX = 0
        DO 76 I = 1,N
          DO J = 1,K
            IF(I.EQ.S(J)) GO TO 76
          END DO
          IDX = IDX + 1
          SCOMP(IDX) = I
 76     CONTINUE
C
        NK = N - K
        DO JJ = 1,NK
          J1 = SCOMP(JJ)
          SUM = B(J1,K+1)      ! SUM = 0.0D0 -- MODIFIED
          DO KK = 1,NK       ! ADDED
            K1 = SCOMP(KK)   ! ADDED
            DO I = 1,K
              I1 = S(I)
              SUM = SUM + A(K1,I1)   ! MODIFIED
            END DO           ! ADDED      
          END DO             ! ADDED
          TEMP = SUM  !(B(J1)-2*(SUM+SL(J1)))**2   
          TEMP = TEMP + U(INDEX) 
          IDXTMP = INDEX + 2**(J1-1)
          IF(TEMP.GT.U(IDXTMP)) THEN
            U(IDXTMP) = TEMP
            V(IDXTMP) = J1
          END IF
        END DO
        GO TO 75
  70  CONTINUE
C
      IPERM(N) = V(NSUM)
      INDEX = NSUM
      LASTIN = IPERM(N)
      DO I = 1,N-1
        INDEX = INDEX - (2**(LASTIN-1))
        LASTIN = V(INDEX)
        IPERM(N-I) = LASTIN
      END DO
C
C      WRITE(*,80) U(NSUM)
C      WRITE(*,81) TIMTOT
C      WRITE(*,82) (IPERM(I),I=1,N)
C      WRITE(2,80) U(NSUM)
C      WRITE(2,81) TIMTOT
C      WRITE(2,82) (IPERM(I),I=1,N)
C 80   FORMAT(' OPTIMAL DOMINANCE INDEX  ',F15.5)
C 81   FORMAT(' TOTAL CPU TIME (SECONDS) ',7X,F8.2)
C 82   FORMAT(30I3)
      END
