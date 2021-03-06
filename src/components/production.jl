abstract type AbstractProduction end

@columns struct Production{MoMo,MoMoD,GMo} <: AbstractProduction
    # Field        | Default | Unit            | Pror            | Limits      | Log | Description
    y_P_V::MoMo    | 0.02    | mol*mol^-1      | Beta(2.0, 2.0)  | [0.0,1.0]   | _   | "Product formation linked to growth"
    j_P_mai::MoMoD | 0.001   | mol*mol^-1*d^-1 | Beta(2.0, 2.0)  | [0.0,0.1]   | _   | "Product formation linked to maintenance"
    n_N_P::MoMo    | 0.1     | mol*mol^-1      | Gamma(2.0, 2.0) | [0.0, 1.0]  | _   | "N/C in product (wood)"
    w_P::GMo       | 25.0    | g*mol^-1        | Gamma(2.0, 2.0) | [10.0, 40.0]| _   | "Mol-weight of shoot product (wood)"
end                                                                                        

growth_production!(o, growth) = growth_production!(production_pars(o), o, growth)
growth_production!(p::Production, o, growth) = flux(o)[:P,:gro] = growth * p.y_P_V
growth_production!(p, o, growth) = zero(growth)

maintenance_production!(o, u) = maintenance_production!(production_pars(o), o, u)
maintenance_production!(p::Production, o, u) = flux(o)[:P,:mai] = p.j_P_mai * tempcorrection(o) * u.V
maintenance_production!(p, o, u) = zero(eltype(flux(o)))
