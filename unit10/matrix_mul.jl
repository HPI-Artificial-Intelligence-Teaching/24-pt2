# Implements the optimal matrix multiplication algorithm
#
# 2024 written by Ralf Herbrich
# Hasso Plattner Institute

using Random


# computes the optimal multiplication order of a list of matrices
function optimal_multiply(As::Vector{Matrix{Float64}})
    # check that the matrix dimensions match
    for i in 1:length(As)-1
        if size(As[i])[2] != size(As[i+1])[1]
            error("Matrix dimensions do not match")
        end
    end

    # run dynamic programming to compute the optimal multiplication order
    n = length(As)
    m = zeros(Int, n, n)
    s = zeros(Int, n, n)
    for l in 2:n
        for i in 1:n-l+1
            j = i + l - 1
            m[i, j] = typemax(Int)
            for k in i:j-1
                q = m[i, k] + m[k+1, j] + size(As[i])[1] * size(As[k])[2] * size(As[j])[2]
                if q < m[i, j]
                    m[i, j] = q
                    s[i, j] = k
                end
            end
        end
    end
    return m, s
end

# outputs the optimal multiplication order of a list of matrices on the screen
function reconstruct(s::Matrix{Int}, i::Int, j::Int)
    if i == j
        return "A$i"
    else
        k = s[i, j]
        o1 = reconstruct(s, i, k)
        o2 = reconstruct(s, k+1, j)
        output = "($o1 * $o2)"
        return output
    end
end

# generates a list of matrices with random dimensions
As = [randn(10, 100), randn(100, 10), randn(10, 1000)]
m, s = optimal_multiply(As)
println("Optimal matrix multiplicaton = ", reconstruct(s, 1, length(As)))
println("Optimal number of multiplications = ", m[1, length(As)])

# generates a list of matrices with random dimensions
As = [randn(1, 10), randn(10, 1), randn(1, 10), randn(10, 1)]
m, s = optimal_multiply(As)
println("Optimal matrix multiplicaton = ", reconstruct(s, 1, length(As)))
println("Optimal number of multiplications = ", m[1, length(As)])
