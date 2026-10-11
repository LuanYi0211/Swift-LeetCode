# 217. Contains Duplicate

## 1. Basic Info

- **Problem:** Contains Duplicate
- **LeetCode:** 217
- **Topic:** Array / Set / Hashing
- **Difficulty:** Easy
- **Language:** Swift
- **Result:** 初始解法 `Time Limit Exceeded`
- **Main issue:** 时间复杂度过高

---

## 2. Core Problem

给定一个整数数组 `nums`：

- 如果任意一个数字出现至少两次，返回 `true`
- 如果所有数字都只出现一次，返回 `false`

例如：

```swift
nums = [1, 2, 3, 1]
// true
```

因为 `1` 出现了两次。

---

## 3. First Reaction

最开始想到的方法是：

> 对每一个数字，都和它后面的所有数字进行比较。

因此使用两层循环：

```swift
func containsDuplicate(_ nums: [Int]) -> Bool {
    for i in 0..<nums.count - 1 {
        for j in i + 1..<nums.count {
            if nums[i] == nums[j] {
                return true
            }
        }
    }

    return false
}
```

这个逻辑本身是正确的。

例如：

```swift
nums = [1, 2, 3, 4]
```

比较顺序：

```text
1 vs 2
1 vs 3
1 vs 4

2 vs 3
2 vs 4

3 vs 4
```

如果遇到相同元素，就立即：

```swift
return true
```

否则最终：

```swift
return false
```

---

## 4. Solution 1 - Brute Force

### 思路

枚举所有可能的两个位置：

```swift
nums[i]
nums[j]
```

判断：

```swift
nums[i] == nums[j]
```

为了避免自己和自己比较，也避免重复比较：

```swift
j
```

从：

```swift
i + 1
```

开始。

### Code

```swift
func containsDuplicate(_ nums: [Int]) -> Bool {
    for i in 0..<nums.count - 1 {
        for j in i + 1..<nums.count {
            if nums[i] == nums[j] {
                return true
            }
        }
    }

    return false
}
```

### Complexity

时间复杂度：

```text
O(n²)
```

空间复杂度：

```text
O(1)
```

### 为什么会 Time Limit Exceeded？

题目中：

```text
nums.length <= 100000
```

如果数组中的数字全部不同，就需要进行大约：

```text
n × (n - 1) / 2
```

次比较。

当：

```text
n = 100000
```

时，大约需要：

```text
5,000,000,000
```

次比较。

因此虽然算法逻辑正确，但速度太慢，导致：

```text
Time Limit Exceeded
```

---

## 5. Solution 2 - Set

### 核心思路

这道题真正需要知道的其实不是：

> 当前数字和后面的每一个数字是否相同？

而是：

> **这个数字以前出现过吗？**

因此可以使用 `Set` 保存已经遇到过的数字。

遍历每个数字时：

1. 检查它是否已经存在于 `Set`
2. 如果存在，说明重复，直接返回 `true`
3. 如果不存在，把它加入 `Set`
4. 全部遍历结束仍未发现重复，返回 `false`

### Code

```swift
func containsDuplicate(_ nums: [Int]) -> Bool {
    var seen = Set<Int>()

    for num in nums {
        if seen.contains(num) {
            return true
        }

        seen.insert(num)
    }

    return false
}
```

---

## 6. Example Walkthrough

```swift
nums = [1, 2, 3, 1]
```

开始：

```text
seen = {}
```

### num = 1

```swift
seen.contains(1) // false
```

加入：

```text
seen = {1}
```

### num = 2

```swift
seen.contains(2) // false
```

加入：

```text
seen = {1, 2}
```

### num = 3

```swift
seen.contains(3) // false
```

加入：

```text
seen = {1, 2, 3}
```

### num = 1

```swift
seen.contains(1) // true
```

说明之前已经出现过：

```swift
return true
```

---

## 7. Complexity

### Brute Force

```text
Time:  O(n²)
Space: O(1)
```

### Set

平均：

```text
Time:  O(n)
Space: O(n)
```

通过增加额外的存储空间，避免了第二层循环。

---

## 8. Error Log

### Symptom

LeetCode 提交结果：

```text
Time Limit Exceeded
```

### Cause

使用了两层循环：

```swift
for i in ...
    for j in ...
```

最坏情况下需要比较接近：

```text
n²
```

次。

当输入规模达到：

