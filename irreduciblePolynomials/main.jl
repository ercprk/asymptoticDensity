include("densityComputation.jl")
import .DensityComputation
using DataFrames, Printf, CSV

function main()
    # Approximates the Asymptotic density of irreducible polynomials in all
    # integer polynomials. This is done by setting a number representing both
    # maxDegree and maxConstant to infinity, but
    # practically to 20.
    irrIntPolyBruteDf = DataFrames.DataFrame(maxDegree = [0],
                                             maxConstant = [0],
                                             numPolynomials = [1],
                                             numIrreducibles = [1],
                                             density = [1.0])

    for i in range(1, step = 1, stop = 15)
        @printf("maxDegree, maxConstant = %0.0f\n", i)
        thisDf = DensityComputation.irrIntPolyBrute(i, i)
        irrIntPolyBruteDf = join(irrIntPolyBruteDf, thisDf, kind = :outer,
                            on = intersect(names(irrIntPolyBruteDf), names(thisDf)))
    end
    print(irrIntPolyBruteDf)
    CSV.write("irrIntPolyBrute.csv", irrIntPolyBruteDf, writeheader = true)
    


    # for maxDegree in range(1, step = 1, stop = 5)
    #     @printf("maxDegree: %.0f\n", maxDegree)
    #     for i in range(1, step = 1, stop = 10)
    #         # Set maximum constant of polynomials as i-th prime from 0,
    #         # subtracted by 1 (technical reason for Nemo)
    #         maxConstant = Primes.nextprime(0, i) - 1
    #         @printf("maxConstant: %.0f\n", maxConstant)
    #         df = irreduciblePolynomials(maxDegree, maxConstant)
    #         calculateDensity(df)
    #     end
    # end
end

main()
