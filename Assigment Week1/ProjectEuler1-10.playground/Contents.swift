//1. If we list all the natural numbers below 10 that are multiples of 3 or 5, we get 3, 5, 6 and 9. The sum of these multiples is 23. Find the sum of all the multiples of 3 or 5 below 1000.
func multipleThreeAndFive(count: Int) -> Int{
    var sum = 0
    for i in (3..<count){
        if i % 3 == 0 || i % 5 == 0{
            sum += i
        }
    }
    return sum
}
print(multipleThreeAndFive(count: 1000))


//2. Each new term in the Fibonacci sequence is generated by adding the previous two terms. By starting with 1 and 2, the first 10 terms will be: 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ... By considering the terms in the Fibonacci sequence whose values do not exceed four million, find the sum of the even-valued terms.
func evenFib(max: Int) -> Int{
    var sum = 0
    var lo = 0
    var hi = 1
    while hi <= max{
        (lo, hi) = (hi, lo+hi)
        if hi % 2 == 0{
            sum += hi
        }
    }
    return sum
}
print(evenFib(max:40000))


//3. The prime factors of 13195 are 5, 7, 13 and 29. What is the largest prime factor of the number 600851475143 ?
func maxPrime( num: Int) -> Int{
    var num = num
    var max = -1

    while num % 2 == 0{
        max = 2
        num >>= 1
    }

    for i in stride(from: 3, to: Int(Double(num).squareRoot())+1, by:2){
        while num % i == 0{
            max = i
            num = num / i
        }
    }

    if num > 2{
        max = num
    }

    return max
}
print(maxPrime(num:600851475143))


//4. A palindromic number reads the same both ways. The largest palindrome made from the product of two 2-digit numbers is 9009 = 91 × 99. Find the largest palindrome made from the product of two 3-digit numbers.
func isPalindrome(str: String) -> Bool{
    var lo = 0
    var hi = str.count-1
    while hi > lo{
        let start = str.index(str.startIndex, offsetBy: lo)
        let last = str.index(str.startIndex, offsetBy: hi)
        if String(str[start]) != String(str[last]){
            return false
        }
        lo += 1
        hi -= 1
    }
    return true
}
func maxPalindrome() -> Int{
    var max = -1
    for i in stride(from:999, to: 100, by: -1) {
        for j in stride(from:999, to: 100, by: -1) {
            let res = i*j
            let str = String(res)
            if res > max && isPalindrome(str: str){
                max = res
            }
        }
    }
    return max
}
print(maxPalindrome())


//5. 2520 is the smallest number that can be divided by each of the numbers from 1 to 10 without any remainder. What is the smallest positive number that is evenly divisible by all of the numbers from 1 to 20?
func isEven(num: Int) -> Bool{
    for i in 11...20{
        if num % i != 0{
            return false
        }
    }
    return true
}
func smallestMultiple() -> Int{
    var i = 2520
    while !isEven(num: i){
        i += 2520
    }
    return i
}
print(smallestMultiple())


//6.Find the difference between the sum of the squares of the first one hundred natural numbers and the square of the sum.
func sumSquareDifference(num: Int) -> Int{
    var sum1 = 0
    var sum2 = 0
    for i in 0...num{
        sum1 += i*i
        sum2 += i
    }
    return sum2*sum2 - sum1
}
print(sumSquareDifference(num: 100))


//7. By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can see that the 6th prime is 13. What is the 10 001st prime number?
func isPrime(num: Int) -> Bool{
    if num == 2{
        return true
    }

    if num % 2 == 0{
        return false
    }

    for i in stride(from:3, to:Int(Double(num).squareRoot())+1, by:2){
        if num % i == 0{
            return false
        }
    }
    return true
}
func findPrime(index: Int) -> Int{
    var count = 0
    var i = 2
    while count != index{
        if isPrime(num: i){
            count += 1
        }
        i += 1
    }
    return i-1
}
print(findPrime(index: 10001))

//8. Find the thirteen adjacent digits in the 1000-digit number that have the greatest product. What is the value of this product?
func calculateMultiple(arr: [Int], start: Int, count: Int) -> Int{
    var res = 1
    for i in 0..<count{
        res *= arr[start+i]
    }
    return res
}
func largestProduct(arr: [Int], count: Int) -> [Int]{
    var max = -1
    var digits = ""
    for var i in 0..<arr.count-count{
        let temp = calculateMultiple(arr: arr, start: i, count: count)
        if temp > max{
            max = temp
            digits = ""
            for j in 0..<count{
                digits.append(String(arr[i+j]))
            }
        }
        while i+count+1 < arr.count && arr[i] >= arr[i+count+1]{
            i += 1
        }
    }
    return [Int(digits)!, max]
}
let str = "7316717653133062491922511967442657474235534919493496983520312774506326239578318016984801869478851843858615607891129494954595017379583319528532088055111254069874715852386305071569329096329522744304355766896648950445244523161731856403098711121722383113622298934233803081353362766142828064444866452387493035890729629049156044077239071381051585930796086670172427121883998797908792274921901699720888093776657273330010533678812202354218097512545405947522435258490771167055601360483958644670632441572215539753697817977846174064955149290862569321978468622482839722413756570560574902614079729686524145351004748216637048440319989000889524345065854122758866688116427171479924442928230863465674813919123162824586178664583591245665294765456828489128831426076900422421902267105562632111110937054421750694165896040807198403850962455444362981230987879927244284909188845801561660979191338754992005240636899125607176060588611646710940507754100225698315520005593572972571636269561882670428252483600823257530420752963450"
let digits = str.flatMap{Int(String($0))}
print(largestProduct(arr: digits, count: 13))

//9.There exists exactly one Pythagorean triplet for which a + b + c = 1000. Find the product abc.
func tripleProduct(sum: Int) -> Int{
    for i in 1...sum/3{
        for j in 1...sum/2{
            let k = sum - i - j
            if i*i + j*j == k*k{
                return i*j*k
            }
        }
    }
    return -1
}
print(tripleProduct(sum: 1000))

//10. The sum of the primes below 10 is 2 + 3 + 5 + 7 = 17. Find the sum of all the primes below two million.
func isPrime(num: Int) -> Bool{
    if num == 1 || num == 0{
        return false
    }

    if num == 2{
        return true
    }

    if num % 2 == 0{
        return false
    }

    for i in stride(from:3, to:Int(Double(num).squareRoot())+1, by:2){
        if num % i == 0{
            return false
        }
    }
    return true
}

func sumPrime(max: Int) -> Int{
    var sum = 0
    for i in 0...max/2-1{
        if isPrime(num: i){
            sum += i
        }
        if isPrime(num: max-i){
            sum += max-i
        }
    }
    if isPrime(num: max/2){
        sum += max/2
    }
    return sum
}
print(sumPrime(max: 2000000))



