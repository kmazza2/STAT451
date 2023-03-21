using HW4

@testset "Newton with equality" begin
    f = x -> x[1]^2 + x[2]^2
    f′ = x -> [2*x[1] 2*x[2]]
    f′′ = x -> [2 0; 0 2]
    A = [1 1]
    b = [0]
    x0 = [3, -3]
    ε = 0.001
    @test newton_w_equality(f, f′, f′′, A, b, x0, ε, backtrack=false) ≈ [0,0] atol=0.0001

end
