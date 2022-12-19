using DifferentialEquations
using SpecialFunctions: gamma

# Now using two separate functions to handle constant and variable Sᵣ cases.
# The benefit of this is a slight benefit in terms of speed. The check for 
# Sᵣ being a function is now performed before generating the ODEProblem.

export monod_memory_n!, monod_memory_n_var!

"""
    monod_memory_n!(du, u, p, t)

ODE function for the Monod Memory Model. This case is for Sᵣ (the nutrient source)
being constant. 

The parameters can be either vectors of length number of taxa in the system or 
numbers. The use of broadcasting allows for this.

This can be run for any number ≥ 1 of taxa and a single resource.
"""
function monod_memory_n!(du, u, p, t)
    # Unpack (use splat operator on X to extract as vector)
    R, X... = u
    # μₘₐₓ, K, α, Vₘₐₓ, M are vectors
    μₘₐₓ, K, α, Vₘₐₓ, M, Sᵣ = p

    # To solve problem of R going slightly below zero
    R = (R + abs(R)) / 2

    # Source/Sink terms
    gamms = gamma.(1 .+ α)
    Rterm = R ./ (K .+ R)
    μ = (μₘₐₓ ./ gamms) .* Rterm .^ α
    ρ = Vₘₐₓ .* Rterm .* X

    # Update du
    du[1] = Sᵣ - sum(ρ)
    du[2:end] = (μ .- M) .* X

    return du
end;


"""
    monod_memory_n_var!(du, u, p, t)

ODE function for the Monod Memory Model. This case is for Sᵣ (the nutrient source)
being a function of time.

The parameters can be either vectors of length number of taxa in the system or 
numbers. The use of broadcasting allows for this.

This can be run for any number ≥ 1 of taxa and a single resource.
"""
function monod_memory_n_var!(du, u, p, t)
    # Unpack (use splat operator on X to extract as vector)
    R, X... = u
    # μₘₐₓ, K, α, Vₘₐₓ, M are vectors
    μₘₐₓ, K, α, Vₘₐₓ, M, Sᵣ = p

    # To solve problem of R going slightly below zero
    R = (R + abs(R)) / 2

    # Source/Sink terms
    gamms = gamma.(1 .+ α)
    Rterm = R ./ (K .+ R)
    μ = (μₘₐₓ ./ gamms) .* Rterm .^ α
    ρ = Vₘₐₓ .* Rterm .* X

    # Update du
    du[1] = Sᵣ(t) - sum(ρ)
    du[2:end] = (μ .- M) .* X

    return du
end;

