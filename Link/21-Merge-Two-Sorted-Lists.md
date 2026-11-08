# LeetCode 21 — Merge Two Sorted Lists（合并两个有序链表）

**难度：** Easy  
**标签：** Linked List、Two Pointers、Dummy Node  
**语言：** Swift  
**题目链接：** https://leetcode.com/problems/merge-two-sorted-lists/

## 1. 题目描述

给定两个已经按照非递减顺序排列的单向链表 `list1` 和 `list2`，将它们合并为一个新的有序链表，并返回合并后链表的头节点。

要求直接复用原链表中的节点，而不是将所有值复制到数组中重新排序。

**示例 1：**

```text
Input:
list1 = [1, 2, 4]
list2 = [1, 3, 4]

Output:
[1, 1, 2, 3, 4, 4]
```

**示例 2：**

```text
Input:
list1 = []
list2 = []

Output:
[]
```

**示例 3：**

```text
Input:
list1 = []
list2 = [0]

Output:
[0]
```

**约束条件：**

- 两个链表的节点数量均为 0～50。
- 节点值范围为 -100～100。
- 两个链表均按照非递减顺序排列，允许存在重复值。

## 2. 解题思路

### 2.1 双指针 + 虚拟头节点

因为两个链表本身已经有序，所以不需要重新排序。

只需要同时遍历两个链表，比较当前节点的值，每次选择较小的节点接到结果链表末尾。

使用以下指针：

- `l1`：指向第一个链表当前待处理的节点。
- `l2`：指向第二个链表当前待处理的节点。
- `dummy`：虚拟头节点，用于简化链表构建。
- `tail`：始终指向合并后链表的最后一个节点。

**算法步骤：**

1. 创建虚拟头节点 `dummy`，并让 `tail` 指向它。
2. 当两个链表均非空时，比较 `l1.val` 和 `l2.val`。
3. 选择较小的节点，移动对应链表的遍历指针。
4. 将选中的节点接到 `tail.next`，并更新 `tail`。
5. 当其中一个链表为空时，直接连接另一个链表的剩余部分。
6. 返回 `dummy.next`。

### 2.2 为什么需要 Dummy Node？

如果不使用虚拟头节点，需要单独处理结果链表的第一个节点。

使用 Dummy Node 后，所有节点都可以通过相同的方式追加：

```swift
tail.next = node
tail = node
```

最后直接返回：

```swift
return dummy.next
```

注意，`dummy` 本身不是结果链表中的有效数据节点。

## 3. 我的原始解法

最初的想法是创建新链表，通过 `tail` 指针不断连接两个链表中较小的节点。

原始代码如下（保留错误，用于复盘）：

```swift
class Solution {
    func mergeTwoLists(_ list1: ListNode?, _ list2: ListNode?) -> ListNode? {
        ListNode newList
        ListNode tail = newList

        while list1.val != nil || list2.val != nil {
            if list1.val < list2.val {
                let p = list1
                let n1 = tail.next
                p.next = n1
                tail.next = p
                tail = tail.next
                list1 = list1.next
            } else if list1.val > list2.val {
                let p = list2
                let n1 = tail.next
                p.next = n1
                tail.next = p
                tail = tail.next
                list2 = list2.next
            } else {
                let p1 = list1
                let n1 = tail.next
                p1.next = n1
                tail.next = p1
                tail = tail.next
                list1 = list1.next

                let p2 = list2
                let n2 = tail.next
                p2.next = n2
                tail.next = p2
                tail = tail.next
                list1 = list1.next
            }
        }

        if list1.val == nil {
            tail.next = list2
        } else {
            tail.next = list1
        }

        return newList.next
    }
}
```

### 3.1 问题一：Swift 变量声明错误

错误：

```swift
ListNode newList
ListNode tail = newList
```

正确：

```swift
let dummy = ListNode(0)
var tail = dummy
```

Swift 使用 `let` 和 `var` 声明变量，并通过初始化表达式创建对象。

### 3.2 问题二：没有处理 Optional

错误：

```swift
list1.val
list2.val
```

由于 `list1` 和 `list2` 的类型是 `ListNode?`，它们可能为 `nil`，不能直接访问 `.val`。

正确：

```swift
while let node1 = l1, let node2 = l2 {
    // 可以安全访问 node1.val 和 node2.val
}
```

另外，`val` 是非可选的 `Int`，判断链表是否为空应该检查节点引用是否为 `nil`，而不是检查 `val`。

### 3.3 问题三：函数参数不能重新赋值

错误：

```swift
list1 = list1.next
```

Swift 的函数参数默认不可变。

需要先创建局部变量：

```swift
var l1 = list1
var l2 = list2
```

