# A one dimensional optimization problem
#
# Problem 2 in
# http://infinity77.net/global_optimization/test_functions_1d.html#d-test-functions
# Andrea Gavana
#
# S. Goyette, Sherbrooke 2016/2017

export AMPGO02

"Univariate multimodal minimization problem AMPGO02"
function AMPGO02(args...)
  nlp = Model()

  @variable(nlp, x, start = 2.7)

  @NLobjective(nlp, Min, sin(x) + sin((10.0 / 3.0) * x))

  return nlp
end

AMPGO02_meta = Dict(
  :nvar => 1,
  :variable_size => false,
  :x0 => [2.7],
  :ncon => 0,
  :variable_con_size => false,
  :y0 => zeros(0),
  :nnzo => 1,
  :nnzh => 1,
  :nnzj => 0,
  :minimize => true,
  :name => "AMPGO02",
  :global_solution => NaN*ones(1),
  :local_solution => (),
  :optimal_value => NaN,
  :has_multiple_solution => missing,
  :is_infeasible => false,
  :objtype => :other,
  :contype => :unconstrained,
  :origin => :academic,
  :deriv => typemax(UInt8),
  :not_everywhere_defined => false,
  :has_cvx_obj => false,
  :has_cvx_con => true,
  :has_equalities_only => false,
  :has_inequalities_only => false,
  :has_bounds => false,
  :has_fixed_variables => false,
  :cqs => UInt8(4),
)
