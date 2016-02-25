#   Source: setting the boundary free in 
#   A Griewank and Ph. Toint,
#   "Partitioned variable metric updates for large structured
#   optimization problems",
#   Numerische Mathematik 39:429-448, 1982.

#   SIF input: Ph. Toint, November 1991.

#   classification OUR2-MY-V-0
 
#   Problem 33 in   
#   L. Luksan, C. Matonoha and J. Vlcek  
#   Modified CUTE problems for sparse unconstrained optimization,
#   Technical Report 1081,
#   Institute of Computer Science,
#   Academy of Science of the Czech Republic
#
#   http://www.cs.cas.cz/matonoha/download/V1081.pdf
# J.-P. Dussault, Rennes 09/2015.

function fminsrf2(n :: Int = 100)

    (int(sqrt(n))*sqrt(n)) != n && error("fminsrf2: number of variables must be square")

    p = int(sqrt(n))

    h00 = 1.0
    slopej = 4.0
    slopei = 8.0

    scale = (p-1)^2

    ston = slopei/(p-1)
    wtoe = slopej/(p-1)
    h01 = h00+slopej
    h10 = h00+slopei
    mid = div(p, 2)
    
    nlp = Model()

    x0 = zeros(p,p)
    I=2:(p-1)
    J=1:(p)

    x0[I,1] = (I-1)*ston+h01
    x0[I,p] = (I-1)*ston+h00
    x0[1,J] = (J-1)*wtoe+h00
    x0[p,J] = (J-1)*wtoe+h10

    @defVar(nlp, x[i=1:p,j=1:p], start = x0[i,j])

    @setNLObjective(
                    nlp,
                    Min,
	            sum { sum{ 100.0 *
                    sqrt(0.5*(p-1)^2*((x[i,j]-x[i+1,j+1])^2+(x[i+1,j]-x[i,j+1])^2)+1.0)/scale ,
                    i=1:(p-1)} ,
                    j = 1:(p-1)} + 100.0 * (x[mid,mid])^2/n
    )
    return nlp
end

