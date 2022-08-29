# macBoy Game Boy Emulator

## CPU

### Registers

The Game Boy CPU contains 8 registers, each register is 8 bits (1 byte). The registers are labeled as:
- "a"
- "b"
- "c"
- "d"
- "e"
- "f"
- "h"
- "l"

```
struct Registers {
    var a: UInt8
    var b: UInt8
    var c: UInt8
    var d: UInt8
    var e: UInt8
    var f: FlagsRegister
    var h: UInt8
    var l: UInt8
}
```

The CPU only has 8 bit registers, but there are instructions that can read and write 16 bits. We'll need "virtual" 16 bit registers, which are:
- "af"
- "bc"
- "de"
- "hl"

```
struct Registers {
    // ...
    func getBC() -> UInt16 {
        return (UInt16(self.b)) << 8 | UInt16(self.c)
    }
    
    mutating func setBC(value: UInt16) {
        self.b = UInt8((value & 0xFF00) >> 8)
        self.c = UInt8(value & 0xFF)
    }
    // TO-DO: Implementation for "af", "de", and "hl" needed
    // ...
}
```

Register "f" is a special register called the "flags" register. The lower four bits of the register are *always* 0s and the CPU automatically writes to the upper four bits when certain things happen. The names and positions of the flags are:
- Bit 7: zero
- Bit 6: subtraction
- Bit 5: half carry
- Bit 4: carry

```
struct FlagsRegister {
    let ZERO_POSITION: UInt8 = 7
    let SUBTRACT_POSITION: UInt8 = 6
    let HALF_CARRY_POSITION: UInt8 = 5
    let CARRY_POSITION: UInt8 = 4
    var zero: Bool
    var subtract: Bool
    var halfCarry: Bool
    var carry: Bool
    
    func convertToByte() -> UInt8 {
        (self.zero ? 1 : 0) << ZERO_POSITION |
        (self.subtract ? 1: 0) << SUBTRACT_POSITION |
        (self.halfCarry ? 1 : 0) << HALF_CARRY_POSITION |
        (self.carry ? 1 : 0) << CARRY_POSITION
    }
    
    mutating func convertToFlags(value: UInt8) {
        self.zero = ((value >> ZERO_POSITION) & 0x0b1) != 0
        self.subtract = ((value >> SUBTRACT_POSITION) & 0x0b1) != 0
        self.halfCarry = ((value >> HALF_CARRY_POSITION) & 0x0b1) != 0
        self.carry = ((value >> CARRY_POSITION) & 0x0b1) != 0
    }
}
```
