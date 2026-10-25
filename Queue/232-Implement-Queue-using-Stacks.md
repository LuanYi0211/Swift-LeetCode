# LeetCode 232 — Implement Queue using Stacks（用栈实现队列）

**难度：** Easy  
**标签：** Stack、Queue、Design、Amortized Analysis  
**语言：** Swift
https://leetcode.com/problems/implement-queue-using-stacks

## 1. 题目描述

仅使用两个栈实现一个先进先出（FIFO）的队列 `MyQueue`。

需要实现以下方法：

| 方法 | 功能 |
|---|---|
| `push(_ x: Int)` | 将元素加入队尾 |
| `pop() -> Int` | 删除并返回队首元素 |
| `peek() -> Int` | 返回队首元素，但不删除 |
| `empty() -> Bool` | 判断队列是否为空 |

限制条件：只能使用栈的标准操作，包括入栈、出栈、查看栈顶、获取大小和判断是否为空。

**进阶要求：** 实现每个操作的均摊时间复杂度为 O(1)。

## 2. 解题思路

### 核心思想：双栈模拟队列

栈（Stack）和队列（Queue）的区别：

- **Stack：LIFO（Last In First Out）**，后进先出。
- **Queue：FIFO（First In First Out）**，先进先出。

单个栈无法直接实现队列的出队顺序，但可以通过两个栈反转元素顺序。

定义两个栈：

```swift
var input: [Int] = []
var output: [Int] = []
```

**input（输入栈）：** 负责接收新元素。

**output（输出栈）：** 负责提供队首元素。

操作规则：

1. `push()`：直接将元素压入 `input`。
2. `pop()`：如果 `output` 为空，将 `input` 中的元素依次转移到 `output`，然后弹出 `output` 的栈顶。
3. `peek()`：同样先确保 `output` 有元素，再读取栈顶。
4. `empty()`：只有两个栈都为空，队列才为空。

**关键：只有当 `output` 为空时，才能转移 `input` 中的元素。**

## 3. Swift 实现

```swift
class MyQueue {
    private var input: [Int] = []
    private var output: [Int] = []

    init() {}

    func push(_ x: Int) {
        input.append(x)
    }

    func pop() -> Int {
        moveIfNeeded()
        return output.removeLast()
    }

    func peek() -> Int {
        moveIfNeeded()
        return output.last!
    }

    func empty() -> Bool {
        input.isEmpty && output.isEmpty
    }

    private func moveIfNeeded() {
        if output.isEmpty {
            while let value = input.popLast() {
                output.append(value)
            }
        }
    }
}
```

## 4. 执行过程

例如：

```swift
let queue = MyQueue()

queue.push(1)
queue.push(2)
queue.peek()   // 1
queue.pop()    // 1
queue.empty()  // false
```

栈变化如下，右侧为栈顶：

| 操作 | input | output | 返回 |
|---|---|---|---|
| `push(1)` | `[1]` | `[]` | — |
| `push(2)` | `[1, 2]` | `[]` | — |
| `peek()` | `[]` | `[2, 1]` | `1` |
| `pop()` | `[]` | `[2]` | `1` |
| `empty()` | `[]` | `[2]` | `false` |

当 `input = [1, 2]` 时，转移过程：

```text
input:  [1, 2]
output: []

第一次转移：
input:  [1]
output: [2]

第二次转移：
input:  []
output: [2, 1]
```

此时 `output` 的栈顶为 `1`，正好是最早入队的元素。

## 5. 核心代码解析

### 5.1 为什么要使用两个栈？

一个栈只能实现后进先出。

两个栈可以通过一次元素转移反转顺序，使最早进入 `input` 的元素变成 `output` 的栈顶。

### 5.2 为什么不能每次都转移？

假设：

```text
input  = [3]
output = [2, 1]
```

此时队列的实际顺序是：

```text
1 → 2 → 3
```

下一次 `pop()` 应该返回 `1`。

如果直接将 `input` 中的 `3` 转移到 `output`，就会破坏原有顺序。

因此必须保证：

```swift
if output.isEmpty {
    // 才允许转移
}
```

### 5.3 `while let` 的作用

```swift
while let value = input.popLast() {
    output.append(value)
}
```

`popLast()` 返回 `Int?`。

