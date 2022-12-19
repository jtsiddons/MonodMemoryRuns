using Parameters

export ModelParams

"""
    ModelParams

A class/struct to prescribe parameters for a Monod Memory simulation. All values are required

## Inputs

* `mu_max` - Max Growth Rate - Number or Numeric Vector (of length ics - 1)
* `K` - Saturation coefficient - Number or Numeric Vector (of length ics - 1)
* `alpha` - Memory Parameter - Number or Numeric Vector (of length ics - 1)
* `V_max` - Max Uptake Rate - Number or Numeric Vector (of length ics - 1)
* `M` - Mortality - Number or Numeric Vector (of length ics - 1)
* `SR` - Resource supply rate or function - Number or Function of time
* `ics` - Initial conditions `[R, X_1, ...]` - Numeric Vector

## Details

When `run_mm` is called a check is performed on the validity of the parameters. If any
of the parameters `[mu_max, K, alpha, V_max, M]` are specified as Vectors then it checks 
that they are appropriately sized - `length(ics) - 1`. 

If a mix of vectors and numbers are provided for `[mu_max, K, alpha, V_max, M]`, the model
assumes that parameters with a single numeric value are same for all taxa.

## Example

```julia-repl
julia> params = ModelParams(
            mu_max=[1.0, 0.55],
            K=0.1,
            alpha=[1.0, 0.29],
            V_max=0.5,
            M=0.5,
            SR=0.001,
            ics=[5.0, 5.0, 5.0]
       )
ModelParams{Float64}
  mu_max: Array{Float64}((2,)) [1.0, 0.55]
  K: Float64 0.1
  alpha: Array{Float64}((2,)) [1.0, 0.29]
  V_max: Float64 0.5
  M: Float64 0.5
  SR: Float64 0.001
  ics: Array{Float64}((3,)) [5.0, 5.0, 5.0]
```

You can specify a `Type` for this class, for example `Float32`. However, `Vector`s need to be
appropriately set. Note use of `f0` to specify `Float32` numbers below:

```julia-repl
julia> params = ModelParams{Float32}(
            mu_max=[1.0f0, 0.55f0],
            K=0.1f0,
            alpha=[1.0f0, 0.29f0],
            V_max=0.5f0,
            M=0.5f0,
            SR=0.001f0,
            ics=[5.0f0, 5.0f0, 5.0f0]
       )
ModelParams{Float32}
  mu_max: Array{Float32}((2,)) Float32[1.0, 0.55]
  K: Float32 0.1f0
  alpha: Array{Float32}((2,)) Float32[1.0, 0.29]
  V_max: Float32 0.5f0
  M: Float32 0.5f0
  SR: Float32 0.001f0
  ics: Array{Float32}((3,)) Float32[5.0, 5.0, 5.0]
```
"""
@with_kw struct ModelParams{R}
    mu_max::Union{R,Vector{R}}     # Max growth rate
    K::Union{R,Vector{R}}          # Half-Saturation
    alpha::Union{R,Vector{R}}      # Memory
    V_max::Union{R,Vector{R}}      # Max uptake
    M::Union{R,Vector{R}}          # Mortality
    SR::Union{R,Function}          # Resource supply (not sure how I want to include this)
    ics::Vector{R}                 # Initial conditions
end