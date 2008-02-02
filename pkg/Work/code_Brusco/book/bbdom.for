      PROGRAM DOMINAN
      IMPLICIT INTEGER(A-Z)
      DOUBLE PRECISION TIMEA,TIMEB,TIMTOT,A(100,100),EPS,Z,ZBD,
     1               RDX1,RDX2,DTARG,DELTA,Z1,Z2,B(100,100),C(100,100),
     1               ZBEST,D(50,50,50),E(50,50)
      REAL S1
      INTEGER X(100),Q(100),S(100),SB(100),U(100)
C
C ######################################################################
C 9/27/03 This program uses branch-and-bound to find a reordering of the
C         rows and columns of an asymmetric proximity matrix so as to
C         maximize the sum above the main diagonal (DOMINANCE INDEX).
C ##################################################################
C
      OPEN(1,FILE='ASYM.DAT')
      OPEN(2,FILE='ASYM.OUT')
      EPS=1.0D-06
      READ(1,*) N                              ! Read number of objects
      DO I = 1,N
        READ(1,*) (A(I,J),J=1,N)               ! Read proximity matrix
      END DO
C
      CALL GETTIM (IHR, IMIN, ISEC, I100)
      CALL GETDAT (IYR, IMON, IDAY)
      TIMEA=DFLOAT(86400*IDAY+3600*IHR+60*IMIN+ISEC)+DFLOAT(I100)/100.
C
      ZBEST=0.
      DO III = 1,100                ! Use 100 replications of pairwise
        DO I = 1,N                  ! interchange to get an initial
          U(I)=I                    ! upper bound as well as a reorder
          S(I)=0                    ! of the raw data.
        END DO                      ! S(I) = object in position I
        DO I = N,1,-1               ! U vector contains unselected
          CALL RANDOM(S1)           ! objects.
          I1=FLOAT(I)*S1+1.         ! ZBEST is the best-found dominance
          IF(I1.GT.I) I1=I          ! index across the 100 reps.
          S(I)=U(I1)
          DO L = I1,N-1
            U(L)=U(L+1)
          END DO
        END DO
C
        Z=0.                        ! Calculate the sum above the main
        DO I = 1,N-1                ! diagonal, Z, for the initial
          DO J = I+1,N              ! permutation.
            Z=Z+A(S(I),S(J))
          END DO
        END DO
 5000   DTARG=EPS                   ! Begin the pairwise interchange
        DO I = 1,N-1                ! algorithm here
          DO J = I+1,N             
            R1=S(I)
            R2=S(J)
            DELTA=A(R2,R1)-A(R1,R2)
            DO K = I+1,J-1
              R3=S(K)
              DELTA=DELTA-A(R1,R3)+A(R2,R3)+A(R3,R1)-A(R3,R2)
            END DO
            IF(DELTA.GT.DTARG) THEN
              DTARG=DELTA
              ISEL=I
              JSEL=J
             END IF
          END DO
        END DO
        IF(DTARG.GT.EPS+EPS) THEN   ! Loop as long as improvement
          Z=Z+DTARG                 ! is found.
          JDUM=S(JSEL)
          S(JSEL)=S(ISEL)
          S(ISEL)=JDUM
          GO TO 5000
        END IF
        IF(Z.GT.ZBEST) THEN
          ZBEST=Z
          DO I = 1,N
            SB(I)=S(I)              ! SB will contain the actual reorder
          END DO                    ! of the raw data and will be used
        END IF                      ! again at the end to remap the
      end do                        ! object labels.
      Z=ZBEST-1
      DO I = 1,N
        S(I)=SB(I)
      END DO
      DO I = 1,N
        DO J = 1,N
          C(I,J)=A(S(I),S(J))
        END DO
      END DO
      DO I = 1,N
        DO J = 1,N
          A(I,J)=C(I,J)
        END DO
      END DO
      DO I = 1,N-1             ! B(I,J) is used for bound computation
        DO J = I+1,N              
          B(I,J)=A(I,J)
          IF(A(J,I).GT.B(I,J)) B(I,J)=A(J,I)
        END DO
      END DO
      DO 41 I = 1,N
        DO 42 J = 1,N
          IF(I.EQ.J) GO TO 42
          DO 43 K = 1,N
            IF(I.EQ.K.OR.J.EQ.K) GO TO 43
            D(I,J,K) = A(K,J)+A(J,I)-A(I,J)-A(J,K)
 43       CONTINUE
 42     CONTINUE
 41   CONTINUE
      DO 44 I = 1,N
        S(I)=0
        DO 45 J = 1,N
          IF(I.EQ.J) GO TO 45
          E(I,J) = A(I,J)-A(J,I)
 45     CONTINUE
 44   CONTINUE
C
C ######## BEGIN THE BRANCH-AND-BOUND ALGORITHM HERE ########
C
      M=1                      ! Pointer for sequence position
      Q(M)=1                   ! Object 1 in position M
      S(1)=1                   ! Object 1 is assigned
      Z1=0.
      DO K = 2,N
        Q(K)=0
        Z1=Z1+A(1,K)
      END DO
C
  1   M = M + 1                ! Advance pointer
C
  2   Q(M)=Q(M)+1              ! Increment object in position M
