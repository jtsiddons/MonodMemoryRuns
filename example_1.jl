using MonodMemoryRuns

# Model parameters
params = ModelParams{Float64}(
    mu_max=[0.75, 0.84, 1],
    K=0.1,
    alpha=[0.7, 0.85, 1],
    V_max=0.5,
    M=0.5,
    SR=0.001,
    ics=[5.0, 5.0, 5.0, 5.0]
)

# Model Setup
setup = ModelSetup{Float64}(
    time_end=100.0,
    print_time_start=90.0
)

# Run model
df = run_mm(params; setup=setup);

# Plot output
plot_mm_output(df) #; savefile=true, filename="test.png")