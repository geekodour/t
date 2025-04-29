package main

// NOTE: Test function names should be sentences

import (
	// "fmt"
	"testing"
)

func TestSayHelloWorld(t *testing.T) {
	t.Log("this debug info printed only on fail, else with -v")
	want := "Hello World, I'm baked! 👋"
	if sayHelloWorld() != want {
		t.Errorf("got %q, want %q", sayHelloWorld(), want)
	}
}

func TestSixtyNineFourTwenty(t *testing.T) {
	tcase := []struct {
		name string
		in   int
		want int
	}{
		{"69", 0x45, 69},
		{"420", 0x1A4, 420},
	}
	for _, tt := range tcase {
		// testname := fmt.Sprintf("%d", tt.in) // you could also construct the testname here
		t.Run(tt.name, func(t *testing.T) {
			ans := tt.in
			if ans != tt.want {
				t.Errorf("got %d, want %d", ans, tt.want)
			}
		})
	}
}

func benchmarkSomeStuff(start int, b *testing.B) {
	// b.ResetTimer() // In case we do any expensive setups, we'd want to reset the benchmark timer
	for i := 0; i < b.N; i++ {
		fib(start)
	}
	// fmt.Printf("took %s with b.N = %d\n", b.Elapsed(), b.N)
}

// go test  -bench=. -benchmem -benchtime=1s
//
// Name						Iterations  Time Taken
// BenchmarkSomeStuff1-8    779964104   1.578 ns/op
// BenchmarkSomeStuff2-8    270367604   4.435 ns/op
//   - Each benchmark is run for a minimum of 1 second by default
//   - More iterations the better, if we see less iterations better to increase
//     benchtime
//   - use benchstat for analysis
func BenchmarkSomeStuff1(b *testing.B)  { benchmarkSomeStuff(1, b) }
func BenchmarkSomeStuff2(b *testing.B)  { benchmarkSomeStuff(2, b) }
func BenchmarkSomeStuff3(b *testing.B)  { benchmarkSomeStuff(3, b) }
func BenchmarkSomeStuff40(b *testing.B) { benchmarkSomeStuff(40, b) }

func BenchmarkSomeStuffParallel(b *testing.B) {
	tcases := []struct {
		name string
		n    int
	}{
		{name: "fib(10)", n: 10},
		{name: "fib(20)", n: 20},
		{name: "fib(30)", n: 30},
		{name: "fib(40)", n: 40},
	}

	for _, tc := range tcases {
		b.Run(tc.name, func(b *testing.B) {
			b.RunParallel(func(pb *testing.PB) {
				for pb.Next() {
					_ = fib(tc.n)
				}
			})
		})
	}
}
