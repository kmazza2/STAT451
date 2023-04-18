package main

import (
	"fmt"
	sm64 "github.com/kmazza2/urn/splitmix64"
	x256xx "github.com/kmazza2/urn/xoshiro256xx"
	u2f "github.com/kmazza2/urn/uint64tofloat64"
)

const N = 100
const Seed = 0

func main() {
	seed_rng := sm64.NewSplitMix64(Seed)
	src_rng := x256xx.NewXoshiro256xx(
		seed_rng.Next(),
		seed_rng.Next(),
		seed_rng.Next(),
		seed_rng.Next())
	unif_rng := u2f.NewUint64toFloat64(&src_rng)
	fmt.Println(unif_rng.Next())
}
