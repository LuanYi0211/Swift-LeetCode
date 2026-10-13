# 242. Valid Anagram

## 1. Basic Info

- **Problem:** Valid Anagram
- **LeetCode:** 242
- **Topic:** String / Hash Table / Sorting
- **Difficulty:** Easy
- **Language:** Swift
- **Initial Solution:** Sorting
- **Optimization:** Dictionary frequency counting
- https://leetcode.com/problems/valid-anagram/description/

---

## 2. Core Problem

给定两个字符串 `s` 和 `t`：

如果 `t` 可以通过重新排列 `s` 中的字符得到，则返回：

```swift
true
```

否则返回：

```swift
false
```

例如：

```swift
s = "anagram"
t = "nagaram"
```

两个字符串中：

```text
a × 3
n × 1
g × 1
r × 1
m × 1
```

每个字符出现次数完全相同，因此：

```swift
true
```

---

## 3. First Reaction

最开始想到：

> 如果两个字符串是 anagram，那么把它们排序以后应该完全相同。

因此写出：

```swift
func isAnagram(_ s: String, _ t: String) -> Bool {
    if s.sorted() == t.sorted() {
        return true
    } else {
        return false
    }
}
```

这个解法是正确的。

因为：

```swift
"anagram".sorted()
```

和：

```swift
"nagaram".sorted()
```

都会得到相同的字符序列。

---

## 4. Simplify Initial Solution

因为：

```swift
s.sorted() == t.sorted()
```

本身已经会返回：

```swift
Bool
```

所以不需要额外写：

```swift
if ... {
    return true
} else {
    return false
}
```

可以直接：

```swift
func isAnagram(_ s: String, _ t: String) -> Bool {
    s.sorted() == t.sorted()
}
```

---

## 5. Solution 1 - Sorting

### Code

```swift
func isAnagram(_ s: String, _ t: String) -> Bool {
    s.sorted() == t.sorted()
}
```

### 思路

分别排序：

```text
anagram
↓
aaagmnr
```

```text
nagaram
↓
aaagmnr
```

排序结果相同，因此返回：

```swift
true
```

---

## 6. Complexity of Sorting

排序通常需要：

```text
O(n log n)
```

所以整体时间复杂度约为：

```text
O(n log n)
```

空间复杂度：

```text
O(n)
```

因为 `sorted()` 会生成新的数组。

这个解法：

- 代码非常短
- 容易理解
- 可以通过题目

但不是理论上的最优解。

---

## 7. Better Solution - Dictionary Frequency Counting

这道题真正需要知道的是：

> 每一个字符分别出现了多少次？

因此可以使用：

```swift
Dictionary<Character, Int>
```

保存：

```text
字符 → 出现次数
```

例如：

```text
"a" → 3
"n" → 1
"g" → 1
```

---

## 8. Optimized Code

```swift
func isAnagram(_ s: String, _ t: String) -> Bool {
    if s.count != t.count {
        return false
    }

    var counts: [Character: Int] = [:]

    for char in s {
        counts[char, default: 0] += 1
    }

    for char in t {
        counts[char, default: 0] -= 1

        if counts[char, default: 0] < 0 {
            return false
        }
    }

    return true
}
```

---

## 9. Why Check Length First?

如果：

```swift
s.count != t.count
```

那么两个字符串一定不可能是 anagram。

例如：

```swift
s = "cat"
t = "cats"
```

长度：

```text
3 != 4
```

直接：

```swift
return false
```

不需要继续统计字符。

---

## 10. Dictionary Counting Logic

先遍历：

```swift
s
```

每遇到一个字符：

```swift
counts[char, default: 0] += 1
```

例如：

```swift
s = "aab"
```

最终：

```swift
[
    "a": 2,
    "b": 1
]
```

然后遍历：

```swift
t
```

每遇到一个字符就：

```swift
counts[char, default: 0] -= 1
```

如果两个字符串字符组成完全相同，最终所有计数都会回到：

```text
0
```

---

## 11. Why `< 0` Means False?

例如：

```swift
s = "aab"
t = "abb"
```

统计 `s`：

```text
a → 2
b → 1
```

开始处理 `t`：

```text
a → 2 - 1 = 1
b → 1 - 1 = 0
b → 0 - 1 = -1
```

当：

```swift
counts["b"] < 0
```

说明：

> `t` 中的 `b` 比 `s` 中更多。

因此一定不是 anagram：

```swift
return false
```

---

## 12. Swift Knowledge - Dictionary Default Value

代码：

```swift
counts[char, default: 0]
```

表示：

> 如果这个 key 已经存在，使用原来的值；如果不存在，就先把它当成 0。

例如：

```swift
var counts: [Character: Int] = [:]
```

第一次：

```swift
counts["a", default: 0] += 1
```

相当于：

```text
"a" 不存在
↓
默认值 0
↓
0 + 1
↓
"a": 1
```

再次执行：

```swift
counts["a", default: 0] += 1
```

变成：

```text
"a": 2
```

---

## 13. Why Not Use `counts[char]!`?

普通 Dictionary 查询：

```swift
counts[char]
```

返回：

```swift
Int?
```

因为这个 key 可能不存在。

所以：

```swift
counts[char]!
```

表示：

> 强制解包 Optional，我确定这里一定有值。

例如：

```swift
if counts[char]! < 0 {
    return false
}
```

这里的：

```text
!
```

和：

```text
< 0
```

是两件不同的事。

真正结构是：

