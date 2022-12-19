using CSV
using DataFrames
using Dates

function parse_output(sol, p::ModelParams, saveoutput::Bool, filename::String)::DataFrame
    ntimes = length(sol.t)
    ntaxa = size(sol, 1) - 1
    ntaxa_magnitude = Int(floor(log10(ntaxa)))
    Sᵣ = p.SR

    result = DataFrame(
        Time=sol.t,
        R=sol[1, :],
    )

    # Add in columns for each taxon
    for i in 1:ntaxa
        # Get taxon pamaeters
        name_suffix = lpad(string(i), ntaxa_magnitude, "0")
        result[!, "X_$(name_suffix)"] = sol[i+1, :]

        μ = extract_param(p, :mu_max, i)
        k = extract_param(p, :K, i)
        a = extract_param(p, :alpha, i)
        v = extract_param(p, :V_max, i)
        m = extract_param(p, :M, i)

        # Add taxon params
        result[!, "mu_max_$(name_suffix)"] = fill(μ, ntimes)
        result[!, "K_$(name_suffix)"] = fill(k, ntimes)
        result[!, "alpha_$(name_suffix)"] = fill(a, ntimes)
        result[!, "V_max_$(name_suffix)"] = fill(v, ntimes)
        result[!, "M_$(name_suffix)"] = fill(m, ntimes)

        # Add taxon status
        result[!, "mu_$(name_suffix)"] = mu.(result.R, a, μ, k)
        result[!, "rho_$(name_suffix)"] = rho.(result.R, v, k)
    end

    if typeof(Sᵣ) <: Function
        result[!, "Resource_In"] = Sᵣ.(result.Time)
    else
        result[!, "Resource_In"] = fill(Sᵣ, ntimes)
    end

    @show first(result, 10)

    # Save output if required
    if saveoutput
        CSV.write(filename, result)
    end

    return result
end