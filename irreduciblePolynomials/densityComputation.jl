# Kyoungduk (Eric) Park
# Asymptotic Density Project
# Nov 22nd, 2019

# RANDOM_SAMPLE_SIZE::Int64 = 500

module DensityComputation

    using Nemo
    using DataFrames
    using Printf
    using Distributed


    function
    calculateDensity(maxDegree, maxConstant, df)::DataFrame
        numPoly = DataFrames.nrow(df)
        numIrrd = sum(df[!, 2])
        density = numIrrd / numPoly
        densityDf = DataFrames.DataFrame(maxDegree = [maxDegree],
                                         maxConstant = [maxConstant],
                                         numPolynomials = [numPoly],
                                         numIrreducibles = [numIrrd],
                                         density = [density])
        return densityDf
    end

    # Function  :
    # Arguments :
    # Returns   :
    # Does      :
    function
    irrIntPolyBrute(maxDegree::Int64, maxConstant::Int64)::DataFrame


        # Quotient Ring Z_{maxConstant + 1} / <x^{maxDegree}>
        #R = ResidueRing(ZZ, maxConstant + 1)
        S, x = PolynomialRing(ZZ, 'x')

        # Initialize the dataframe with a zero polynomial
        df = DataFrame(polynomial = [0*x^0], irreducibility = [true])

        #Populate the dataframe with the rest of the zero-degree polynomials within
        #the ring Z_{maxConstant}/<x^{maxDegree}>
        for constant in range(1, step = 1, stop = maxConstant)
            push!(df::DataFrame, [constant * x ^ 0, true])
        end

        for degree in range(1, step = 1, stop = maxDegree)
            for constant in range(1, step = 1, stop = maxConstant)
                polynomial = constant * x ^ degree
                for i in range(1, step = 1, stop = (maxConstant + 1)^degree)
                    push!(df, [polynomial + df[i, 1], isirreducible(polynomial + df[i, 1])])
                end
            end
        end

        return calculateDensity(maxDegree, maxConstant, df)
    end
end
