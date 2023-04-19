package main

import (
	"fmt"
	drng "github.com/kmazza2/urn/dunif"
	f64rng "github.com/kmazza2/urn/float64rng"
	nrng "github.com/kmazza2/urn/normal"
	sm64 "github.com/kmazza2/urn/splitmix64"
	u2f "github.com/kmazza2/urn/uint64tofloat64"
	x256xx "github.com/kmazza2/urn/xoshiro256xx"
	"math"
)

const Trials = 100000
const Samples = 30
const Resamples = 1000
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
	mean_analytic_l := 0.
	mean_analytic_u := 0.
	mean_analytic_width := 0.
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
		// The dataset has now been generated.
		// Calculate the confidence interval analytically:
		lower := beta1_hat(x, y) - t(x)
		upper := beta1_hat(x, y) + t(x)
		mean_analytic_l += lower
		mean_analytic_u += upper
		mean_analytic_width += upper - lower
		if lower <= Beta && Beta <= upper {
			ci_contains_param += 1.
		}
		// Calculate the confidence interval using bootstrap:
	}
	mean_analytic_l /= Trials
	mean_analytic_u /= Trials
	mean_analytic_width /= Trials
	fmt.Printf("mean analytic lower bound: %f\n", mean_analytic_l)
	fmt.Printf("mean analytic upper bound: %f\n", mean_analytic_u)
	fmt.Printf("mean analytic width: %f\n", mean_analytic_width)
	fmt.Printf("analytic CI coverage: %f\n", ci_contains_param/Trials)
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

func t(x []float64) float64 {
	sum := 0.
	for i := 0; i < len(x); i++ {
		sum += x[i] * x[i]
	}
	return -1. * InvCdf / math.Sqrt(sum)
}

func resample(data []float64, src_rng f64rng.Float64rng) []float64 {
	dunif_rng := drng.NewDunifrng(src_rng, Samples)
	result := make([]float64, len(data))
	for i := 0; i < len(data); i++ {
		result[i] = data[dunif_rng.Next()-1]
	}
	return result
}

type pair struct {
	x float64
	y float64
}

func zip(x []float64, y []float64) []pair {
	if len(x) != len(y) {
		panic("len(x) != len(y)")
	}
	result := make([]pair, len(x))
	for i := 0; i < len(x); i++ {
		result[i] = pair{x[i], y[i]}
	}
	return result
}
