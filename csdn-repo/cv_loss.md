# Focal Loss
[参考文献](https://zhuanlan.zhihu.com/p/266023273)
## 动机
+ 不平衡问题

### 改进：平衡BCE函数
+ 引入$a_t$来直接缓解正负样本平衡的问题。
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/a8fd956465b8455bbe8e5c62aa405fcb.png)

## 不平衡问题的转换：低置信/高置信样本
+ 将不平衡问题表述为：**减轻简单样本/高置信度样本的损失，增加困难/低置信样本的损失**
+ 为损失引入$(1-p)^{\gamma}$
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/5854b4179ab940c5abe81225a62b02c4.png)
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/636b586213004cacb13c96d2a5aa1dff.png)
# Dice损失
## 标准定义
+ 1-dice系数
+ dice系数衡量两个区域的重叠程度。
+ 在语义分割任务上：dice任务**直接优化掩膜与GT的重叠程度**(也可以优化目标检测任务)。
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/7a0d0888229642a98a33cecb3890421d.png)
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/a5167f5e2ad841c6abf7547d1585d47d.png)
## 简化实现
+ 给定两个向量，形状一致。
+ 交集：**就是二者相加(要求GT为1或者0)**
+ 并集：**分别对两个向量求和即可**
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/981b396b3fad487c8ab5c4d445d4aced.png)

