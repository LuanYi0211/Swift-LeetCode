func twoSum(_ nums: [Int], target: Int) -> (Int, Int)? {
    var dict = [Int: Int]()
    
    // For every number n,
    for (currentIndex, n) in nums.enumerated() {
        // Find the complement to n that would sum up to the target.
        let complement = target - n
        
        // Check if the complement is in the dictionary.
        if let complementIndex = dict[complement] {
            return (complementIndex, currentIndex)
        }
        
        // Store n and its index into the dictionary.
        dict[n] = currentIndex
    }
    
    return nil
}
