#   Source:
#   Zhengua Lina and Yong Li,
#   "A Modified Scaling Newton-Type Method for Nonlinear Programming"
#   Department of Mathematics, Jilin University, Changchun, China, 1994.
#
#   SIF input: Ph. Toint, January 1994.
#
#   classification OQR2-AN-3-2
#
# R. O. Domingues, Paraná 10/2019.

export zy2

"Zy2 Model"
function zy2(args...)

    nlp = Model()

    x0   = [0.1, 0.1, 3.0]
    uvar = [+Inf, +Inf, 5.0]

    @variable(nlp, 0 <= x[i=1:3] <= uvar[i], start=x0[i])

    @NLobjective(
      nlp,
      Min,
      x[1]^3 - 6*x[1]^2 + 11 * x[1] + x[2] + x[3]
    )

    @NLconstraint(
      nlp,
      constr1,
      4 <= x[1]^2 + x[2]^2 + x[3]^2 <= 10
    )

    return nlp
end