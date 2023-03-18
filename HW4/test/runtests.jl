using HW4
using Test

@testset verbose=true "HW4.jl" begin
	@testset "Core Algs" begin
		include("corealgs.jl")
	end

	@testset "Demo Code" begin
		include("democode.jl")
	end
end
