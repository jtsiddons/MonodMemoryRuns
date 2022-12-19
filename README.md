# MonodMemeryRuns

A package for running the n-taxa Monod Memory model defined by 

$\hspace{7cm} \dfrac{dR}{dt} = S_R - \sum_i\rho_{{i}_{(R)}} X_i,$

$\hspace{7cm} \dfrac{dX_i}{dt} = \left(\mu_{{i}_{(R)}} -M_i \right) X_i$

where $\rho_{{i}_{(R)}} = V_{i,\max} \dfrac{R}{R+K_i}$ and $\mu_{{i}_{(R)}} = \dfrac{\mu_{i,\max}}{\Gamma(1+\alpha_i)}\left(\dfrac{R}{R+K_i} \right)^{\alpha_i}$. 

## Working with this package

### Initial set-up

In this directory (assuming you have this saved as MonodMemoryRuns in Dropbox)

```bash
$: pwd
~/Dropbox/MonodMemoryRuns
```

run Julia from this directory, with the project tag:
```bash
$: julia --project=.
```

In Julia, activate and load the project:

```bash
julia> ] # Start Pkg mode
(MonodMemoryRuns) pkg> instantiate
```

If on loading pacakge mode you don't get the `(MonodMemoryRuns)` prompt, you will need to instead do:

```bash
julia> ] # Start Pkg mode
(@v1.8) pkg> activate . # Activate project
(MonodMemoryRuns) pkg> instantiate
```

That will set-up the project and install dependencies.

### Running models

For best results: always work in the correct directory:

```bash
$: pwd
~/Dropbox/MonodMemoryRuns
```

#### Jupyter

If you start Jupyter from this directory, you may be able to load the package using:

```julia
using MonodMemoryRuns
```

If this fails you will need to activate the correct Julia environment:

```julia
using Pkg; Pkg.activate("~/Dropbox/MonodMemoryRuns")
using MonodMemoryRuns
```

#### Julia terminal

Start Julia in the correct directory:

```bash
$: pwd
~/Dropbox/MonodMemoryRuns
$: julia --project=.
```
```julia
julia> using MonodMemoryModels
```

If thins fails, check the projcect has activated. Enter package mode and check if the prompt reads:

```julia
julia> ] 
(MonodMemoryRuns) pkg>
```

If not

```bash
julia> ] # Start Pkg mode
(@v1.8) pkg> activate . # Activate project
(MonodMemoryRuns) pkg>
```

Press backspace to return to the Julia prompt.

## Models

### Parameters

You define parameters using the `ModelParams` struct. This takes as required input:

1. `mu_max` - Max growth rate. Number or Vector
2. `K` - Saturation. Number or Vector
3. `alpha` - Memory. Number or Vector
4. `V_max` - Max uptake rate. Number or Vector
5. `M` - Mortality. Number or Vector
6. `SR` - Resource input. Number or function of time.
7. `ics` - Initial conditions `[R, X1, ...]`. Vector.

There are no defaults, so all must be specified.

For example, for two taxa with different growth rates and alphas:

```julia
params = ModelParams(
    mu_max=[1.0, 0.55],
    K=0.1,
    alpha=[1.0, 0.29],
    V_max=0.5,
    M=0.5,
    SR=0.001,
    ics=[5.0, 5.0, 5.0]
)
```

The model will automatically detect that `K`, `V_max`, and `M` are the same for each taxon. It determines how many taxa are present from the initial conditions. It then checks parameters are defined accordingly

### Set-up

You define set-up parameters using the `ModelSetup` struct. This takes as input

1. `time_step` = 0.01
2. `time_start` = 0.0
3. `time_end` = 365.0 * 2.0
4. `print_time_step` = 0.1
5. `print_time_start` = `time_start`

If a value is not specified, the default value is used.

For example:

```julia
setup = ModelSetup(
    time_end = 100.0,       # 100 day simulation
    print_time_start = 90.0 # start printing output at 90 days
)
```

### Running the model

To run, simply call `run_mm`:

```julia
run_mm(p::ModelParams; setup::ModelSetup=ModelSetup())
```

This takes a `ModelParams` instance (required) as input. You can optionally add in a `ModelSetup` instance if you are not running the default set-up.

```julia
output = run_mm(params)  # run with default set-up
```

```julia
output = run_mm(params; setup=setup) # run with custom set-up (note use ";" to add the optional arguments)
```

`run_mm` returns a DataFrame containing the results. This includes resource, cell densities, parameters, rho and mu, resource input.

### Plotting the output

To plot the output run `plot_mm_output`. This takes a DataFrame input. Optionally you can save the figure by setting the optional arguments `savefile` to `true` and specifying a `filename`. A default filename is chosen if this is not specified.

```julia
plot_mm_output(output)
plot_mm_output(output; savefile=true, filename="test.png")
```