然后通过局部变量移动遍历指针。

### 3.4 问题四：修改 `next` 导致链表断开

原始代码：

```swift
let p = list1
let n1 = tail.next
p.next = n1
tail.next = p
tail = tail.next
list1 = list1.next
```

问题在于：

```swift
p.next = n1
```

修改了原链表节点的 `next`，但还没有保存原本的下一个节点。

例如：

```text
原链表：
1 → 2 → 4 → nil

执行 p.next = nil 后：

1 → nil

原来的 2 → 4 无法再通过 p 访问。
```

而 `p` 和 `list1` 指向同一个节点，因此修改 `p.next` 也会影响通过 `list1.next` 读取到的结果。

**正确思路：先保存后继节点，再连接当前节点。**

```swift
l1 = node1.next
tail.next = node1
tail = node1
```

这里不需要额外执行 `node1.next = tail.next`。

### 3.5 问题五：循环条件错误

原始思路使用：

```swift
while list1 != nil || list2 != nil
```

但循环内部需要同时比较两个链表的节点值。

如果其中一个链表已经为空，使用 `||` 仍会进入循环，导致无法安全比较。

正确写法：

```swift
while let node1 = l1, let node2 = l2
```

当任意一个链表为空时结束循环，剩余节点直接追加。

### 3.6 问题六：相等分支重复且容易出错

原始代码对以下三种情况分别处理：

```swift
if node1.val < node2.val {
    // ...
} else if node1.val > node2.val {
    // ...
} else {
    // ...
}
```

相等分支中还出现了本应移动 `list2`，却再次移动 `list1` 的错误。

实际上，只需要：

```swift
if node1.val <= node2.val {
    // 选择第一个链表的节点
} else {
    // 选择第二个链表的节点
}
```

相等时先选择第一个链表的节点，下一轮仍然可以选择第二个链表中相同值的节点。

不需要额外处理重复值。

## 4. 优化解法

### 双指针迭代法（推荐）

```swift
class Solution {
    func mergeTwoLists(_ list1: ListNode?, _ list2: ListNode?) -> ListNode? {
        let dummy = ListNode(0)
        var tail = dummy

        var l1 = list1
        var l2 = list2

        while let node1 = l1, let node2 = l2 {
            if node1.val <= node2.val {
                l1 = node1.next
                tail.next = node1
                tail = node1
            } else {
                l2 = node2.next
                tail.next = node2
                tail = node2
            }
        }

        tail.next = l1 ?? l2

        return dummy.next
    }
}
```

### 核心代码解析

**1. 创建虚拟头节点**

```swift
let dummy = ListNode(0)
var tail = dummy
```

`dummy` 始终保存结果链表的起点，`tail` 负责向后移动。

**2. 遍历两个链表**

```swift
while let node1 = l1, let node2 = l2
```

只有两个链表都还有节点时才进行比较。

**3. 连接较小节点**

```swift
if node1.val <= node2.val {
    l1 = node1.next
    tail.next = node1
    tail = node1
}
```

先让 `l1` 指向后继节点，再将当前节点追加到结果链表。

**4. 连接剩余节点**

```swift
tail.next = l1 ?? l2
```

循环结束时，至少有一个链表为空。

使用空值合并运算符 `??`，选择非空链表的剩余部分。

因为原链表已经有序，所以不需要再逐个比较。

**5. 返回结果头节点**

```swift
return dummy.next
```

跳过虚拟头节点，返回真正的链表头节点。

## 5. 执行过程

输入：

```text
list1 = 1 → 2 → 4
list2 = 1 → 3 → 4
```

| 步骤 | 当前比较 | 选择节点 | 合并结果 |
|---|---|---|---|
| 1 | 1 和 1 | list1 的 1 | 1 |
| 2 | 2 和 1 | list2 的 1 | 1 → 1 |
| 3 | 2 和 3 | list1 的 2 | 1 → 1 → 2 |
| 4 | 4 和 3 | list2 的 3 | 1 → 1 → 2 → 3 |
| 5 | 4 和 4 | list1 的 4 | 1 → 1 → 2 → 3 → 4 |
| 6 | list1 为空 | 追加 list2 剩余节点 | 1 → 1 → 2 → 3 → 4 → 4 |

最终结果：

```text
dummy → 1 → 1 → 2 → 3 → 4 → 4 → nil
         ↑
      返回这里
```

### 边界情况

```text
list1 = nil
list2 = nil
结果 = nil
```

```text
list1 = nil
list2 = 0 → nil
结果 = 0 → nil
```

```text
list1 = 1 → 2 → nil
list2 = nil
结果 = 1 → 2 → nil
```

