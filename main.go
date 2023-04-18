package main

import (
	"fmt"
	sm64 "github.com/kmazza2/urn/splitmix64"
	x256xx "github.com/kmazza2/urn/xoshiro256xx"
	u2f "github.com/kmazza2/urn/uint64tofloat64"
	nrng "github.com/kmazza2/urn/normal"
)

const N = 100
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
	x := [N]float64{}
//	y := [N]float64{}
	for i, _ := range x {
		x[i] = unif_rng.Next()
	}
	fmt.Println(x)
	fmt.Println(normal_rng.Next())
}
