module OptimizationProblems

using DataFrames, JuMP

path = dirname(@__FILE__)
files = filter(x -> x[(end - 2):end] == ".jl", readdir(path))
for file in files
  if file ≠ "OptimizationProblems.jl"
    include(file)
  end
end

const objtypes = [:none, :constant, :linear, :quadratic, :sum_of_squares, :other]
const contypes = [:unconstrained, :linear, :quadratic, :general]
const origins = [:academic, :modelling, :real, :unknown]
const cqs = Dict(4 => "LICQ", 3 => "MFCQ", 2 => "GCQ", 1 => "none", 0 => "unknown")

const names = [
  :nvar
  :variable_size
  :x0
  :ncon
  :variable_con_size
  :y0
  :nnzo
  :nnzh
  :nnzj
  :minimize
  :name
  :global_solution
  :local_solution
  :optimal_value
  :has_multiple_solution
  :is_infeasible
  :objtype
  :contype
  :origin
  :deriv
  :not_everywhere_defined
  :has_cvx_obj
  :has_cvx_con
  :has_equalities_only
  :has_inequalities_only
  :has_bounds
  :has_fixed_variables
  :cqs
]

const types = [
  Int
  Bool
  Vector
  Int
  Bool
  Vector
  Int
  Int
  Int
  Bool
  String
  Vector
  Tuple
  Real
  Union{Bool, Missing}
  Union{Bool, Missing}
  Symbol
  Symbol
  Symbol
  UInt8
  Union{Bool, Missing}
  Bool
  Bool
  Bool
  Bool
  Bool
  Bool
  UInt8
]

const number_of_problems = length(files)

"""
    OptimizationProblems.meta

A composite type that represents the main features of the optimization problem.

    optimize    obj(x)
    subject to  lvar ≤    x    ≤ uvar
                lcon ≤ cons(x) ≤ ucon

---

The following keys are valid:
Problem meta
- `nvar`: number of general constraints
- `variable_size`: true if we can modify problem size
- `x0`: initial guess
- `ncon`: number of general constraints
- `variable_con_size`: true if we can modify problem size
- `y0`: initial Lagrange multipliers
- `nnzo`: number of nonzeros in all objectives gradients
- `nnzh`: number of elements needed to store the nonzeros in the sparse Hessian
- `nnzj`: number of elements needed to store the nonzeros in the sparse Jacobian
- `minimize`: true if optimize == minimize
- `name`: problem name
Solution meta
- `global_solution`: a global solution
- `local_solution`: tuple of local solutions
- `optimalvalue`: best known objective value (NaN if unknown, -Inf if unbounded problem)
- `has_multiple_solution`: true if the problem has more than one global solution
- `is_infeasible`: true if problem is infeasible
Classification
- `objtype`: #in objtypes
- `contype`: #in contypes
- `origin`: #in origins
- `deriv`: UInt8 with the largest order derivatives available
- `not_everywhere_defined`: true if the problem might return NaN or Inf outside the bounds
- `has_cvx_obj`: true if the problem has a convex objective
- `has_cvx_con`: true if the problem has convex constraints
- `has_equalities_only`: true if the problem constraints are equality constraints (doesn't include bounds)
- `has_inequalities_only`: true if the problem constraints are inequality constraints (doesn't include bounds)
- `has_bounds`: true if the problem has bound constraints
- `has_fixed_variables`: true if it has fixed variables
- `cqs`: Between 0 and 4 indicates the constraint qualification of the problem, see `cqs(i)` for the correspondance.
"""
const meta = DataFrame(
  types, 
  names, 
  number_of_problems
)

for i=1:6 # number_of_problems
  OptimizationProblems.meta[i,:] = eval(Meta.parse(first(split(files[i], "."))*"_meta"))
end

using Requires

@init begin
  @require NLPModelsJuMP = "792afdf1-32c1-5681-94e0-d7bf7a5df49e" begin
    """
        `generate_meta(jmodel, name, variable_size, variable_con_size, cvx_obj, cvx_con, quad_cons)`   
        `generate_meta(name, variable_size, variable_con_size, cvx_obj, cvx_con, quad_cons)`   

    is used to generate the meta of a given JuMP model.
    """
    function generate_meta(name::String, args...;kwargs...)
      return generate_meta(eval(Meta.parse(name))(), name, args...; kwargs...)
    end

    function generate_meta(
      jmodel::JuMP.Model, 
      name::String, 
      variable_size::Bool=false, 
      variable_con_size::Bool=false,
      cvx_obj::Bool=false,
      cvx_con::Bool=false,
      origin::Symbol=:unknown,
      quad_cons::Bool=false,
      cq::UInt8=UInt8(0),
    )
      nlp = NLPModelsJuMP.MathOptNLPModel(jmodel)
      contype = if quad_cons
        :quadratic
      elseif nlp.meta.ncon == 0 && !(length(nlp.meta.ifree) < nlp.meta.nvar)
        :unconstrained
      elseif nlp.meta.nlin == nlp.meta.ncon > 0
        :linear
      else
        :general
      end
      objtype = :other

      str = "$(name)_meta = Dict(
        :nvar => $(nlp.meta.nvar),
        :variable_size => $(variable_size),
        :x0 => $(nlp.meta.x0),
        :ncon => $(nlp.meta.ncon),
        :variable_con_size => $(variable_con_size),
        :y0 => $(nlp.meta.y0),
        :nnzo => $(nlp.meta.nnzo),
        :nnzh => $(nlp.meta.nnzh),
        :nnzj => $(nlp.meta.nnzj),
        :minimize => $(nlp.meta.minimize),
        :name => $(name),
        :global_solution => $(NaN * ones(nlp.meta.nvar)),
        :local_solution => (),
        :optimal_value => $(NaN),
        :has_multiple_solution => $(missing),
        :is_infeasible => $(nlp.meta.ncon == 0 ? false : missing),
        :objtype => :$(objtype),  
        :contype => :$(contype),
        :origin => :$(origin),
        :deriv => typemax(UInt8),
        :not_everywhere_defined => $(missing),
        :has_cvx_obj => $(cvx_obj),
        :has_cvx_con => $(cvx_con),
        :has_equalities_only => $(length(nlp.meta.jfix) == nlp.meta.ncon > 0),
        :has_inequalities_only => $(nlp.meta.ncon > 0 && length(nlp.meta.jfix) == 0),
        :has_bounds => $(length(nlp.meta.ifree) < nlp.meta.nvar),
        :has_fixed_variables => $(nlp.meta.ifix != []),
        :cqs => $(cq),
      )"
      return str
    end
  end
end

end # module
