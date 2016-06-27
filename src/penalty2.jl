# AMPL Model by Hande Y. Benson
#
# Copyright (C) 2001 Princeton University
# All Rights Reserved
#
# Permission to use, copy, modify, and distribute this software and
# its documentation for any purpose and without fee is hereby
# granted, provided that the above copyright notice appear in all
# copies and that the copyright notice and this
# permission notice appear in all supporting documentation.                     

#   Source:  Problem 24 in
#   J.J. Moré, B.S. Garbow and K.E. Hillstrom,
#   "Testing Unconstrained Optimization Software",
#   ACM Transactions on Mathematical Software, vol. 7(1), pp. 17-41, 1981.

#   See also Buckley#112 (p. 80)

#   SIF input: Ph. Toint, Dec 1989.

#   classification SUR2-AN-V-0
# J.-P. Dussault, Clermont-Ferrand 06/2016.

export penalty2

"A penalty problem by Gill, Murray and Pitfield in size 'n' "
function penalty2(n :: Int = 100)

    n < 3 && warn("penalty2: number of variables must be ≥ 3")
    n = max(3,n)

    a = 1.0e-5
    m = 2*n
    y=ones(m)
    for i=1:m   y[i] = exp(i/10.0) + exp((i-1)/10.0); end

    nlp = Model()
    @defVar(nlp, x[i=1:n], start = 1.0/2.0)

    @setNLObjective(
                    nlp,
                    Min,
                    (x[1]-0.2)^2 + sum{a*(exp(x[i]/10.0)+exp(x[i-1]/10.0)-y[i])^2, i=2:n} + 
                    sum{a*(exp(x[i-n+1]/10.0)-exp(-1/10.0))^2, i = n+1:2*n-1} +
                    ( sum{ (n-j+1)*x[j]^2 , j = 1:n} - 1.0)^2;
    )
    return nlp
end

