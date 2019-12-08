# Kyoungduk (Eric) Park
# Asymptotic Density Project
# Nov 22nd, 2019

module DensityComputation

    using Nemo
    using DataFrames
    using Printf
    using Random

    # Function  : irrIntPolyBrute
    # Arguments : desired maxDegree and maxConstant of polynomials over integer
    # Returns   : a Dataframe of maxDegree, maxConstant, the total number of
    #             polynomials, the total number of irreducible polynomials,
    #             and the density of irreducible polynomials in all polynomials
    # Does      : Brute forces to compute all polynomials over Z of a set
    #             maximum degree and maximum constant. Computes the
    #             irreducibility of all polynomials and density of irreducible
    #             polynomials in all polynomials.
    function
    irrIntPolyBrute(maxDegree::Int64, maxConstant::Int64)::DataFrame

        # Set x as the univariable of the polynomial ring over Z
        S, x = PolynomialRing(ZZ, 'x')

        # Initialize the dataframe with a zero polynomial
        df = DataFrame(polynomial = [0*x^0], irreducibility = [true])

        # Populate the dataframe with the rest of the zero-degree polynomials
        for constant in range(1, step = 1, stop = maxConstant)
            push!(df::DataFrame, [constant * x ^ 0, true])
        end

        # Populate the dataframe with the rest of the polynomials
        for degree in range(1, step = 1, stop = maxDegree)
            for constant in range(1, step = 1, stop = maxConstant)
                polynomial = constant * x ^ degree
                for i in range(1, step = 1, stop = (maxConstant + 1) ^ degree)
                    push!(df, [polynomial + df[i, 1],
                          isirreducible(polynomial + df[i, 1])])
                end
            end
        end

        # Compute the total number of all polynomials, irreducible polynomials,
        # and density
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

    # Function  : irrIntPolyApprox
    # Arguments : number of steps
    # Returns   : a Dataframe with each row:
    #             1) step number
    #             2) cumulative number of polynomials
    #             3) cumulative number of irreducible polynomials
    #             4) cumulative density
    # Does      : Let the term PolyZ_m be the set of all polynomials over Z
    #             with maxDegree <= m and maxConstant <= m. At each step number
    #             m, n polynomials from PolyZ_m are picked at random and
    #             computed their irreducibility, where n = max{|PolyZ_m|, 500}.
    #             Thus, asymptotic density of irreducible polynomials in all
    #             polynomials over Z is cumulatively approximated as m
    #             approaches infinity.
    function
    irrIntPolyApprox(numSteps::Int64)::DataFrame

        # Set x as the univariable of the polynomial ring over Z
        S, x = PolynomialRing(ZZ, 'x')

        # Initialize the dataframe with step 0
        numPoly = 1
        numIrrPoly = 1
        df = DataFrame(step = [0], numPoly = [numPoly],
                       numIrrPoly = [numIrrPoly], density = [1.000])

        # Seed random number generate
        Random.seed!(0)

        # Approximates the density of irreducible polynomials in all
        # polynomials over Z
        for m in range(1, step = 1, stop = numSteps)
            @printf("Step: %0.0f\n", m)

            # Size of PolyZ_m
            sizePolyZ_m = (m + 1) ^ (m + 1)

            # Number of polynomials to be computed
            n = m > 4 ? 500 : sizePolyZ_m
            @printf("n: %0.0f\n", n)

            for _  in range(1, step = 1, stop = n)
                polynomial = 0*x^0
                for degree in range(m, step = -1, stop = 0)
                    polynomial += rand(0 : m) * x ^ degree
                end
                if isirreducible(polynomial)
                    numIrrPoly += 1
                end
                numPoly +=1
            end

            density = Float64(numIrrPoly) / Float64(numPoly)
            push!(df, [m, numPoly, numIrrPoly, density])
        end

        return df
    end

end
