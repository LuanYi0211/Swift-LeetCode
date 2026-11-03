# LeetCode 206 — Reverse Linked List（反转链表）

**难度：** Easy  
**标签：** Linked List、Two Pointers、Recursion  
**语言：** Swift  
**题目链接：** https://leetcode.com/problems/reverse-linked-list/

## 1. 题目描述

给定单向链表的头节点 `head`，反转链表，并返回反转后的头节点。

**示例 1：**

```text
Input:  1 → 2 → 3 → 4 → 5 → nil
Output: 5 → 4 → 3 → 2 → 1 → nil
```

**示例 2：**

```text
Input:  1 → 2 → nil
Output: 2 → 1 → nil
```

**示例 3：**

```text
Input:  nil
Output: nil
```

**约束：**

- 节点数量为 0～5000。
- 节点值在 -5000～5000 之间。

**Follow-up：** 分别使用迭代和递归实现链表反转。

### 链表节点定义

LeetCode 提供：

```swift
public class ListNode {
    public var val: Int
    public var next: ListNode?

    public init() {
        self.val = 0
        self.next = nil
    }

    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }

    public init(_ val: Int, _ next: ListNode?) {
        self.val = val
        self.next = next
    }
}
```

其中 `next: ListNode?` 是可选类型，表示当前节点可以指向另一个节点，也可以指向 `nil`。

## 2. 解题思路

### 方法一：头插法

最初的想法是：

1. 创建一个新链表，使用虚拟头节点 `dummy`。
2. 从原链表头部开始，依次取出节点。
3. 将取出的节点插入新链表的头部。
4. 遍历结束后返回 `dummy.next`。

例如：

```text
原链表：1 → 2 → 3 → nil

初始：
dummy → nil

取出 1：
dummy → 1 → nil

取出 2：
dummy → 2 → 1 → nil

取出 3：
dummy → 3 → 2 → 1 → nil
```

**关键：必须先保存原链表的下一个节点，再修改当前节点的 `next`。**

### 方法二：三指针迭代法

使用三个指针：

- `prev`：已反转部分的头节点。
- `current`：当前正在处理的节点。
- `next`：临时保存原链表的下一个节点。

每次执行：

```swift
let next = node.next
node.next = prev
prev = node
current = next
```

本质上也是不断将当前节点放到已反转链表的最前面，只是不再需要虚拟头节点。

### 方法三：递归法

先递归反转当前节点后面的链表，再把当前节点连接到反转后链表的末尾。

递归终止条件是链表为空，或当前节点已经是最后一个节点。

## 3. 我的原始解法

```swift
class Solution {
    func reverseList(_ head: ListNode?) -> ListNode? {
        let newList = ListNode()

        while head != nil {
            let first = head
            insert(n0: newList, p: first)
            remove(n0: first)
        }

        return newList
    }

    func insert(n0: ListNode, p: ListNode) {
        let n1 = n0.next
        p.next = n1
        n0.next = p
    }

    func remove(n0: ListNode) {
        if n0.next == nil {
            return
        }

        let P = n0.next
        let n1 = P?.next
        n0.next = n1
    }
}
```

### 存在的问题

**问题一：Optional 类型不匹配**

```swift
let first = head
insert(n0: newList, p: first)
```

`head` 是 `ListNode?`，而 `insert()` 要求 `ListNode`。

需要使用 `if let` 或 `while let` 安全解包。

**问题二：没有更新遍历指针**

```swift
while head != nil
```

循环中没有让遍历位置向后移动，可能导致无限循环。

需要使用：

```swift
var current = head
```

并在每次循环结束时更新 `current`。

**问题三：修改节点连接前没有保存下一个节点**

```swift
p.next = n1
```

这行代码会覆盖 `p` 原来的 `next`，可能导致无法继续访问原链表的剩余节点。

因此需要先保存：

```swift
let next = node.next
```

**问题四：`remove()` 的操作对象不正确**

原来的 `remove(n0:)` 删除的是 `n0` 后面的节点，而不是 `n0` 自身。

此外，调用 `insert()` 后，当前节点的 `next` 已经改变，再执行 `remove()` 可能破坏新链表。

实际上不需要单独的 `remove()` 函数，只需重新连接节点即可。

**问题五：返回了虚拟头节点**

```swift
return newList
```

`newList` 是额外创建的虚拟头节点，值为 `0`，不属于反转后的链表。

正确返回值应为：

```swift
return newList.next
```

## 4. 修正与优化解法

### 4.1 保留原始思路：头插法

```swift
class Solution {
    func reverseList(_ head: ListNode?) -> ListNode? {
        let newList = ListNode()
        var current = head

        while let node = current {
            let next = node.next

            insert(n0: newList, p: node)

            current = next
        }

        return newList.next
    }

    func insert(n0: ListNode, p: ListNode) {
        let n1 = n0.next
        p.next = n1
        n0.next = p
    }
}
```

`insert()` 的逻辑可以保留：

```swift
let n1 = n0.next
p.next = n1
n0.next = p
```

它将节点 `p` 插入到 `n0` 后面。

其中最重要的是：

```swift
let next = node.next
```

必须在插入前保存，否则可能丢失原链表的剩余部分。

### 4.2 推荐解法：三指针迭代

```swift
class Solution {
    func reverseList(_ head: ListNode?) -> ListNode? {
        var prev: ListNode? = nil
        var current = head

        while let node = current {
            let next = node.next

            node.next = prev
            prev = node
            current = next
        }

        return prev
    }
}
```

#### 执行过程

原链表：

```text
1 → 2 → 3 → nil
```

初始化：

```text
prev = nil
current = 1
```

