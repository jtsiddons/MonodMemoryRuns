using SpecialFunctions: gamma

export rho, mu

# Parameter Functions
function rterm(R::Number, K)
    R = (R + abs(R)) / 2
    return R / (K + R)
end;
rho(R::Number, V_MAX::Number, K::Number) = V_MAX * rterm(R, K);
mu(R::Number, a::Number, MU_MAX::Number, K::Number) = MU_MAX / gamma(1 + a) * rterm(R, K)^a;

# to check if parameters are correctly set
valid_param(param, ntaxa) = length(param) == 1 || length(param) == ntaxa

# extract parameter value for taxon
function extract_param(p::ModelParams, parameter::Symbol, index::Int)
    if !(parameter in fieldnames(ModelParams))
        error("[!] $(parameter) is not a valid parameter name (extract_param)")
    end

    param_val = getproperty(p, parameter)
    if length(param_val) == 1
        return param_val
    else
        return param_val[index]
    end
end
