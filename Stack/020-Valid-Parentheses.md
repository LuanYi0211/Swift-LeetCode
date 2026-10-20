# LeetCode 20 — Valid Parentheses（有效的括号）

**难度：** Easy  
**标签：** Stack、String、Dictionary  
**语言：** Swift  
**完成状态：** ✅ Accepted  
**首次提交：** Runtime 1 ms / Memory 19.6 MB
https://leetcode.com/problems/valid-parentheses

## 1. 题目描述

给定一个只包含 `(`、`)`、`{`、`}`、`[`、`]` 的字符串 `s`，判断括号是否有效。

有效条件：

1. 左括号必须由相同类型的右括号闭合。
2. 左右括号必须按照正确的顺序闭合。
3. 每个右括号都必须有对应的左括号。

**示例：**

| 输入 | 输出 | 原因 |
|---|---|---|
| `"()"` | `true` | 正确匹配 |
| `"()[]{}"` | `true` | 三组括号均正确匹配 |
| `"(]"` | `false` | 括号类型不一致 |
| `"([])"` | `true` | 嵌套顺序正确 |
| `"([)]"` | `false` | 闭合顺序错误 |

## 2. 解题思路

### 核心思想：栈（Stack）

栈是一种 **后进先出（LIFO，Last In First Out）** 的数据结构。

括号匹配的特点是：**最后出现的、尚未闭合的左括号，必须最先被闭合。**

因此可以使用栈解决：

1. 遇到左括号，将其压入栈。
2. 遇到右括号，检查栈顶是否为对应的左括号。
3. 如果匹配，弹出栈顶；否则直接返回 `false`。
4. 遍历结束后，只有栈为空时才返回 `true`。

例如，`"([])"` 的匹配过程：

```text
字符       栈
 (         (
 [         ( [
 ]         (
 )         空

最终栈为空 → true
```

而 `"([)]"`：

```text
字符       栈
 (         (
 [         ( [
 )         栈顶是 [，与 ) 不匹配

立即返回 false
```

这说明仅仅统计左右括号数量是不够的，还必须检查闭合顺序。

## 3. 我的原始解法

**思路：左括号入栈，右括号逐个判断。**

```swift
func isValid(_ s: String) -> Bool {
    var stack: [Character] = []

    for char in s {
        if char == "(" || char == "{" || char == "[" {
            stack.append(char)
        } else {
            if char == ")" {
                if stack.last == "(" {
                    stack.removeLast()
                } else {
                    return false
                }
            } else if char == "]" {
                if stack.last == "[" {
                    stack.removeLast()
                } else {
                    return false
                }
            } else {
                if stack.last == "{" {
                    stack.removeLast()
                } else {
                    return false
                }
            }
        }
    }

    if stack.isEmpty {
        return true
    } else {
        return false
    }
}
```

**运行结果：** Accepted，1 ms，19.6 MB。

**优点：**
- 思路正确，能够处理不同类型和嵌套的括号。
- 使用 `stack.last` 判断栈顶，避免直接访问空栈。
- 遇到错误匹配时立即返回，提高效率。

**可以改进的地方：**
- `if-else` 嵌套较多。
- `stack.last` 和 `stack.removeLast()` 可以合并为 `stack.popLast()`。
- 最后的布尔判断可以直接写成 `return stack.isEmpty`。

## 4. 优化解法一：switch + popLast()

```swift
func isValid(_ s: String) -> Bool {
    var stack: [Character] = []

    for char in s {
        switch char {
        case "(", "[", "{":
            stack.append(char)
        case ")":
            if stack.popLast() != "(" { return false }
        case "]":
            if stack.popLast() != "[" { return false }
        case "}":
            if stack.popLast() != "{" { return false }
        default:
            return false
        }
    }

    return stack.isEmpty
}
```

**优化点：**

- `switch` 代替多层条件分支，结构更清晰。
- `popLast()` 同时完成取出栈顶和删除元素。
- `popLast()` 在空栈时返回 `nil`，不会崩溃。
- 直接返回 `stack.isEmpty`。

## 5. 优化解法二：存储期望的右括号（推荐）

**核心变化：不再存储左括号，而是存储未来期望匹配的右括号。**

```swift
func isValid(_ s: String) -> Bool {
    var stack: [Character] = []

    for char in s {
        switch char {
        case "(":
            stack.append(")")
        case "[":
            stack.append("]")
        case "{":
            stack.append("}")
        default:
            if stack.popLast() != char {
                return false
            }
        }
    }

    return stack.isEmpty
}
```