C
      IF(S(Q(M)).EQ.1) GO TO 2               ! REDUNDANCY
      IF(M.EQ.1.AND.Q(M).GT.N) GO TO 9       ! TERMINATE
      IF(M.GT.1.AND.Q(M).GT.N) GO TO 7       ! GO TO RETRACTION
      S(Q(M))=1
 22   IF(M.EQ.1) THEN               ! If object 1, then assign
        Z1=0.
        DO 24 J = 1,N
          IF(J.EQ.Q(M)) GO TO 24
          Z1=Z1+A(Q(M),J)
 24     CONTINUE
        GO TO 1
      END IF
      IF(M.EQ.N-1) THEN             ! If the sequence is complete,
        CALL EVAL(ZBD,Q,N,A)        ! call EVAL to assess the
        IF(ZBD.GT.Z) THEN           ! objective value for the
          Z=ZBD                     ! completed sequence
          write(*,*) z
          DO I = 1,N
            X(I)=Q(I)
          END DO
        END IF
        Q(N)=0
        S(Q(M))=0
        GO TO 2
      ELSE                         ! Otherwise Perform Tests
        R3=Q(M)
        R2=Q(M-1)
        IF(A(R3,R2).GT.A(R2,R3)) THEN   ! Adjacency Test
          S(Q(M))=0
          GO TO 2                       ! Prune if test fails
        END IF
        IF(A(R3,R2).EQ.A(R2,R3).AND.R3.LT.R2) THEN   ! Adjacency Test
          S(Q(M))=0
          GO TO 2                       ! Prune if test fails
        END IF
C        GO TO 154
        DO 152 MM = M-2,1,-1            ! INSERTION Test for
          RDX1=0.0D0                    ! with objects in positions
          DO I = MM,M-1
            R1=Q(I)
            RDX1=RDX1+E(R1,R3)
          END DO
          IF(RDX1.LT.-EPS) THEN         ! Prune if test fails
            S(Q(M))=0
            GO TO 2
          END IF
 152    CONTINUE
        GO TO 155
 154    DO 151 MM = M-2,1,-1            ! Interchange Test for
          R2=Q(MM)                      ! the object in poisition M
          RDX1=0.0D0                    ! with objects in positions
          DO I = MM+1,M-1
            R1=Q(I)
            RDX1=RDX1+D(R2,R1,R3)
          END DO
          RDX1=RDX1+A(R3,R2)-A(R2,R3)
          IF(RDX1.GT.EPS) THEN         ! Prune if test fails
            S(Q(M))=0
            GO TO 2
          END IF
 151    CONTINUE
 155    CALL BOUND2(ZBD,N,Q,M,S,A,Z1,Z2,B)   ! BOUND TEST
        IF(ZBD.LE.Z) THEN
          S(Q(M))=0
          GO TO 2                       ! Prune if test fails
        END IF
        Z1=Z1+Z2                        ! Branch further into tree
        GO TO 1                         ! if all tests pass.
      END IF
C
   7  S(Q(M))=0                         ! DEPTH RETRACTION
      Q(M)=0
      M=M-1                             ! Backup in the sequence
      R1=Q(M)
      DO 65 J = 1,N
        IF(S(J).EQ.1) GO TO 65
        Z1=Z1-A(R1,J)
 65   CONTINUE
      S(Q(M))=0
      GO TO 2
   9  CALL GETTIM (IHR, IMIN, ISEC, I100)
      CALL GETDAT (IYR, IMON, IDAY)
      TIMEB=DFLOAT(86400*IDAY+3600*IHR+60*IMIN+ISEC)+DFLOAT(I100)/100.
      TIMTOT=TIMEB-TIMEA
      WRITE(*,69) Z,TIMTOT
      WRITE(2,69) Z,TIMTOT
      WRITE(2,70) (SB(X(I)),I=1,N)
 69   FORMAT(' MAXIMUM DOMINANCE INDEX ',F14.4,' CPU TIME ',F8.2)
 70   FORMAT(30I3)
C
      END
C
      SUBROUTINE BOUND2(ZBD,N,Q,M,S,A,Z1,Z2,B)
      IMPLICIT INTEGER(A-Z)
      DOUBLE PRECISION A(100,100),ZBD,Z1,Z2,Z3,B(100,100)
      INTEGER Q(100),S(100)
      Z2=0.0D0
      R1=Q(M)
      DO 60 J = 1,N
        IF(S(J).EQ.1) GO TO 60
        Z2=Z2+A(R1,J)
 60   CONTINUE
C
      Z3=0.
      DO 61 I = 1,N-1
        IF(S(I).EQ.1) GO TO 61
        DO 62 J = I+1,N
          IF(S(J).EQ.1) GO TO 62
          Z3=Z3+B(I,J)
 62     CONTINUE
 61   CONTINUE
      ZBD=Z1+Z2+Z3
      RETURN
      END
C
      SUBROUTINE EVAL(ZBD,Q,N,A)
      IMPLICIT INTEGER(A-Z)
      DOUBLE PRECISION A(100,100),ZBD
      INTEGER Q(100)
      ZBD=0.0D0
      DO 85 I = 1,N
        DO J = 1,N-1
          IF(Q(J).EQ.I) GO TO 85
        END DO
        Q(N)=I
 85   CONTINUE
      DO I = 1,N-1
        R1=Q(I)
        DO J = I+1,N
          R2=Q(J)
          ZBD=ZBD+A(R1,R2)
        END DO
      END DO
      RETURN
      END
