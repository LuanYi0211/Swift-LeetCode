# LeetCode 125 — Valid Palindrome
https://leetcode.com/problems/valid-palindrome/description/

## 1. 题目描述

给定一个字符串 `s`，判断它是否为回文串。

判断规则：
- 忽略大小写。
- 忽略所有非字母、非数字字符。
- 如果正序和倒序相同，则返回 `true`，否则返回 `false`。
- 空字符串也视为回文串。

## 2. 解题思路

**方法一：过滤字符 + 反转比较**

1. 使用 `lowercased()` 将字符串统一转换为小写。
2. 使用 `filter` 保留字母和数字。
3. 使用 `reversed()` 获取反转后的字符序列。
4. 将反转结果转换为 `String`，与过滤后的字符串比较。

## 3. Swift 实现

```swift
func isPalindrome(_ s: String) -> Bool {
    let chars = s.lowercased().filter {
        $0.isLetter || $0.isNumber
    }

    return chars == String(chars.reversed())
}
```

## 4. 复杂度分析

- **时间复杂度：** \(O(n)\)，其中 \(n\) 为字符串长度。过滤、反转和比较均为线性操作。
- **空间复杂度：** \(O(n)\)，需要额外空间存储过滤后的字符串及反转结果。

## 5. 易错点与 Swift 知识

### 5.1 字符串大小写转换

```swift
s.lowercased()
```

返回转换后的小写字符串，不会直接修改原变量 `s`。

### 5.2 `filter` 过滤字符

```swift
let chars = s.filter {
    $0.isLetter || $0.isNumber
}
```

保留满足条件的字符。对于 `String`，这段写法得到的 `chars` 仍然是 `String`。

### 5.3 `reversed()` 与 `reverse()`

```swift
chars.reversed()
```

返回反向遍历的字符序列，不会直接修改原字符串。

```swift
String(chars.reversed())
```

将反转后的字符序列重新转换为字符串。

注意：`reverse()` 和 `reversed()` 的用途不同，不能混为一谈。

### 5.4 类型必须一致

下面的比较会报错：

```swift
chars == Array(chars.reversed())
```

因为左侧是 `String`，右侧是 `[Character]`。

改为下面的写法即可：

```swift
chars == String(chars.reversed())
```

## 6. 后续优化方向

可以进一步尝试**双指针法（Two Pointers）**：

- 左指针从字符串开头出发，右指针从末尾出发。
- 跳过非字母、非数字字符。
- 比较两侧字符，不一致时直接返回 `false`。
- 两个指针相遇或交错时，返回 `true`。

双指针法可以避免创建完整的反转字符串，适合进一步练习空间优化。

## 7. 总结

这道题主要练习了字符串处理、字符过滤、反转操作和 Swift 类型转换。

本次使用过滤与反转比较的方式，代码简洁、易于理解。掌握基础解法后，可以继续学习双指针法，比较两种方案的空间复杂度和实现差异。
