struct Fraction {
    var numerator: Int = 1
    var denominator: Int = 1
    
    private func greatestCommonDivisor(_ a: Int, _ b: Int) -> Int {
        let remainder = a % b
        
        if remainder != 0 {
            return greatestCommonDivisor(b, remainder)
        } else {
            return abs(b)
        }
    }
    
    private func leastCommonMultiple(_ a: Int, _ b: Int) -> Int {
        return abs(a * b) / greatestCommonDivisor(a, b)
    }
    
    init(whole: Int) {
        self.numerator = whole
        self.denominator = 1
    }
    
    init(numerator: Int, denominator: Int) {
        guard denominator != 0 else {
            fatalError("Denominator cannot be zero")
        }
        
        let sign = denominator < 0 ? -1 : 1
        let gcd = greatestCommonDivisor(abs(numerator), abs(denominator))
        
        self.numerator = sign * abs(numerator) / gcd
        self.denominator = abs(denominator) / gcd
    }
    
    func mixedNumber() -> String {
        let whole = numerator / denominator
        let remainder = numerator % denominator
        
        if remainder == 0 {
            return "\(whole)"
        } else {
            return "\(whole)&\(abs(remainder))/\(denominator)"
        }
    }
}

extension Fraction: CustomStringConvertible {
    var description: String {
        return "\(numerator)/\(denominator)"
    }
}

extension Fraction {
    static func +(lhs: Fraction, rhs: Fraction) -> Fraction {
        let lcd = lhs.leastCommonMultiple(lhs.denominator, rhs.denominator)
        let numerator = lhs.numerator * (lcd / lhs.denominator) + rhs.numerator * (lcd / rhs.denominator)
        return Fraction(numerator: numerator, denominator: lcd)
    }
    
    static func -(lhs: Fraction, rhs: Fraction) -> Fraction {
        let lcd = lhs.leastCommonMultiple(lhs.denominator, rhs.denominator)
        let numerator = lhs.numerator * (lcd / lhs.denominator) - rhs.numerator * (lcd / rhs.denominator)
        return Fraction(numerator: numerator, denominator: lcd)
    }
    
    static func *(lhs: Fraction, rhs: Fraction) -> Fraction {
        return Fraction(numerator: lhs.numerator * rhs.numerator, denominator: lhs.denominator * rhs.denominator)
    }
    
    static func /(lhs: Fraction, rhs: Fraction) -> Fraction {
        return Fraction(numerator: lhs.numerator * rhs.denominator, denominator: lhs.denominator * rhs.numerator)
    }
}

func performOperation(lhs: Fraction, rhs: Fraction, operatorSymbol: String) -> Fraction {
    switch operatorSymbol {
    case "+":
        return lhs + rhs
    case "-":
        return lhs - rhs
    case "*":
        return lhs * rhs
    case "/":
        return lhs / rhs
    default:
        fatalError("Invalid operator")
    }
}

func promptUser() {
    while true {
        print("? ", terminator: "")
        if let input = readLine(), input.lowercased() != "exit" {
            let components = input.components(separatedBy: " ")
            guard components.count == 3 else {
                print("Invalid input format")
                continue
            }
            
            let lhs = parseFraction(components[0])
            let operatorSymbol = components[1]
            let rhs = parseFraction(components[2])
            
            let result = performOperation(lhs: lhs, rhs: rhs, operatorSymbol: operatorSymbol)
            print("= \(result.mixedNumber())")
        } else {
            break
        }
    }
}

private func greatestCommonDivisor(_ a: Int, _ b: Int) -> Int {
        let remainder = a % b
        
        if remainder != 0 {
            return greatestCommonDivisor(b, remainder)
        } else {
            return abs(b)
        }
    }
    

func parseFraction(_ input: String) -> Fraction {
    if input.contains("/") {
        let components = input.components(separatedBy: "/")
        guard let numerator = Int(components[0]), let denominator = Int(components[1]) else {
            fatalError("Invalid fraction format")
        }
        return Fraction(numerator: numerator, denominator: denominator)
    } else {
        guard let value = Int(input) else {
            fatalError("Invalid fraction format")
        }
        return Fraction(whole: value)
    }
}

promptUser()
