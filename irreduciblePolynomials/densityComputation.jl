# Kyoungduk (Eric) Park
# Asymptotic Density Project
# Nov 22nd, 2019

# RANDOM_SAMPLE_SIZE::Int64 = 500

using Nemo
using DataFrames
using Primes
using Printf
using Distributed

function
calculateDensity(df)::Int64
    density = sum(df[!, 4]) / DataFrames.nrow(df)
    @printf("Density: %f\n\n", density)
    return density
end

function
irreduciblePolynomials(maxDegree::Int64, maxConstant::Int64)::DataFrame

    # Quotient Ring Z_{maxConstant + 1} / <x^{maxDegree}>
    #R = ResidueRing(ZZ, maxConstant + 1)
    print(typeof(QQ))
    S, x = PolynomialRing(ZZ, 'x')

    # Initialize the dataframe with zero constant polynomial
    df = DataFrame(max_constant = [maxConstant], max_deg = [maxDegree],
                   polynomial = [0*x^0], irreducibility = [true])

    #Populate the dataframe with the rest of the zero-degree polynomials within
    #the ring Z_{maxConstant}/<x^{maxDegree}>
    for constant in range(1, step = 1, stop = maxConstant)
        push!(df::DataFrame, [maxConstant, maxDegree, constant * x ^ 0, true])
    end

    for degree in range(1, step = 1, stop = maxDegree)
        #@printf("degree: %.0f\n", degree)
        for constant in range(1, step = 1, stop = maxConstant)
            #@printf("constant: %.0f\n", constant)
            polynomial = constant * x ^ degree
            @distributed for i in range(1, step = 1, stop = (maxConstant + 1)^degree)
                push!(df::DataFrame, [maxConstant, maxDegree,
                                      polynomial + df[i, 3],
                                      isirreducible(polynomial + df[i, 3])])
            end
        end
    end

    return df
end