这些情况都可以通过 `tail.next = l1 ?? l2` 正确处理。

## 6. 复杂度分析

设第一个链表有 `m` 个节点，第二个链表有 `n` 个节点。

**时间复杂度：O(m + n)**

每次循环都会处理一个节点并移动一个遍历指针。

两个链表的每个节点最多被处理一次，因此总时间复杂度为 O(m + n)。

**额外空间复杂度：O(1)**

算法只创建一个虚拟头节点，并使用少量指针变量。

没有创建新的结果节点，也没有使用额外数组。

合并后的链表直接复用原链表节点。

## 7. Swift 知识点与易错点

### 7.1 `ListNode` 是引用类型

LeetCode 中的节点定义：

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

`ListNode` 是 `class`，属于引用类型。

例如：

```swift
let a = ListNode(1)
let b = a

b.val = 10

print(a.val) // 10
```

`a` 和 `b` 指向同一个对象。

因此，修改 `b` 的属性，也会影响通过 `a` 观察到的对象。

这也是原始代码中修改 `p.next` 会影响 `list1.next` 的原因。

### 7.2 `let` 和 `var` 对引用类型的影响

```swift
let dummy = ListNode(0)
dummy.next = ListNode(1) // 合法
```

`let` 表示不能让 `dummy` 重新指向其他对象，但仍然可以修改对象的可变属性。

```swift
var tail = dummy
tail = dummy.next! // 合法
```

`tail` 需要不断改变所指向的节点，因此必须使用 `var`。

### 7.3 Optional Binding

```swift
while let node1 = l1, let node2 = l2 {
    // ...
}
```

`l1` 和 `l2` 是 `ListNode?`。

`while let` 将非空节点安全解包为 `ListNode`，避免强制解包导致的运行时错误。

当任意一个值为 `nil` 时，循环结束。

### 7.4 Nil Coalescing

```swift
tail.next = l1 ?? l2
```

`??` 的作用是：

- 如果 `l1` 非空，使用 `l1`。
- 如果 `l1` 为空，使用 `l2`。

它非常适合处理两个链表中剩余的非空部分。

### 7.5 为什么 `tail = node1`，而不是 `tail = tail.next`？

```swift
tail.next = node1
tail = node1
```

因为 `node1` 已经通过 `while let` 解包，类型为 `ListNode`。

而 `tail.next` 的类型是 `ListNode?`，如果写成：

```swift
tail = tail.next
```

就会产生可选类型与非可选类型不匹配的问题。

直接赋值 `node1` 更清晰，也不需要强制解包。

### 7.6 修改链表指针时的顺序

在链表操作中，需要特别注意是否会丢失原本的后继节点。

常见的安全模式：

```swift
let next = current.next

// 修改 current.next

current = next
```

本题中则通过：

```swift
l1 = node1.next
tail.next = node1
tail = node1
```

提前移动遍历指针，保留后续链表的访问入口。

## 8. 总结与复盘

### 本题掌握的知识

- 使用双指针同时遍历两个有序链表。
- 使用 Dummy Node 简化链表构建。
- 使用 `tail` 指针在结果链表末尾追加节点。
- 理解 Swift `class` 的引用语义。
- 正确处理 `ListNode?` 和 Optional Binding。
- 使用 `??` 连接剩余链表。
- 理解原地复用链表节点的 O(1) 额外空间复杂度。

### 本次错误总结

| 错误类型 | 原因 | 改进方式 |
|---|---|---|
| Swift 语法 | 使用 C/C++ 风格声明 | 使用 `let` / `var` |
| Optional | 直接访问可选节点的属性 | 使用 `while let` |
| 参数修改 | 试图修改函数参数 | 创建局部遍历变量 |
| 指针操作 | 过早修改 `next` | 先保存后继节点 |
| 循环条件 | 使用 `||` 导致空链表仍参与比较 | 使用两个节点均非空的条件 |
| 重复代码 | 为相等情况单独写复杂逻辑 | 使用 `<=` |
| 类型问题 | 将 `ListNode?` 赋给 `ListNode` | 直接使用已解包的节点 |
| 剩余节点 | 逐个处理或判断方式错误 | 使用 `l1 ?? l2` |

### 核心记忆

> 合并两个有序链表时，每次选择较小的节点接到结果链表末尾；其中一个链表为空后，直接追加另一个链表的剩余部分。

> 修改链表节点的 `next` 之前，必须确认不会丢失后续节点的访问入口。

**推荐后续练习：**

- LeetCode 206 — Reverse Linked List（反转链表）
- LeetCode 141 — Linked List Cycle（环形链表）
- LeetCode 83 — Remove Duplicates from Sorted List（删除排序链表中的重复元素）
