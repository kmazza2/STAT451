package main

import (
	"fmt"
	nrng "github.com/kmazza2/urn/normal"
	sm64 "github.com/kmazza2/urn/splitmix64"
	u2f "github.com/kmazza2/urn/uint64tofloat64"
	x256xx "github.com/kmazza2/urn/xoshiro256xx"
	"math"
)

const Trials = 10000000
const Samples = 30
const Seed = 0
const Beta = 2.
const InvCdf = -1.959963984540054

func main() {
	seed_rng := sm64.NewSplitMix64(Seed)
	src_rng := x256xx.NewXoshiro256xx(
		seed_rng.Next(),
		seed_rng.Next(),
		seed_rng.Next(),
		seed_rng.Next())
	unif_rng := u2f.NewUint64toFloat64(&src_rng)
	normal_rng := nrng.NewNormalrng(&unif_rng, 0, 1)
	ci_contains_param := 0.
	for i := 0; i < Trials; i++ {
		y := make([]float64, Samples)
		x := make([]float64, Samples)
		e := make([]float64, Samples)
		for j := 0; j < Samples; j++ {
			x[j] = unif_rng.Next()
		}
		for j := 0; j < Samples; j++ {
			e[j] = normal_rng.Next()
		}
		for j := 0; j < Samples; j++ {
			y[j] = Beta*x[j] + e[j]
		}
		lower := beta1_hat(x, y) - T(x)
		upper := beta1_hat(x, y) + T(x)
		if lower <= Beta && Beta <= upper {
			ci_contains_param += 1.
		}
	}
	fmt.Println(ci_contains_param / Trials)
}

func sum(s []float64) float64 {
	result := 0.
	for _, v := range s {
		result += v
	}
	return result
}

func mean(s []float64) float64 {
	return sum(s) / float64(len(s))
}

func beta1_hat(x []float64, y []float64) float64 {
	num := 0.
	denom := 0.
	for i := 0; i < len(x); i++ {
		num += x[i] * y[i]
		denom += x[i] * x[i]
	}
	return num / denom
}

func T(x []float64) float64 {
	sum := 0.
	for i := 0; i < len(x); i++ {
		sum += x[i] * x[i]
	}
	return -1. * InvCdf / math.Sqrt(sum)
}
