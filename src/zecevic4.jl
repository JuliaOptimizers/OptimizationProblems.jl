#   Source:  problem 4 in
#	  A. Zecevic, "Contribution to methods
#   of external penalty functions - algorithm MNBS"
#   Advanced Business School, Belgrade,
#   (whatever is left of) Yugoslavia.
#
#   SIF input: Nick Gould, April 1993.
#
#   classification QQR2-AN-2-2
#
# R. O. Domingues, Paraná 10/2019.

export zecevic4

"Zecevic4 Model"
function zecevic4(args...)

    nlp = Model()

    x0 = [0.1, -0.1]

    @variable(nlp, x[i=1:2], start=x0[i])

    @NLobjective(
      nlp,
      Min,
      6 * x[1]^2 + x[2]^2 - 60 * x[1] - 8 * x[2] + 166
    )

    @NLconstraint(
      nlp,
      constr1,
      x[1] * x[2] - x[1] - x[2] <= 0
    )

    @NLconstraint(
      nlp,
      constr2,
      -x[1] - x[2] <= -3.0
    )

    @NLconstraint(
      nlp,
      constr3,
      0 <= x[1] <= 10
    )

    @NLconstraint(
      nlp,
      constr4,
      0 <= x[2] <= 10
    )

    return nlp
end