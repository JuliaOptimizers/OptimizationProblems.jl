# A one dimensional optimization problem
#
# Problem 6 in
# http://infinity77.net/global_optimization/test_functions_1d.html#d-test-functions
# Andrea Gavana
#
# S. Goyette, Sherbrooke 2016/2017

export AMPGO06

"Univariate multimodal minimization problem AMPGO06"
function AMPGO06(args...)
  nlp = Model()

  @variable(nlp, x, start=-10.0)

  @NLobjective(
    nlp,
    Min,
    -(x + sin(x)) * exp(-x^2)
  )

  return nlp
end

AMPGO06_meta = Dict(
  :nvar => 1,
  :variable_size => false,
  :x0 => [-10.0],
  :ncon => 0,
  :variable_con_size => false,
  :y0 => Float64[],
  :nnzo => 1,
  :nnzh => 1,
  :nnzj => 0,
  :minimize => true,
  :name => "AMPGO06",
  :global_solution => [NaN],
  :local_solution => (),
  :optimal_value => NaN,
  :has_multiple_solution => missing,
  :is_infeasible => false,
  :objtype => :other,
  :contype => :unconstrained,
  :origin => :academic,
  :deriv => typemax(UInt8),
  :not_everywhere_defined => missing,
  :has_cvx_obj => false,
  :has_cvx_con => false,
  :has_equalities_only => false,
  :has_inequalities_only => false,
  :has_bounds => false,
  :has_fixed_variables => false,
  :cqs => UInt8(0),
)
