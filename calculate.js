class MathOperations {
    // Addition
    static add(a, b) {
        return a + b
    }

    // Subtraction
    static subtract(a, b) {
        return a - b
    }

    // Multiplication
    static multiply(a, b) {
        return a * b
    }

    // Division
    static divide(a, b) {
        if (b === 0) {
            throw new Error("Cannot divide by zero.")
        }
        return a / b
    }

    // Exponentiation
    static power(base, exponent) {
        return Math.pow(base, exponent)
    }

    // Square Root
    static squareRoot(a) {
        if (a < 0) {
            throw new Error('Cannot compute square root of a negative number.')
        }
        return Math.sqrt(a)
    }

    // Factorial
    static factorial(n) {
        if (n < 0) {
            throw new Error('Cannot compute factorial of a negative number.')
        }
        if (n === 0 || n === 1) {
            return 1
        }
        var result = 1
        for (let i = 2; i <= n; i++) {
            result *= i
        }
        return result
    }

    // Greatest Common Divisor (Euclidean Algorithm)
    static gcd(a, b) {
        if (!Number.isInteger(a) || !Number.isInteger(b)) {
            throw new Error("Inputs must be integers.")
        }
        a = Math.abs(a)
        b = Math.abs(b)
        while (b) {
            [a, b] = [b, a % b]
        }
        return a
    }

    // Least Common Multiple
    static lcm(a, b) {
        if (!Number.isInteger(a) || !Number.isInteger(b)) {
            throw new Error("Inputs must be integers.")
        }
        return Math.abs(a * b) / MathOperations.gcd(a, b)
    }

    // Sine (angle in radians)
    static sine(angle) {
        return Math.sin(angle)
    }

    // Cosine (angle in radians)
    static cosine(angle) {
        return Math.cos(angle)
    }

    // Tangent (angle in radians)
    static tangent(angle) {
        return Math.tan(angle)
    }

    // Natural Logarithm
    static logarithm(a) {
        if (a <= 0) {
            throw new Error('Input must be greater than zero.')
        }
        return Math.log(a)
    }

    // Exponential
    static exponential(a) {
        return Math.exp(a)
    }

    // Absolute Value
    static absolute(a) {
        return Math.abs(a)
    }

    // Random Number between 0 and 1
    static random() {
        return Math.random()
    }

    // Round to nearest integer
    static round(a) {
        return Math.round(a)
    }

    // Ceiling function
    static ceil(a) {
        return Math.ceil(a)
    }

    // Floor function
    static floor(a) {
        return Math.floor(a)
    }
}

// Usage Examples
console.log(MathOperations.add(5, 3))            // Output: 8
console.log(MathOperations.divide(10, 2))        // Output: 5
console.log(MathOperations.factorial(5))         // Output: 120
console.log(MathOperations.gcd(48, 18))          // Output: 6
console.log(MathOperations.sine(Math.PI / 2))    // Output: 1
console.log(MathOperations.random())             // Output: Random number between 0 and 1