```swift
(counts[char]!) < 0
```

为了避免强制解包，可以写成：

```swift
counts[char, default: 0]
```

因此更推荐：

```swift
if counts[char, default: 0] < 0 {
    return false
}
```

---

## 14. Complexity

### Sorting Solution

```text
Time:  O(n log n)
Space: O(n)
```

### Dictionary Solution

平均：

```text
Time:  O(n)
Space: O(k)
```

其中：

```text
k = 不同字符的数量
```

因此 Dictionary 解法在时间复杂度上更优。

---

## 15. Further Optimization for Lowercase English Letters

题目保证：

```text
s 和 t 只包含 a-z
```

所以还可以不用 Dictionary，而是创建长度固定为：

```text
26
```

的数组。

例如：

```swift
var counts = Array(repeating: 0, count: 26)
```

每个位置对应：

```text
0  → a
1  → b
2  → c
...
25 → z
```

这样也可以做到：

```text
Time:  O(n)
Space: O(1)
```

因为数组大小固定为 26。

不过当前阶段更推荐掌握：

```swift
Dictionary<Character, Int>
```

版本，因为逻辑更通用。

---

## 16. Unicode Follow-up

题目的 follow-up：

> What if the inputs contain Unicode characters?

如果输入可能包含：

```text
中文
韩文
Emoji
其他 Unicode 字符
```

就不能再假设只有：

```text
a-z
```

因此不能简单使用长度为 26 的数组。

可以继续使用：

```swift
Dictionary<Character, Int>
```

例如：

```swift
func isAnagram(_ s: String, _ t: String) -> Bool {
    if s.count != t.count {
        return false
    }

    var counts: [Character: Int] = [:]

    for char in s {
        counts[char, default: 0] += 1
    }

    for char in t {
        counts[char, default: 0] -= 1

        if counts[char, default: 0] < 0 {
            return false
        }
    }

    return true
}
```

这样可以处理例如：

```swift
s = "你好"
t = "好你"
```

或者：

```swift
s = "가나다"
t = "다나가"
```

---

## 17. Pattern

这道题属于典型的：

```text
Frequency Counting
```

也就是：

> 统计每个元素出现了多少次。

常见模板：

```swift
var counts: [Element: Int] = [:]

for value in values {
    counts[value, default: 0] += 1
}
```

以后题目出现：

```text
frequency
count
same characters
same elements
anagram
occurrence
出现次数
```

可以优先想到：

```text
Dictionary / Hash Map
```

---

## 18. Connection With Previous Problems

最近几道题可以放在一起理解：

### Contains Duplicate

问题：

```text
这个值以前出现过吗？
```

只需要：

```swift
Set
```

---

### Two Sum

问题：

```text
这个值以前出现过吗？
它的 index 是多少？
```

需要：

```swift
Dictionary<Int, Int>
```

保存：

```text
value → index
```

---

### Valid Anagram

问题：

```text
这个字符出现了多少次？
```

需要：

```swift
Dictionary<Character, Int>
```

保存：

```text
character → count
```

可以总结成：

```text
只判断存在性
→ Set

需要额外信息
→ Dictionary
```

---

## 19. Error / Improvement Log

### Initial Idea

```swift
s.sorted() == t.sorted()
```

### Result

正确，可以通过。

### Problem

时间复杂度：

```text
O(n log n)
```

不是最优。

### Improved Idea

不要排序，而是记录：

```text
每个字符出现了多少次
```

使用：

```swift
Dictionary<Character, Int>
```

把复杂度优化到平均：

```text
O(n)
```

---

## 20. What I Learned

1. `sorted()` 可以非常简单地解决 anagram 问题，但复杂度是 `O(n log n)`。
2. 当问题涉及“元素出现次数”时，可以优先考虑 Dictionary。
3. `Dictionary[key]` 返回 Optional。
4. `Dictionary[key, default: 0]` 可以避免频繁解包 Optional。
5. `!` 表示强制解包，不是 `< 0` 的一部分。
6. `counts[char] < 0` 表示某个字符在第二个字符串中出现次数过多。
7. 对固定字符集，可以使用固定长度数组进一步优化空间。
8. 如果需要支持 Unicode，`Dictionary<Character, Int>` 更通用。

---

## 21. D+7 Redo

一周后不看答案重新完成。

需要能够回答：

### 1. 最简单的解法是什么？

```swift
func isAnagram(_ s: String, _ t: String) -> Bool {
    s.sorted() == t.sorted()
}
```

复杂度：

```text
O(n log n)
```

---

### 2. 如何优化到 O(n)？

使用：

```swift
Dictionary<Character, Int>
```

统计字符出现次数。

---

### 3. 写出核心模板

```swift
var counts: [Character: Int] = [:]

for char in s {
    counts[char, default: 0] += 1
}

for char in t {
    counts[char, default: 0] -= 1

    if counts[char, default: 0] < 0 {
        return false
    }
}

return true
```

---

### 4. `default: 0` 是什么？

当 Dictionary 中不存在这个 key 时：

```swift
counts[key, default: 0]
```

会使用：

```text
0
```

作为默认值。

---

### 5. 为什么出现负数就可以直接 false？

因为说明：

```text
t 中某个字符的数量
>
s 中这个字符的数量
```

所以两者一定不是 anagram。

---

### 6. 如果输入包含 Unicode 怎么办？

使用：

```swift
Dictionary<Character, Int>
```

而不是依赖：

```text
26 个英文字母
```
