package main

import (
	"fmt"

	"github.com/alecthomas/kong"
)

var VersionString = "unknown"

func sayHelloWorld() string {
	// fmt.Println("Version:", VersionString)
	return "Hello World, I'm baked! 👋"
}

func fib(n int) int {
	if n < 2 {
		return n
	}
	return fib(n-1) + fib(n-2)
}

var cli struct {
	Version  struct{} `cmd:"" help:"Show current version"`
	LogLevel string   `enum:"debug,info,warn,error" default:"info" short:"l" help:"Set log level"`
	Food     struct {
		Fruits     struct{} `cmd:"" help:"Show fruit" default:"1"`
		Vegetables struct{} `cmd:"" help:"Show vegetables"`
	} `cmd:"" help:"Select food"`
	Announce struct {
		To      string   `arg:"" help:"to email id"`
		From    string   `arg:"" help:"from email id"`
		Socials []string `arg:"" help:"socials separated by ," optional:""`
	} `cmd:"" help:"Announcement channels"`
	Criminals struct {
		Pairs map[string]string `arg:"" help:"in the form key=value"`
	} `cmd:"" help:"separated by ;"`
}

func main() {
	ctx := kong.Parse(&cli,
		kong.Name("bake"),
		kong.Description("An awsome cli utility to help you bake cakes 🍰"),
		kong.ShortUsageOnError(),
	)
	switch ctx.Command() {
	case "version":
		_ = fib(1)
		fmt.Println(VersionString)
	case "food fruits":
		fmt.Println(sayHelloWorld())
		fmt.Println("You selected fruits friend")
	default:
		fmt.Println("Generic program handler here")
	}
}
