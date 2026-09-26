# Argparse
>命令行选项、参数和子命令解析器
## ArgumentParser
命令行传参数->**解析参数**->获得对应参数
+ 初始化：`parser = argparse.ArgumentParser(description='xxx')`
+ 添加命令行参数：`    parser.add_argument("--training_filepath",
                        type=str,
                        help="Filepath to the training features",
                        default="./data/2017/training/")`
+ 位置参数和可选参数：位置参数`"training_filepath"`**必须添加**；可选参数`--training_filepath`可以不添加，可以**设定默认值**
+ **解析参数**：`args = parser.parse_args()`，解析完参数后可以使用args获取并索引命令行参数
+ 属性值：利用`args.training_filepath`获得对应属性`
## NameSpace
`from argparse import Namespace`
就是一个结构体，可以储存一些参数或者变量的值，方便用`.attribute`获得
```python
config=Namespace(
    project_name='DNN_Classifier',
    batch_size=32,
    learning_rate=1e-3,
    device=torch.device('cuda' if torch.cuda.is_available() else 'cpu'),
    epochs=50,
)
```
在`dataloader=DataLoader(dataset,batch_size=config.batch_size,shuffle=True)`中，利用`config.batch_size`获取变量值
