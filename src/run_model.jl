using DifferentialEquations

export run_mm

"""
    run_mm(p::ModelParams; setup::ModelSetup=ModelSetup(), saveoutput::Bool=false, filename::String="")::DataFrame

Run a Monod Memory Simulation

## Inputs

* `p::ModelParams` - The model parameters as a `ModelParams` instance.

### Optional arguments

* `setup::ModelSetup` - The set-up parameters as a `ModelSetup` instance. Uses default set-up if not specified.
* `saveoutput::Bool` - Optionally save output.
* `filename::String` - Filename for saved output. A name is automatically generated if this is not supplied.

See `ModelSetup` documentation for default set-up parameters.

## Details

Runs a Monod Memory simulation for the specified parameters. 

Verifies that parameters are valid - either numeric or having same size as number of taxa - determined by
the length of the initial conditions - 1. 

If a combination of numeric and vector parameters are specified, the model assumes that single parameters are
shared across all taxa. 

The output is a DataFrame. Column names for multiple taxa are generated automatically. They are of the form
`X_i` where `i` is the taxon index. Here `i` is padded with `0` accordingly if there are ≥ 10 taxa. This allows
for correct alphabetic ordering.

## Examples

```julia-repl
julia> params = ModelParams(
           mu_max=[1.0, 0.55],
           K=0.1,
           alpha=[1.0, 0.29],
           V_max=0.5,
           M=0.5,
           SR=0.001,
           ics=[5.0, 5.0, 5.0]
       );
julia> setup = ModelSetup(
           time_end = 100.0
       );
julia> run_mm(params); # With default setup
julia> run_mm(params; setup=setup); # With custom setup
```
"""
function run_mm(p::ModelParams; setup::ModelSetup=ModelSetup(), saveoutput::Bool=false, filename::String="")::DataFrame

    # Generate filename if saving output
    if saveoutput && filename == ""
        filename = "mm_output_$(now).csv"
    end

    ntaxa = length(p.ics) - 1

    @info "Running for $(ntaxa) taxa"

    for field in fieldnames(ModelParams)
        if field == :ics
            continue
        end
        parameter_value = getproperty(p, field)
        if !valid_param(parameter_value, ntaxa)
            error("[!] Model Parameter \"$(field)\" is incorrectly set. Must have dimension either 1 or same as number of X initial conditions ($(ntaxa) in this case).")
        end
        @info "$(field) is set to $(parameter_value)"
    end

    @show setup

    # Extract Model params
    model_params = [
        p.mu_max,
        p.K,
        p.alpha,
        p.V_max,
        p.M,
        p.SR,
    ]

    # Set-up (using Float32 for speed)
    sampling_times = range(setup.print_time_start, setup.time_end, step=setup.print_time_step)

    isoutofdomain = (u, p, t) -> any(x -> x < 0, u)

    # Define ODE Problem
    if typeof(p.SR) <: Function
        prob = ODEProblem(monod_memory_n_var!, p.ics, [setup.time_start, setup.time_end], model_params)
    else
        prob = ODEProblem(monod_memory_n!, p.ics, [setup.time_start, setup.time_end], model_params)
    end
    sol = solve(
        prob,
        Tsit5(),
        reltol=1e-6,
        abstol=1e-6,
        saveat=sampling_times,
        adaptive=false,
        dt=setup.time_step,
        isoutofdomain=isoutofdomain,
    )

    return parse_output(sol, p, saveoutput, filename)
end;

