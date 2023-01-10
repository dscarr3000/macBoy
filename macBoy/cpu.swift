//
//  cpu.swift
//  macBoy
//
//  Created by Daniel Carr on 1/10/23.
//

import Foundation


/// The Game Boy CPU contains 8 registers, each register is 8 bits (1 byte). The registers are labeled as: a, b, c, d, e, f, h, l.
///
/// The CPU only has 8 bit registers, but there are instructions that can read and write 16 bits. We'll need "virtual" 16 bit registers, which are: af, bc, de, hl
struct Registers {
    var a: UInt8
    var b: UInt8
    var c: UInt8
    var d: UInt8
    var e: UInt8
    var f: UInt8
    var h: UInt8
    var l: UInt8
    
    /// Gets the value from the "virtual" 16 bit register af. The value in register a being the 8 left-most bits and register f being the 8 right-most bits.
    /// - Returns: A 16 bit unsigned integer.
    func getAF() -> UInt16 {
        return (UInt16(self.a)) << 8 | UInt16(self.f)
    }
    
    /// Gets the value from the "virtual" 16 bit register bc. The value in register b being the 8 left-most bits and register c being the 8 right-most bits.
    /// - Returns: A 16 bit unsigned integer.
    func getBC() -> UInt16 {
        return (UInt16(self.b)) << 8 | UInt16(self.c)
    }
    
    
    /// Gets the value from the "virtual" 16 bit register de. The value in register d being the 8 left-most bits and register e being the 8 right-most bits.
    /// - Returns: A 16 bit unsigned integer.
    func getDE() -> UInt16 {
        return (UInt16(self.d)) << 8 | UInt16(self.e)
    }
    
    
    /// Gets the value from the "virtual" 16 bit register hl. The value in register h being the 8 left-most bits and register l being the 8 right-most bits.
    /// - Returns: A 16 bit unsigned integer.
    func getHL() -> UInt16 {
        return (UInt16(self.h)) << 8 | UInt16(self.l)
    }
    
    
    /// Sets the value of the "virtual" 16 bit register af. Register a will contain the 8 left-most bits and register f will contain the 8 right-most bits.
    /// - Parameter value: A 16 bit unsigned integer.
    mutating func setAF(value: UInt16) {
        self.a = UInt8((value & 0xFF00) >> 8)
        self.f = UInt8(value & 0xFF)
    }
    
    
    /// Sets the value of the "virtual" 16 bit register bc. Register b will contain the 8 left-most bits and register c will contain the 8 right-most bits.
    /// - Parameter value: A 16 bit unsigned integer.
    mutating func setBC(value: UInt16) {
        self.b = UInt8((value & 0xFF00) >> 8)
        self.c = UInt8(value & 0xFF)
    }
    
    /// Sets the value of the "virtual" 16 bit register de. Register d will contain the 8 left-most bits and register e will contain the 8 right-most bits.
    /// - Parameter value: A 16 bit unsigned integer.
    mutating func setDE(value: UInt16) {
        self.d = UInt8((value & 0xFF00) >> 8)
        self.e = UInt8(value & 0xFF)
    }
    
    /// Sets the value of the "virtual" 16 bit register hl. Register h will contain the 8 left-most bits and register l will contain the 8 right-most bits.
    /// - Parameter value: A 16 bit unsigned integer.
    mutating func setHL(value: UInt16) {
        self.h = UInt8((value & 0xFF00) >> 8)
        self.l = UInt8(value & 0xFF)
    }
}

//

/// Register "f" is a special register called the "flags" register. The lower four bits of the register are ALWAYS 0s and the CPU automatically writes to the upper four bits when certain things happen.
///
/// The names and positions of the flags are:
/// - Bit 7: zero
/// - Bit 6: subtraction
/// - Bit 5: half carry
/// - Bit 4: carry
struct FlagsRegister {
    let ZERO_POSITION: UInt8 = 7
    let SUBTRACT_POSITION: UInt8 = 6
    let HALF_CARRY_POSITION: UInt8 = 5
    let CARRY_POSITION: UInt8 = 4
    var zero: Bool
    var subtract: Bool
    var halfCarry: Bool
    var carry: Bool
    
    /// Converts the flag booleans to an 8 bit unsigned integer representation.
    /// - Returns: An 8 bit Unsigned Integer.
    func convertToByte() -> UInt8 {
        return (self.zero ? 1 : 0) << ZERO_POSITION |
            (self.subtract ? 1: 0) << SUBTRACT_POSITION |
            (self.halfCarry ? 1 : 0) << HALF_CARRY_POSITION |
            (self.carry ? 1 : 0) << CARRY_POSITION
    }
    
    /// Converts an 8 bit unsigned integer into the appropriate flag booleans.
    /// - Parameter value: An 8 bit Unsigned Integer.
    mutating func convertToFlags(value: UInt8) {
        self.zero = ((value >> ZERO_POSITION) & 0b1) != 0
        self.subtract = ((value >> SUBTRACT_POSITION) & 0b1) != 0
        self.halfCarry = ((value >> HALF_CARRY_POSITION) & 0b1) != 0
        self.carry = ((value >> CARRY_POSITION) & 0b1) != 0
    }
}
