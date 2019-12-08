include("densityComputation.jl")
import .DensityComputation
using DataFrames, Printf, CSV, Plots

function main()
    # Approximates the asymptotic density of irreducible polynomials in all
    # polynomials over integer.
    irrIntPolyDf = DensityComputation.irrIntPolyApprox(20)
    CSV.write("irrIntPoly.csv", irrIntPolyDf, writeheader = true)

    plot(x = irrIntPolyDf[!, 4], y = irrIntPolyDf[!, 1])
    savefig("output.png")
end

main()
