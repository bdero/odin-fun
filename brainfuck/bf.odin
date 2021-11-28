package main

import "core:fmt"
import "core:os"

main :: proc() {
    if len(os.args) < 2 {
        fmt.println("Usage:", os.args[0], "[filename]")
        os.exit(64)
    }

    program, success := os.read_entire_file_from_filename(os.args[1])
    if !success {
        fmt.println("Unable to read file:", os.args[1])
        os.exit(1)
    }

    tape: [dynamic]byte
    append(&tape, 0)

    pc := 0
    tc := 0

    outer: for pc >= 0 && pc < len(program) {
        switch program[pc] {
            case '>':
                tc += 1
                for tc > len(tape) - 1 {
                    append(&tape, 0)
                }
            case '<':
                tc -= 1
                if tc < 0 {
                    fmt.println("\nThe tape counter ended up at < 0; halting program.")
                    break
                }
            case '+':
                tape[tc] += 1
            case '-':
                tape[tc] -= 1
            case '.':
                fmt.printf("%c", tape[tc])
            case ',':
                os.read(os.stdin, tape[tc:tc])
            case '[':
                if tape[tc] == 0 {
                    start_pc := pc
                    stack := 1
                    for stack > 0 {
                        pc += 1
                        if pc >= len(program) {
                            fmt.println("\nNo matching ']' for '[' at", start_pc, "; halting program.")
                            break outer
                        }
                        if program[pc] == ']' {
                            stack -= 1
                        } else if program[pc] == '[' {
                            stack += 1
                        }
                    }
                }
            case ']':
                if tape[tc] != 0 {
                    start_pc := pc
                    stack := 1
                    for stack > 0 {
                        pc -= 1
                        if pc < 0 {
                            fmt.println("\nNo matching '[' for ']' at", start_pc, "; halting program.")
                            break outer
                        }
                        if program[pc] == '[' {
                            stack -= 1
                        } else if program[pc] == ']' {
                            stack += 1
                        }
                    }
                }
        }
        pc += 1
    }
}

