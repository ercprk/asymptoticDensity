include("densityComputation.jl")

using Primes

function calculateDensity(df)
    density = sum(df[!, 4]) / DataFrames.nrow(df)
    @printf("Density: %f\n\n", density)
end

function main()
    df = irreduciblePolynomials(3, 3)
    # print(df)
    # calculateDensity(df)


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