例如输入 `"([])"`：

```text
当前字符     操作           栈
(            push(")")      [")"]
[            push("]")      [")", "]"]
]            pop → "]"      [")"]
)            pop → ")"      []

最终栈为空 → true
```

**优势：**
- 右括号只需要一次统一的匹配判断。
- 减少重复代码。
- 无需额外的字典。
- 保持线性时间复杂度。

## 6. 优化解法三：Dictionary + Stack

使用字典记录右括号与左括号的对应关系。

```swift
func isValid(_ s: String) -> Bool {
    var stack: [Character] = []

    let pairs: [Character: Character] = [
        ")": "(",
        "]": "[",
        "}": "{"
    ]

    for char in s {
        if let expected = pairs[char] {
            if stack.popLast() != expected {
                return false
            }
        } else {
            stack.append(char)
        }
    }

    return stack.isEmpty
}
```

这里的：

```swift
if let expected = pairs[char]
```

表示：

- 如果字典中存在当前字符对应的值，说明当前字符是右括号。
- 将对应的左括号解包为 `expected`。
- 否则当前字符是左括号，直接入栈。

由于题目保证只包含六种括号，因此可以直接将字典中不存在的字符视为左括号。

## 7. 复杂度分析

设字符串长度为 `n`。

| 解法 | 时间复杂度 | 空间复杂度 |
|---|---|---|
| 原始栈解法 | O(n) | O(n) |
| switch + popLast | O(n) | O(n) |
| 存储期望右括号 | O(n) | O(n) |
| Dictionary + Stack | O(n) | O(n) |

**时间复杂度：O(n)**

每个字符最多入栈一次、出栈一次，因此总体为线性时间。

**空间复杂度：O(n)**

最坏情况下，字符串全部由左括号组成，栈需要存储 `n` 个字符。

## 8. Swift 知识点与易错点

### 8.1 `last`、`removeLast()` 和 `popLast()`

| 方法 | 功能 | 空数组时 |
|---|---|---|
| `last` | 获取最后一个元素，不删除 | 返回 `nil` |
| `removeLast()` | 删除并返回最后一个元素 | 运行时错误 |
| `popLast()` | 删除并返回最后一个元素 | 返回 `nil` |

推荐在括号匹配中使用：

```swift
if stack.popLast() != "(" {
    return false
}
```

当栈为空时，`popLast()` 返回 `nil`，比较结果为不相等，因此安全地返回 `false`。

### 8.2 `isEmpty` 本身就是 Bool

不需要：

```swift
if stack.isEmpty {
    return true
} else {
    return false
}
```

直接使用：

```swift
return stack.isEmpty
```

### 8.3 为什么不能只判断括号数量？

例如：

```text
([)]
```

虽然每种括号的左右数量都相等，但顺序不正确。

栈能够检查**最近一个尚未匹配的左括号**，因此可以处理嵌套关系。

### 8.4 为什么最后还要检查空栈？

例如：

```text
(((
```

遍历过程中没有出现错误的右括号，但仍有左括号没有闭合。

因此必须在结束时检查：

```swift
return stack.isEmpty
```

### 8.5 为什么不能直接使用 `removeLast()`？

如果输入是：

```text
")"
```

栈为空，直接调用 `removeLast()` 会导致运行时错误。

`popLast()` 返回可选值，更适合这种可能出现空栈的情况。

## 9. 总结与复盘

**本次掌握：**
- 使用栈解决括号匹配问题。
- 理解 LIFO（后进先出）的特点。
- 学会使用 `last`、`removeLast()`、`popLast()`。
- 使用 `switch` 简化条件分支。
- 使用 `Dictionary` 表示匹配关系。
- 学会将“存储已有左括号”转换为“存储期望右括号”。

**原始解法评价：**

第一次提交就通过全部测试，算法思路正确，没有必要为了追求更低的运行时间而更换算法。

后续优化主要集中在代码简洁性、可读性以及 Swift 标准库的使用。

**重点记忆：**

> 括号匹配的核心是后进先出。遇到左括号入栈，遇到右括号检查栈顶，最后判断栈是否为空。

**后续复习方向：**

- LeetCode 155 — Min Stack
- LeetCode 1047 — Remove All Adjacent Duplicates In String
- LeetCode 150 — Evaluate Reverse Polish Notation
