using CairoMakie
using DataFrames
using Dates

export plot_mm_output

"""
    plot_mm_output(result::DataFrame; saveoutput::Bool=false, filename::String="")

Function for plotting output of Monod-Memory Simulation

## Inputs

* `result` - DataFrame containing results from `run_mm`.

### Optional arguments

* `saveoutput::Bool` - Optionally save the figure
* `filename::String` - Filename for saved figure

A filename default is chosen based on current time.

## Details

Plots Resource and Cell Densities as two separate Axis.

Resource andh Cell Density are on log-10 scale.

## Examples

```julia-repl
julia> plot_mm_output(output)
julia> plot_mm_output(output; savefile=true, filename="test.png")
```
"""
function plot_mm_output(result::DataFrame; saveoutput::Bool=false, filename::String="")
    # Generate filename if saving output
    if saveoutput && filename == ""
        filename = "mm_output_$(now).png"
    end

    F = Figure()
    A_R = Axis(F[1, 1], yscale=log10, ylabel="R")
    A_X = Axis(F[2, 1], yscale=log10, ylabel="X", xlabel="Time (days)")

    # Get column names that are taxa
    ntaxa = findall(x -> occursin(r"X_", x), names(result)) |> length
    ntaxa_magnitude = Int(floor(log10(ntaxa)))
    taxa_suffices = [lpad(string(i), ntaxa_magnitude, "0") for i in 1:ntaxa]

    lines!(
        A_R,
        result.Time,
        result.R,
        color=:black,
    )

    # Taxa lines
    for (i, suffix) in enumerate(taxa_suffices)
        taxon = "X_$(suffix)"
        alpha = result[1, "alpha_$(suffix)"]
        mumax = result[1, "mu_max_$(suffix)"]
        lines!(
            A_X,
            result.Time,
            result[:, taxon],
            label="$(taxon), (α = $(alpha), μₘₐₓ = $(mumax))",
        )
    end

    F[1:2, 2] = Legend(F, A_X, "Taxon")

    # Optionally save
    if saveoutput
        @info "Saving figure to \"$(filename)\""
        save(filename, F)
    end

    return F
end