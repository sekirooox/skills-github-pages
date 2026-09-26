
# TagCLIP
Abstract—Contrastive Language-Image Pre-training (CLIP) has recently shown great promise in pixel-level zero-shot learning tasks. However, existing approaches utilizing CLIP’s text and patch embeddings to generate semantic masks often misidentify input pixels from unseen classes, leading to confusion between novel classes and semantically similar ones. In this work, we propose a novel approach, TagCLIP (Trusty-aware guided CLIP), to address this issue. We disentangle the ill-posed optimization problem into two parallel processes: semantic matching performed individually and reliability judgment for improving discrimination ability. Building on the idea of special tokens in language modeling representing sentence-level embeddings, we introduce a trusty token that enables distinguishing novel classes from known ones in prediction. To evaluate our approach, we conduct experiments on two benchmark datasets, PASCAL VOC 2012 and COCO-Stuff 164 K. Our results show that TagCLIP improves the Intersection over Union (IoU) of unseen classes by 7.4% and 1.7%, respectively, with negligible overheads. The code is available at here.
## 动机
过去的工作总是**将不可见类错误分类为相似类(应该指的是可见类)**。
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/c03063bfb0a944f2bcd550814a63eaaf.png)
+ 引入一个额外的token $t_C$
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/c93edd5a9208495ebadede9e4aab93b1.png)

![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/0e301c04638845ea9a9f1f3b1c67bbae.png)


## 可信token学习器：就是一个自注意力机制。
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/4a8679df4e1a41d893565cbf011ba2b9.png)

+ 分为两个$M_A$和$M_R$，$M_R$用于减少对于不可见类的概率。
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/3a9523d0b8a64c03a368ee36b6de220b.png)

+ 可见类为1，不可见类为0
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/42614e0492944f42b55f103e26693543.png)

+ 损失函数：就是一个Dice损失
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/6129409535b04a888f2956f23a605878.png)

![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/b48a3c962efa4131a8adb7b076e19987.png)

## 推理
+ 减少可见类的预测概率
+ 适当调整概率
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/070a3e522d3d455989166756e78ea03a.png)

![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/d79c5c5425a44cfe82d07195489273af.png)


## 消融实验
+ 作者的消融实验还是比较丰富的。可以学习以下
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/d24f1c7142c545fba6c6127ddf6d8c7f.png)


![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/6fbede54478549cdb789fb7bd12676e9.png)

