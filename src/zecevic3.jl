#   Source:  problem 3 in
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

export zecevic3

"Zecevic3 Model"
function zecevic3(args...)

    nlp = Model()

    x0 = [0.1, -0.1]

    @variable(nlp, x[i=1:2], start=x0[i])

    @NLobjective(
      nlp,
      Min,
      7 * x[1]^2 + 3 * x[2]^2 - 84 * x[1] - 24 * x[2] + 300
    )

    @NLconstraint(
      nlp,
      constr1,
      -x[1] * x[2] <= -1.0
    )

    @NLconstraint(
      nlp,
      constr2,
      x[1]^2 + x[2]^2 <= 9.0
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