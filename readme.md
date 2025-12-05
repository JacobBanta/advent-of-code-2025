# Advent of Code 2025
## My solution in Zig
This year I want to complete each day without brute force. I will see how long that lasts. 
## Instructions

### Before building: Download inputs.

For day 1, go to https://adventofcode.com/2025/day/1/input to see your input for the day. `ctrl`+`a` and copy paste into `day01/input.txt`.

The process is the same for the other days.

### Building
Make sure you have Zig `0.15`

To build a specific day, `cd` into that day's folder, and run:
```bash
zig build
```
To run the executable, use either
```bash
zig build run
```
or
```bash
./zig-out/bin/adventofcode
```
To build with optimizations, run
```bash
zig build -Doptimize=ReleaseFast
```

### Bechmarking
The root folder has its own build script, running `zig build` in the root folder will build all day's solutions. 

Running the time step will use `hyperfine` to time each day's solution. I will try my best to keep each day under 1ms on my laptop.
```bash
zig build -Doptimize=ReleaseFast time
```
## Speed
These are the speeds on my laptop.
|day|Time (mean ± σ)|Range (min … max)|
|-|-|-|
|1|285.8 µs ± 79.7 µs|147.4 µs … 1476.6 µs|
|2|355.2 µs ± 92.7 µs|190.6 µs … 1679.4 µs|
|3|218.9 µs ± 69.3 µs|130.3 µs … 1495.9 µs|
|4|490.9 µs ± 111.6 µs|228.9 µs … 1994.8 µs|
|5|477.6 µs ± 117.0 µs|233.4 µs … 2017.8 µs|

