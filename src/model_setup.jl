using Parameters

export ModelSetup

"""
    ModelSetup

A class/struct to specify set-up parameters for a Monod Memory Simulation. Inputs not specified are
set to default.

## Inputs

* `time_step` - Numeric time-step. Defaults to 0.01
* `time_start` - Start time of the simulation. Defaults to 0.0. Not recommended to change this value.
* `time_end` - End time of the simulation. Defaults to 730 days (2 years)
* `print_time_step` - How frequently to save output. Defaults to 0.1
* `print_time_start` - When to start saving output. Defaults to `time_start`.

## Details

As with `ModelParams` a Type can be specified, for example `Float32`.

Parameters not specified are set to default values.

## Examples

```julia-repl
julia> setup = ModelSetup()
ModelSetup{Float64}
  time_step: Float64 0.01
  time_start: Float64 0.0
  time_end: Float64 730.0
  print_time_step: Float64 0.1
  print_time_start: Float64 0.0
```

```julia-repl
julia> setup2 = ModelSetup{Float32}(time_end=100.)
ModelSetup{Float32}
  time_step: Float32 0.01f0
  time_start: Float32 0.0f0
  time_end: Float32 100.0f0
  print_time_step: Float32 0.1f0
  print_time_start: Float32 0.0f0
```
"""
@with_kw struct ModelSetup{R}
    time_step::R = 0.01
    time_start::R = 0.0
    time_end::R = 365.0 * 2.0
    print_time_step::R = 0.1
    print_time_start::R = time_start
end