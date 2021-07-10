#   Source: problem 7 (p. 102) in
#   A.R. Buckley,
#   "Test functions for unconstrained minimization",
#   TR 1989CS-3, Mathematics, statistics and computing centre,
#   Dalhousie University, Halifax (CDN), 1989.
#
#   Problem from CUTE: https://github.com/mpf/Optimization-Test-Problems/blob/master/cute/zangwil2.mod
#
#   classification  QUR2-AN-2-0
#
# R. O. Domingues, Paraná 10/2019.

export zangwil2

"Zangwil2 Model"
function zangwil2(args...)

    nlp = Model()

    x0 = [3.0, 8.0]

    @variable(nlp, x[i=1:2], start=x0[i])

    @NLobjective(
      nlp,
      Min,
      (1 / 15) * (16 * (x[1]^2 + x[2]^2) - 8 * x[1] * (x[2] + 7) - 256 * x[2] + 991)
    )

    return nlp
end