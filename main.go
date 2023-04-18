package main

import (
	"fmt"
	nrng "github.com/kmazza2/urn/normal"
	sm64 "github.com/kmazza2/urn/splitmix64"
	u2f "github.com/kmazza2/urn/uint64tofloat64"
	x256xx "github.com/kmazza2/urn/xoshiro256xx"
)

const N = 10000000
const Seed = 0
const Beta = 1.23456789

func main() {
	seed_rng := sm64.NewSplitMix64(Seed)
	src_rng := x256xx.NewXoshiro256xx(
		seed_rng.Next(),
		seed_rng.Next(),
		seed_rng.Next(),
		seed_rng.Next())
	unif_rng := u2f.NewUint64toFloat64(&src_rng)
	normal_rng := nrng.NewNormalrng(&unif_rng, 0, 1)
	y := make([]float64, N)
	x := make([]float64, N)
	e := make([]float64, N)
	for i := 0; i < N; i++ {
		x[i] = unif_rng.Next()
	}
	for i := 0; i < N; i++ {
		e[i] = normal_rng.Next()
	}
	for i := 0; i < N; i++ {
		y[i] = Beta*x[i] + e[i]
	}
	fmt.Println(mean(y))
	fmt.Println(mean(x))
	fmt.Println(mean(e))
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
