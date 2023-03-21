module HW4
export newton_w_equality

"""
    newton_w_equality(f,f′,f′′, A, b, x0, ε, max_iter=1000, backtrack=true)

Solve convex optimization problem:
    minimize f subject to equality constraint `Ax=b`

"""
function newton_w_equality(
        f, f′, f′′, A::Matrix{<:Number}, b::Vector{<:Number},
        x0::Vector{<:Number}, ε::Number; max_iter::Integer=1000,
        backtrack::Bool=true)
end

end
