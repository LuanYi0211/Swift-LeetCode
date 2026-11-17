# 70. Climbing Stairs

- **Difficulty:** Easy
- **Language:** Swift
- **Topics:** Dynamic Programming, Recursion, Math
- **Date:** 2026-11-17
- **Problem:** [LeetCode 70](https://leetcode.com/problems/climbing-stairs/)

## 1. 题目描述

假设需要爬 n 阶楼梯才能到达楼顶，每次可以爬 1 阶或 2 阶，求到达楼顶一共有多少种不同的方法。

### Example 1

```text
Input: n = 2
Output: 2

1 + 1
2
```

### Example 2

```text
Input: n = 3
Output: 3

1 + 1 + 1
1 + 2
2 + 1
```

### Constraints

- 1 <= n <= 45

## 2. 解题难点

本题的主要难点不是代码实现，而是如何将原问题划分为规模更小的子问题。

最初容易从第一步出发，考虑每次应该爬 1 阶还是 2 阶，但这样容易陷入对所有路径的枚举。

更有效的思考方式是从最后一步出发，分析到达当前状态之前可能处于哪些状态。

## 3. 解题思路

### 3.1 划分子问题

假设需要到达第 n 阶楼梯，最后一步只有两种可能：

- 从第 n-1 阶楼梯向上走 1 阶。
- 从第 n-2 阶楼梯向上走 2 阶。

因此，原问题可以划分为：

1. 到达第 n-1 阶楼梯有多少种方法？
2. 到达第 n-2 阶楼梯有多少种方法？

两类方法的最后一步不同，因此不存在重复计算路径的问题。

```text
               第 n 阶
              /       \
          走 1 阶     走 2 阶
            /           \
        第 n-1 阶     第 n-2 阶
```

### 3.2 定义 DP 状态

令 `dp[i]` 表示到达第 i 阶楼梯的不同方法数量。

### 3.3 状态转移方程

```text
dp[i] = dp[i - 1] + dp[i - 2]
```

例如：

```text
dp[5] = dp[4] + dp[3]
      = 5 + 3
      = 8
```

### 3.4 初始化条件

```swift
dp[1] = 1
dp[2] = 2
```

只有 1 阶楼梯时，存在一种方法；有 2 阶楼梯时，存在两种方法。

### 3.5 确定遍历顺序

由于当前状态依赖前两个状态，因此应该从前向后遍历。

### 3.6 确定返回值

返回 `dp[n]`，即到达第 n 阶楼梯的方法总数。

## 4. 解法一：普通递归

根据状态转移方程，可以直接编写递归函数。

```swift
class Solution {
    func climbStairs(_ n: Int) -> Int {
        if n <= 2 {
            return n
        }

        return climbStairs(n - 1) + climbStairs(n - 2)
    }
}
```

### 存在的问题

虽然递归逻辑正确，但是会重复计算相同的子问题。

以 n = 5 为例：

```text
                f(5)
               /    \
            f(4)    f(3)
           /   \    /   \
        f(3)  f(2) f(2) f(1)
        /  \
     f(2) f(1)
```

其中 `f(3)` 和 `f(2)` 被重复计算。

这种现象称为 **Overlapping Subproblems（重叠子问题）**。

随着 n 增大，递归调用次数呈指数级增长，容易导致 Time Limit Exceeded。

### 复杂度

- Time Complexity: O(2^n)，更紧确的量级约为 O(1.618^n)
- Space Complexity: O(n)

## 5. 解法二：动态规划数组

使用数组保存已经计算过的子问题结果，避免重复计算。

```swift
class Solution {
    func climbStairs(_ n: Int) -> Int {
        if n <= 2 {
            return n
        }

        var dp = Array(repeating: 0, count: n + 1)

        dp[1] = 1
        dp[2] = 2

        for i in 3...n {
            dp[i] = dp[i - 1] + dp[i - 2]
        }

        return dp[n]
    }
}
```

### 执行过程

以 n = 6 为例：

| i | 状态转移 | dp[i] |
|---|---|---:|
| 1 | 初始化 | 1 |
| 2 | 初始化 | 2 |
| 3 | 2 + 1 | 3 |
| 4 | 3 + 2 | 5 |
| 5 | 5 + 3 | 8 |
| 6 | 8 + 5 | 13 |

最终数组：

```text
Index:  0  1  2  3  4  5   6
Value:  0  1  2  3  5  8  13
```

这里的 `dp[0]` 只是未使用的占位元素，不参与状态转移。

如果将状态定义扩展到 0 阶楼梯，那么 `dp[0]` 在数学上应为 1，表示什么都不做这一种方法。

### 复杂度

- Time Complexity: O(n)
- Space Complexity: O(n)

## 6. 解法三：滚动变量优化

观察状态转移方程：

```text
dp[i] = dp[i - 1] + dp[i - 2]
```

每次计算只依赖前两个状态，不需要保存完整的 DP 数组。

因此，可以使用两个变量代替数组。

```swift
class Solution {
    func climbStairs(_ n: Int) -> Int {
        if n <= 2 {
            return n
        }

        var prev2 = 1
        var prev1 = 2

        for _ in 3...n {
            let current = prev1 + prev2

            prev2 = prev1
            prev1 = current
        }

        return prev1
    }
}
```

### 变量含义

| Variable | Meaning |
|---|---|
| prev2 | dp[i - 2] |
| prev1 | dp[i - 1] |
| current | dp[i] |

### 执行过程

| 当前阶数 | prev2（更新前） | prev1（更新前） | current |
|---:|---:|---:|---:|
| 3 | 1 | 2 | 3 |
| 4 | 2 | 3 | 5 |
| 5 | 3 | 5 | 8 |
| 6 | 5 | 8 | 13 |

每次计算结束后，将两个变量向前移动一位。

### 复杂度

- Time Complexity: O(n)
- Space Complexity: O(1)

这种方法也称为 **Space-Optimized Dynamic Programming（空间优化动态规划）**。

## 7. 解法对比

| Approach | Time | Space |
|---|---|---|
| Recursion | 指数级 | O(n) |
| Dynamic Programming | O(n) | O(n) |
| Space-Optimized DP | O(n) | O(1) |

最终推荐使用滚动变量解法，但学习动态规划时，应优先掌握完整 DP 数组的写法。

## 8. Swift 知识点与易错点

### 8.1 初始化固定长度数组

```swift
var dp = Array(repeating: 0, count: n + 1)
```

创建一个长度为 n+1、所有元素初始值为 0 的数组。

由于 Swift 数组从索引 0 开始，如果需要访问 `dp[n]`，数组长度至少为 n+1。

### 8.2 Closed Range 的边界问题

```swift
for i in 3...n
```

Swift 的闭区间要求下界不能大于上界。

如果 n = 2，则 `3...2` 会产生运行时错误。

因此需要提前处理：

```swift
if n <= 2 {
    return n
}
```

同时避免 n = 1 时访问 `dp[2]` 导致数组越界。

### 8.3 使用下划线忽略循环变量

```swift
for _ in 3...n {
    // ...
}
```

当循环内部不需要使用索引时，可以使用 `_` 忽略循环变量。

### 8.4 变量更新顺序

正确写法：

```swift
let current = prev1 + prev2
prev2 = prev1
prev1 = current
```

错误写法：

```swift
prev2 = prev1
prev1 = prev1 + prev2
```

错误写法提前覆盖了原来的 `prev2`，导致计算结果错误。

更新变量前，需要确认旧数据是否仍然参与后续计算。

## 9. Test Cases

以下为预期测试结果：

| Input | Expected Output | Purpose |
|---:|---:|---|
| 1 | 1 | 最小输入 |
| 2 | 2 | 初始化边界 |
| 3 | 3 | 第一次状态转移 |
| 5 | 8 | 普通情况 |
| 6 | 13 | 多轮状态转移 |
| 45 | 1836311903 | 最大输入 |

## 10. 总结与复盘

本题学习的核心内容：

- 如何从最后一次操作出发划分子问题。
- 如何定义 DP 状态。
- 如何推导状态转移方程。
- 如何识别重叠子问题。
- 如何通过保存状态避免重复计算。
- 如何根据状态之间的依赖关系优化空间复杂度。

### 动态规划通用解题流程

```text
1. 确定 DP 状态及下标的含义
2. 推导状态转移方程
3. 确定初始化条件
4. 确定遍历顺序
5. 确定最终返回值
```

### Key Takeaway

当无法确定如何划分子问题时，可以尝试分析到达当前状态的最后一次操作。

不要仅仅通过观察数字规律得出递推公式，而应该从题目的约束出发，证明子问题之间的关系。

动态规划的核心之一是保存和复用子问题的结果，从而避免重复计算。

## 11. Related Problems

- [509. Fibonacci Number](https://leetcode.com/problems/fibonacci-number/)
- [1137. N-th Tribonacci Number](https://leetcode.com/problems/n-th-tribonacci-number/)
- [746. Min Cost Climbing Stairs](https://leetcode.com/problems/min-cost-climbing-stairs/)
- [198. House Robber](https://leetcode.com/problems/house-robber/)
- [62. Unique Paths](https://leetcode.com/problems/unique-paths/)

## 12. Review Checklist

- [ ] 能够独立划分子问题
- [ ] 能够解释为什么两个子问题的结果可以直接相加
- [ ] 能够独立推导状态转移方程
- [ ] 能够解释普通递归为什么效率低
- [ ] 能够独立编写 DP 数组解法
- [ ] 能够独立编写滚动变量解法
- [ ] 能够正确分析时间和空间复杂度