第一次循环：

```text
prev:    1 → nil
current: 2 → 3 → nil
```

第二次循环：

```text
prev:    2 → 1 → nil
current: 3 → nil
```

第三次循环：

```text
prev:    3 → 2 → 1 → nil
current: nil
```

循环结束，返回 `prev`。

#### 为什么返回 `prev`？

每次循环：

```swift
prev = node
```

都会将当前节点设为已反转链表的新头节点。

当 `current == nil` 时，所有节点都已处理完成，此时 `prev` 就是反转后的头节点。

### 4.3 Follow-up：递归解法

```swift
class Solution {
    func reverseList(_ head: ListNode?) -> ListNode? {
        guard let head = head,
              let next = head.next else {
            return head
        }

        let newHead = reverseList(next)

        next.next = head
        head.next = nil

        return newHead
    }
}
```

#### 递归思路

例如：

```text
1 → 2 → 3 → nil
```

递归先到达节点 `3`，返回它作为新的头节点。

然后开始回溯。

处理节点 `2`：

```swift
next.next = head  // 3.next = 2
head.next = nil   // 2.next = nil
```

得到：

```text
3 → 2 → nil
```

处理节点 `1`：

```swift
next.next = head  // 2.next = 1
head.next = nil   // 1.next = nil
```

最终：

```text
3 → 2 → 1 → nil
```

`head.next = nil` 非常重要，否则可能保留原有的连接，形成环。

## 5. 复杂度分析

| 解法 | 时间复杂度 | 额外空间复杂度 |
|---|---|---|
| 头插法 | O(n) | O(1) |
| 三指针迭代法 | O(n) | O(1) |
| 递归法 | O(n) | O(n) |

**时间复杂度：**

三种方法都需要处理每个节点一次，因此为 O(n)。

**空间复杂度：**

- 头插法只使用一个虚拟头节点和少量引用变量，为 O(1)。
- 三指针迭代法只使用固定数量的变量，为 O(1)。
- 递归法需要保存函数调用栈，最深可能达到 n 层，因此为 O(n)。

注意：头插法虽然创建了一个虚拟头节点，但并没有复制原链表的全部节点，因此额外空间仍为 O(1)。

## 6. Swift 知识点与易错点

### 6.1 Optional：`ListNode?`

```swift
var current: ListNode? = head
```

`ListNode?` 表示变量可以引用一个节点，也可以是 `nil`。

链表的最后一个节点通常满足：

```swift
node.next == nil
```

### 6.2 使用 `while let` 安全解包

```swift
while let node = current {
    // 使用非可选类型的 node
}
```

当 `current` 不为 `nil` 时，将其解包为 `node` 并执行循环。

当 `current` 为 `nil` 时，循环自动结束。

### 6.3 Class 是引用类型

LeetCode 中的 `ListNode` 使用 `class` 定义。

```swift
let node1 = ListNode(1)
let node2 = node1

node2.val = 10

print(node1.val) // 10
```

`node1` 和 `node2` 引用同一个对象。

因此链表反转时，修改 `node.next` 就是在修改原节点之间的连接，而不是修改一个独立副本。

### 6.4 `let` 引用也可以修改对象属性

```swift
let node = ListNode(1)
node.next = ListNode(2)
```

这是合法的。

`let` 限制的是变量不能重新指向其他对象，而不是禁止修改对象内部的 `var` 属性。

### 6.5 为什么先保存 `next`？

错误顺序：

```swift
node.next = prev
current = node.next
```

这里的 `node.next` 已经被修改成 `prev`，无法继续遍历原链表。

正确顺序：

```swift
let next = node.next
node.next = prev
current = next
```

**链表指针操作的重要原则：修改连接前，先保存仍然需要访问的节点。**

### 6.6 虚拟头节点（Dummy Head）

```swift
let dummy = ListNode()
```

虚拟头节点是一个辅助节点，用来简化链表头部的插入和删除操作。

如果真实链表从 `dummy.next` 开始，就应该返回：

```swift
return dummy.next
```

而不是 `dummy`。

### 6.7 处理空链表

当输入 `head == nil` 时：

- 头插法：循环不执行，返回 `dummy.next`，即 `nil`。
- 三指针法：循环不执行，返回 `prev`，即 `nil`。
- 递归法：直接触发终止条件，返回 `nil`。

三种解法都能正确处理空链表。

## 7. 总结与复盘

### 本题掌握的内容

- 理解单向链表的节点与 `next` 引用。
- 学习使用头插法反转链表。
- 掌握三指针迭代反转。
- 理解递归反转及其回溯过程。
- 熟悉 Swift 中的 Optional 和 `while let`。
- 理解 `class` 的引用语义。
- 学会使用 Dummy Head 简化链表操作。

### 我的主要错误

1. 将 `ListNode?` 直接传给需要 `ListNode` 的函数。
2. 没有更新遍历指针。
3. 修改 `next` 前没有保存原来的后继节点。
4. 混淆删除当前节点和删除后继节点。
5. 错误地返回虚拟头节点。

### 最重要的收获

**反转链表并不需要重新创建所有节点，只需要改变原有节点的 `next` 指向。**

三指针迭代法最值得记忆的四行：

```swift
let next = node.next
node.next = prev
prev = node
current = next
```

记忆顺序：

**保存下一个 → 反转当前指向 → 更新前驱 → 移动当前指针。**

### 后续练习

- LeetCode 21 — Merge Two Sorted Lists
- LeetCode 83 — Remove Duplicates from Sorted List
- LeetCode 141 — Linked List Cycle
- LeetCode 876 — Middle of the Linked List