- 有元素时，弹出并解包到 `value`，继续循环。
- 没有元素时，返回 `nil`，结束循环。

这种写法可以安全地将一个栈中的全部元素转移到另一个栈。

### 5.4 为什么使用 `private`？

```swift
private var input: [Int] = []
private var output: [Int] = []
```

`private` 限制外部代码直接访问或修改这两个栈。

队列只能通过 `push()`、`pop()`、`peek()` 和 `empty()` 操作，从而保护内部数据结构。

## 6. 复杂度分析

设队列最多包含 `n` 个元素。

| 操作 | 最坏时间复杂度 | 均摊时间复杂度 |
|---|---|---|
| `push()` | O(1) 均摊 | O(1) |
| `pop()` | O(n) | O(1) |
| `peek()` | O(n) | O(1) |
| `empty()` | O(1) | O(1) |

**空间复杂度：O(n)**

两个栈合计最多存储 `n` 个元素。

### 为什么 `pop()` 和 `peek()` 是均摊 O(1)？

虽然 `moveIfNeeded()` 包含 `while` 循环，一次转移可能需要 O(n)，但每个元素最多只会：

1. 进入 `input` 一次。
2. 从 `input` 转移到 `output` 一次。
3. 从 `output` 弹出一次。

因此，对于 n 个入队元素，所有转移操作的总成本为 O(n)。

将总成本分摊到这些元素的操作上，每次操作的均摊成本就是 O(1)。

**注意：均摊 O(1) 不代表每一次操作都严格为 O(1)。**

## 7. Swift 知识点与易错点

### 7.1 使用 Array 模拟 Stack

Swift 可以使用数组模拟栈：

| 栈操作 | Swift 方法 |
|---|---|
| Push | `append()` |
| Pop | `popLast()` |
| Peek | `last` |
| Is Empty | `isEmpty` |
| Size | `count` |

这些操作符合题目对栈的限制。

### 7.2 `popLast()` 与 `removeLast()`

```swift
stack.popLast()
```

返回可选值 `Int?`，空栈时返回 `nil`。

```swift
stack.removeLast()
```

返回 `Int`，但空栈时会发生运行时错误。

本题中 `pop()` 使用 `removeLast()`，是因为题目保证所有 `pop()` 调用都有效，而且 `moveIfNeeded()` 会先准备好输出栈。

### 7.3 `last!` 的强制解包

```swift
return output.last!
```

`last` 返回 `Int?`，而 `peek()` 必须返回 `Int`。

由于题目保证 `peek()` 调用时队列非空，因此这里可以强制解包。

实际项目中，如果不保证队列非空，应该考虑返回 `Int?`，避免运行时崩溃。

### 7.4 为什么 `empty()` 使用 `&&`？

```swift
func empty() -> Bool {
    input.isEmpty && output.isEmpty
}
```

队列的元素可能分布在两个栈中，因此必须同时检查。

只检查其中一个栈可能错误地判断队列为空。

### 7.5 Swift 中的均摊复杂度

Swift `Array.append()` 和 `popLast()` 在数组末尾操作时通常具有均摊 O(1) 的性能。

但 `removeFirst()` 需要移动后续元素，通常是 O(n)。

因此本题不应该使用：

```swift
input.removeFirst()
```

这不仅不符合仅使用栈标准操作的限制，也失去了双栈实现队列的意义。

## 8. 总结与复盘

**本题掌握：**

- 理解 Stack（LIFO）与 Queue（FIFO）的区别。
- 使用两个栈反转元素顺序。
- 学会输入栈与输出栈的职责划分。
- 理解为什么只在输出栈为空时转移元素。
- 练习 `append()`、`popLast()`、`last` 和 `isEmpty`。
- 理解均摊时间复杂度 Amortized O(1)。

**核心记忆：**

> 输入栈负责入队，输出栈负责出队。只有输出栈为空时，才将输入栈中的所有元素转移过去。

**易错点：**

- 每次 `pop()` 都转移元素，导致顺序错误或不必要的重复操作。
- 只检查一个栈是否为空。
- 混淆 `popLast()` 和 `removeLast()` 的返回类型。
- 将均摊 O(1) 误认为最坏情况 O(1)。

**后续练习：**

- LeetCode 225 — Implement Stack using Queues
- LeetCode 155 — Min Stack
- LeetCode 20 — Valid Parentheses
