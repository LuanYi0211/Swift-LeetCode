# 1. Two Sum

LeetCode:
https://leetcode.com/problems/two-sum/

## 基本信息

- 日期：2026-10-04
- 难度：Easy
- 题型：Array / HashMap
- 是否独立完成：是 / 否
- 用时：35 min
- 提示次数：0
- D+7 复做日期：
- D+30 复做日期：

---

## 题目核心

给定数组 nums 和 target，找到两个数使它们之和等于 target，
返回这两个数的下标。

---

## 第一反应

最直观的方法：

遍历所有 `(i, j)` 组合，检查：

nums[i] + nums[j] == target

时间复杂度 O(n²)。

---

## Solution 1：Brute Force

思路：

两层循环检查所有元素组合。

Time:
O(n²)

Space:
O(1)

问题：

数组变大之后效率很低。

---

## Solution 2：Hash Map

核心观察：

如果当前数字是：

x

那么需要找：

target - x

所以可以用 Dictionary 记录：

value -> index

每访问一个元素时检查 complement 是否已经出现。

Time:
O(n)

Space:
O(n)

---

## 我犯的错误 / Debug Log

### Error 1

报错：

Index out of range

原因：

内层循环写成：

for j in i + 1...nums.count

但 nums.count 本身已经越界。

正确：

for j in i + 1..<nums.count

为什么：

Swift 数组有效下标是：

0 ..< nums.count

以后如何避免：

涉及数组循环时先确认是 `..<` 还是 `...`。

---

## Edge Cases

- 数组只有两个元素
- target 为负数
- 存在重复数字，例如 [3, 3]
- complement 已经出现
- complement 尚未出现

---

## Swift 知识点

```swift
var seen: [Int: Int] = [:]

if let index = seen[complement] {
    ...
}

seen[number] = i
