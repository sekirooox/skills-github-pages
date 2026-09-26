# 广播机制
+ 从末尾开始逐个维度遍历两个矩阵的`shape`，如果维度不相同，则考虑广播：
+ 任一方的**维度为1或者维度不存在**(小矩阵广播为大矩阵)，这样的运算**可以广播**
### 可以广播的例子
```python
x=torch.empty(5,3,4,1)
y=torch.empty(3,1,1)
(x.add_(y)).size()
```

### 不可以广播的例子
原因：2!=3，违反**至少有一个矩阵当前维度为1**
```python
x=torch.empty(5,2,4,1)
y=torch.empty(3,1,1)
(x+y).size()
```

## 逐元素乘法运算规则
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/b5584dbf64e54ce19bb744afbdc3e8f5.png)

