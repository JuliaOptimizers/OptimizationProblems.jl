using NLPModelsJuMP, OptimizationProblems, Test

# we trust cvx_obj, cvx_con, origin, cq, not_everywhere_defined and the solution
function test_meta(name::String)
  nlp  = eval(Meta.parse(name))()
  meta = eval(Meta.parse("OptimizationProblems.$(name)_meta"))

  if meta[:variable_size]
    nlp2 = eval(Meta.parse(name))(nlp.meta.nvar+10)
    @test nlp2.meta.nvar != nlp.meta.nvar
    @test meta[:variable_con_size] || nlp.meta.ncon == nlp2.meta.ncon
  end

  # quad_cons is false by default
  str = OptimizationProblems.generate_meta(nlp, name, meta[:variable_size], meta[:variable_con_size], meta[:has_cvx_obj], meta[:has_cvx_con], :academic, false, meta[:cqs])
  gen_meta = eval(Meta.parse(str))
  for sym in [:nvar, :x0, :ncon, :y0, :nnzo, :nnzh, :nnzj, :minimize, :has_equalities_only, :has_inequalities_only, :has_bounds, :has_fixed_variables]
    @test gen_meta[sym] == meta[sym]
  end
  # test objtype, contype, deriv ?

end

# Only 6 are implemented now
test_meta("AMPGO02")
test_meta("AMPGO03")
test_meta("AMPGO04")
test_meta("AMPGO05")
test_meta("AMPGO06")
test_meta("AMPGO07")

# Test that every problem can be instantiated.
for prob in names(OptimizationProblems)
  prob == :OptimizationProblems && continue
  println(prob)
  prob_fn = eval(prob)
  prob_fn()
end
