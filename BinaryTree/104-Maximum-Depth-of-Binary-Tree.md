# 104. Maximum Depth of Binary Tree

- **Difficulty:** Easy
- **Language:** Swift
- **Topics:** Tree, Binary Tree, Recursion, DFS, BFS
- **Date:** 2026-11-17
- **Problem:** [LeetCode 104](https://leetcode.com/problems/maximum-depth-of-binary-tree/)

## 1. 题目描述

给定一棵二叉树的根节点 `root`，返回该二叉树的最大深度。

最大深度是指从根节点到最远叶子节点的最长路径所包含的节点数量。

### Example 1

```text
Input: root = [3,9,20,null,null,15,7]
Output: 3

         3
        / \
       9   20
          /  \
         15   7
```

最长路径为：

```text
3 -> 20 -> 15
```

或者：

```text
3 -> 20 -> 7
```

最大深度为 3。

### Example 2

```text
Input: root = [1,null,2]
Output: 2

    1
     \
      2
```

### Constraints

- The number of nodes is in the range [0, 10^4].
- -100 <= Node.val <= 100

## 2. 二叉树基础数据结构

LeetCode 提供的 TreeNode 定义如下：

```swift
public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?

    public init() {
        self.val = 0
        self.left = nil
        self.right = nil
    }

    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }

    public init(
        _ val: Int,
        _ left: TreeNode?,
        _ right: TreeNode?
    ) {
        self.val = val
        self.left = left
        self.right = right
    }
}
```

每个节点包含三个属性：

| Property | Type | Meaning |
|---|---|---|
| val | Int | 当前节点的值 |
| left | TreeNode? | 左子节点 |
| right | TreeNode? | 右子节点 |

与链表的 ListNode 不同，二叉树的节点可以拥有两个子节点。

本题只与树的结构有关，不需要使用 `val`。

## 3. 解题思路

### 3.1 划分子问题

二叉树本身具有递归结构。

一棵非空二叉树可以划分为：

- 当前根节点。
- 左子树。
- 右子树。

因此，原问题可以划分为两个子问题：

1. 求左子树的最大深度。
2. 求右子树的最大深度。

```text
               root
              /    \
      left subtree  right subtree
```

假设已经知道左右子树的最大深度，那么整棵树的最大深度就是两者中的较大值加上当前根节点。

### 3.2 确定递归关系

令 `f(root)` 表示以 root 为根节点的二叉树的最大深度。

```text
f(root) = max(f(root.left), f(root.right)) + 1
```

其中 `+1` 表示当前根节点贡献的一层深度。

### 3.3 确定递归终止条件

当当前节点为空时，说明已经没有可以继续访问的节点。

```text
f(nil) = 0
```

对于叶子节点，左右子树都为空，因此：

```text
f(leaf) = max(0, 0) + 1
        = 1
```

不需要额外判断当前节点是否为叶子节点。

## 4. 解法一：递归 DFS

DFS（Depth-First Search）即深度优先搜索。

通过递归不断访问左右子树，然后根据左右子树返回的结果计算当前节点的最大深度。

```swift
class Solution {
    func maxDepth(_ root: TreeNode?) -> Int {
        guard let root = root else {
            return 0
        }

        let leftDepth = maxDepth(root.left)
        let rightDepth = maxDepth(root.right)

        return max(leftDepth, rightDepth) + 1
    }
}
```

### 使用 if let 的等价写法

```swift
class Solution {
    func maxDepth(_ root: TreeNode?) -> Int {
        if let node = root {
            let leftDepth = maxDepth(node.left)
            let rightDepth = maxDepth(node.right)

            return max(leftDepth, rightDepth) + 1
        } else {
            return 0
        }
    }
}
```

### 进一步简化

```swift
class Solution {
    func maxDepth(_ root: TreeNode?) -> Int {
        guard let root = root else {
            return 0
        }

        return 1 + max(
            maxDepth(root.left),
            maxDepth(root.right)
        )
    }
}
```

三种写法的算法逻辑相同。

## 5. 递归执行过程

以如下二叉树为例：

```text
         3
        / \
       9   20
          /  \
         15   7
```

### 5.1 自顶向下划分子问题

```text
maxDepth(3)
├── maxDepth(9)
│   ├── maxDepth(nil)
│   └── maxDepth(nil)
└── maxDepth(20)
    ├── maxDepth(15)
    │   ├── maxDepth(nil)
    │   └── maxDepth(nil)
    └── maxDepth(7)
        ├── maxDepth(nil)
        └── maxDepth(nil)
```

这里使用节点值表示对应的节点对象，并不是将 Int 类型直接传入函数。

当访问到空节点时，返回 0。

### 5.2 自底向上合并结果

| Node | leftDepth | rightDepth | Return Value |
|---:|---:|---:|---:|
| 9 | 0 | 0 | 1 |
| 15 | 0 | 0 | 1 |
| 7 | 0 | 0 | 1 |
| 20 | 1 | 1 | 2 |
| 3 | 1 | 2 | 3 |

最终得到：

```text
maxDepth(3) = max(1, 2) + 1
            = 3
```

计算当前节点结果的顺序：

```text
9 -> 15 -> 7 -> 20 -> 3
```

这是 **Postorder Traversal（后序遍历）** 的思想：

```text
Left -> Right -> Root
```

先求解左右子树，再处理当前节点。

### 5.3 复杂度分析

- Time Complexity: O(n)
- Space Complexity: O(h)

其中：

- n 为二叉树的节点总数。
- h 为二叉树的最大深度。

每个非空节点仅访问一次，因此时间复杂度为 O(n)。

空间复杂度主要来自递归调用栈。

对于平衡二叉树：

```text
       O
      / \
     O   O
    / \ / \
   O  O O  O
```

树高约为 log n，因此空间复杂度为 O(log n)。

对于退化为链表的二叉树：

```text
O
 \
  O
   \
    O
     \
      O
```

树高为 n，因此最坏空间复杂度为 O(n)。

极深的二叉树也可能带来递归调用栈溢出的风险。

## 6. 解法二：广度优先搜索 BFS

BFS（Breadth-First Search）即广度优先搜索，也称为层序遍历。

由于二叉树的最大深度等于总层数，因此可以逐层遍历二叉树，每遍历完一层，将深度加 1。

### 遍历过程

```text
         3         Level 1
        / \
       9   20      Level 2
          /  \
         15   7    Level 3
```

| Iteration | Current Level | Next Level | Depth |
|---:|---|---|---:|
| 1 | [3] | [9, 20] | 1 |
| 2 | [9, 20] | [15, 7] | 2 |
| 3 | [15, 7] | [] | 3 |

当下一层为空时，遍历结束。

### Swift 实现

使用两个数组分别保存当前层和下一层的节点。

```swift
class Solution {
    func maxDepth(_ root: TreeNode?) -> Int {
        guard let root = root else {
            return 0
        }

        var currentLevel = [root]
        var depth = 0

        while !currentLevel.isEmpty {
            var nextLevel: [TreeNode] = []

            for node in currentLevel {
                if let left = node.left {
                    nextLevel.append(left)
                }

                if let right = node.right {
                    nextLevel.append(right)
                }
            }

            currentLevel = nextLevel
            depth += 1
        }

        return depth
    }
}
```

### 复杂度分析

- Time Complexity: O(n)
- Space Complexity: O(w)

其中 w 为二叉树的最大层宽。

最坏情况下，某一层包含 O(n) 个节点，因此空间复杂度为 O(n)。

## 7. 解法对比

| Approach | Time | Space | 特点 |
|---|---|---|---|
| Recursive DFS | O(n) | O(h) | 代码简洁，符合树的递归结构 |
| BFS | O(n) | O(w) | 按层遍历，不依赖递归调用栈 |

DFS 的空间需求取决于树的深度，BFS 的空间需求取决于树的宽度。

本题优先推荐递归 DFS，用于建立二叉树的递归思维。

## 8. Swift 知识点与易错点

### 8.1 Optional Binding

由于二叉树的根节点和子节点都可能为空，因此节点类型为：

```swift
TreeNode?
```

使用 `guard let` 进行安全解包：

```swift
guard let root = root else {
    return 0
}
```

如果 root 为 nil，则直接返回 0。

如果 root 不为 nil，则后续代码中的 root 为已经解包的 TreeNode，可以安全访问其属性。

```swift
root.left
root.right
```

注意，解包 root 并不意味着其左右子节点也不为空。

### 8.2 guard let 和 if let 的区别

`if let` 解包后的变量只在对应代码块内部有效。

```swift
if let node = root {
    // node 可用
}
```

`guard let` 在解包失败时必须退出当前作用域，解包后的变量可以在后续代码中继续使用。

```swift
guard let node = root else {
    return 0
}

// node 可用
```

对于递归函数的终止条件，`guard let` 通常更加简洁。

### 8.3 不需要比较节点的值

错误的思考方向：

```swift
root.val
```

节点值不能用于判断树的深度。

树的最大深度只由节点之间的连接关系决定。

即使所有节点的值相同，也不影响深度的计算。

### 8.4 注意深度计算中的 +1

错误写法：

```swift
return max(leftDepth, rightDepth)
```

正确写法：

```swift
return max(leftDepth, rightDepth) + 1
```

左右子树的深度不包含当前根节点，因此必须加 1。

### 8.5 为什么不使用 removeFirst() 实现 BFS

Swift 中可以使用 Array 模拟队列，但：

```swift
queue.removeFirst()
```

对于普通 Array，该操作需要移动后续元素，时间复杂度为 O(n)。

如果频繁执行，可能导致整体遍历效率下降，最坏达到 O(n^2)。

本题使用 `currentLevel` 和 `nextLevel` 两个数组进行层序遍历，可以避免这一问题。

## 9. 与 Climbing Stairs 的对比

两道题都可以通过划分子问题来解决，但子问题的性质不同。

| Comparison | Climbing Stairs | Maximum Depth |
|---|---|---|
| Problem | 方法总数 | 最大深度 |
| Subproblem 1 | f(n-1) | 左子树深度 |
| Subproblem 2 | f(n-2) | 右子树深度 |
| Merge | 两个结果相加 | 取最大值后加 1 |
| Overlapping Subproblems | Yes | No |
| Recommended Approach | DP | Recursive DFS |

爬楼梯：

```text
f(n) = f(n - 1) + f(n - 2)
```

二叉树最大深度：

```text
f(root) = max(f(root.left), f(root.right)) + 1
```

爬楼梯存在大量重叠子问题，因此需要保存计算结果以避免重复计算。

而二叉树的左右子树相互独立，每个非空节点只需要计算一次，不需要额外创建 DP 数组或缓存。

本题同样体现了树形 DP 中由子节点向父节点传递状态的思想。

## 10. Test Cases

以下为预期测试结果：

| Input | Expected Output | Purpose |
|---|---:|---|
| [] | 0 | 空树 |
| [1] | 1 | 单个节点 |
| [1,2,3] | 2 | 左右子树均存在 |
| [1,null,2] | 2 | 只有右子树 |
| [1,2,null,3] | 3 | 只有左侧长链 |
| [3,9,20,null,null,15,7] | 3 | 普通非平衡结构 |

## 11. 总结与复盘

本题需要掌握的核心内容：

- 二叉树的递归结构。
- DFS 和 BFS 的基本思想。
- 如何将原问题划分为左右子树问题。
- 如何确定递归终止条件。
- 如何利用子树的返回值计算当前节点的结果。
- 如何分析递归调用栈的空间复杂度。

### 二叉树递归解题三部曲

1. 确定递归函数的参数及返回值。
2. 确定递归终止条件。
3. 确定单层递归逻辑。

### 通用递归模板

```swift
func solve(_ root: TreeNode?) -> Int {
    guard let root = root else {
        return 0
    }

    let left = solve(root.left)
    let right = solve(root.right)

    // 根据题目要求合并子问题的结果
    return combine(left, right)
}
```

其中 `combine` 是示意性的合并操作，需要根据具体题目实现。

不同题目的递归终止条件和返回值类型也可能不同。

### 常见二叉树问题的合并方式

| Problem | Merge Logic |
|---|---|
| 最大深度 | max(left, right) + 1 |
| 节点总数量 | left + right + 1 |
| 节点值总和 | left + right + root.val |
| 叶子节点数量 | 叶子节点返回 1，否则 left + right |

### Key Takeaway

写递归函数时，不需要同时考虑所有递归层级。

应该先明确函数的含义，然后假设递归调用可以正确解决规模更小的子问题，最后思考如何利用这些子问题的答案求解当前问题。

对于二叉树题目，优先考虑：

**如果已经知道左子树和右子树的答案，应该如何求出整棵树的答案？**

## 12. Related Problems

- [226. Invert Binary Tree](https://leetcode.com/problems/invert-binary-tree/)
- [100. Same Tree](https://leetcode.com/problems/same-tree/)
- [111. Minimum Depth of Binary Tree](https://leetcode.com/problems/minimum-depth-of-binary-tree/)
- [110. Balanced Binary Tree](https://leetcode.com/problems/balanced-binary-tree/)
- [102. Binary Tree Level Order Traversal](https://leetcode.com/problems/binary-tree-level-order-traversal/)
- [543. Diameter of Binary Tree](https://leetcode.com/problems/diameter-of-binary-tree/)

## 13. Review Checklist

- [ ] 理解 TreeNode 的数据结构
- [ ] 能够独立划分左右子树问题
- [ ] 能够确定递归终止条件
- [ ] 能够推导递归关系
- [ ] 能够独立编写 DFS 解法
- [ ] 能够理解递归深入和递归返回的过程
- [ ] 能够独立编写 BFS 解法
- [ ] 能够分析递归调用栈的空间复杂度
- [ ] 能够解释本题为什么不需要额外的 DP 数组