```text
100000
```

时无法在规定时间内完成。

### Fix

使用：

```swift
Set<Int>
```

保存已经出现过的数字：

```swift
var seen = Set<Int>()
```

每次只需要询问：

```swift
seen.contains(num)
```

而不是和之前所有数字逐个比较。

### Prevention

以后看到下面这一类问题：

```text
是否出现过？
是否重复？
之前见过这个值吗？
两个集合有没有相同元素？
```

优先考虑：

```text
Set
```

或：

```text
Dictionary
```

不要第一反应就使用双循环逐个比较。

---

## 9. Swift Knowledge

### 创建空 Set

```swift
var seen = Set<Int>()
```

表示创建一个只能存放 `Int` 的空集合。

### 插入元素

```swift
seen.insert(num)
```

### 判断元素是否存在

```swift
seen.contains(num)
```

返回：

```swift
Bool
```

即：

```text
true / false
```

### Set 的特点

`Set`：

- 不保存重复元素
- 适合判断元素是否已经存在
- 不保证元素顺序
- `contains()` 平均查找速度比数组逐个搜索更快

---

## 10. Alternative Swift Solution

还可以直接利用 `Set` 自动去重：

```swift
func containsDuplicate(_ nums: [Int]) -> Bool {
    return Set(nums).count != nums.count
}
```

原数组：

```swift
[1, 2, 3, 1]
```

长度：

```text
4
```

转换成：

```swift
Set(nums)
```

以后只有：

```text
{1, 2, 3}
```

长度：

```text
3
```

因此：

```swift
3 != 4
```

返回：

```swift
true
```

不过算法练习阶段更推荐手动遍历 `Set` 的版本，因为能够清楚体现：

```text
检查是否出现过
→ 没出现则记录
→ 出现过则返回
```

的思考过程。

---

## 11. Pattern

### Hash Set - Seen Before

这道题属于非常典型的：

```text
Seen Before
```

模式。

模板：

```swift
var seen = Set<Int>()

for value in nums {
    if seen.contains(value) {
        // 已经出现过
    }

    seen.insert(value)
}
```

以后遇到：

```text
duplicate
unique
distinct
seen before
already exists
```

这些关键词时，可以考虑这个模式。

---

## 12. 与 Two Sum 的联系

之前的 Two Sum 暴力解也是：

```text
两层循环
→ O(n²)
```

优化后使用：

```text
Dictionary
→ O(n)
```

这道题也是：

```text
两层循环
→ O(n²)
```

优化后使用：

```text
Set
→ O(n)
```

两道题背后的核心思想类似：

> **用额外的空间保存之前见过的信息，从而避免再次遍历。**

区别是：

### Contains Duplicate

只关心：

```text
这个数字以前有没有出现
```

所以用：

```swift
Set
```

### Two Sum

除了知道数字是否出现，还需要知道：

```text
它对应的 index 是多少
```

所以使用：

```swift
Dictionary<Int, Int>
```

保存：

```text
数字 → index
```

---

## 13. What I Learned

1. 算法结果正确，不代表算法一定能够通过测试。
2. 需要结合题目的数据规模判断时间复杂度。
3. 两层遍历通常意味着需要警惕 `O(n²)`。
4. 判断“某个值之前是否出现过”时，可以优先考虑 `Set`。
5. `Set` 和 `Dictionary` 都可以通过额外空间减少重复搜索。
6. 优化算法时，不应该只考虑“能不能得到正确答案”，还需要考虑输入变大以后需要多少操作。

---

## 14. D+7 Redo

一周后不看答案重新完成这道题。

需要能够回答：

### 1. 为什么原来的代码会 TLE？

```text
因为双循环的时间复杂度是 O(n²)，题目最多有 100000 个元素。
```

### 2. 为什么 Set 可以优化？

```text
因为它可以快速判断一个元素之前是否已经出现过，
从而不需要再次遍历之前所有元素。
```

### 3. 写出核心模板

```swift
var seen = Set<Int>()

for num in nums {
    if seen.contains(num) {
        return true
    }

    seen.insert(num)
}

return false
```

### 4. 说出复杂度

```text
Time:  O(n) average
Space: O(n)
```

### 5. 延伸问题

如果除了判断是否重复，还要求：

```text
返回第一次出现这个数字的 index
```

应该考虑：

```text
Dictionary
```

而不是只使用 `Set`。
