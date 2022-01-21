# flutter + flask 的简易客服系统搭建

## 1. 用到的技术

- flutter (easy)
- flask(easy)
- nlp(easy)

## 2.用到的语言

- python
- dart

## 3. 依赖安装

### 3.1 后端（python版本3.6.13，3.7往上应该不行）

```py
jieba==0.42.1    # 分词

peewee==3.14.8  # python orm

Flask==1.1.2  # python web 框架

kashgari==1.1.5  # nlp脚手架

Keras==2.4.3  # tensorflow封装的神经网络框架

Flask_Cors==3.0.10  #  跨域

tensorflow==1.15.0  # 神经网络框架
```



### 3.2 flutter依赖

```yaml
dependencies:
  flutter:
    sdk: flutter
  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.2
  flutter_bloc: ^8.0.0 #状态管理框架
  equatable: ^2.0.3 #增强组件相等性判断
  string_similarity: ^2.0.0
  bloc_concurrency: ^0.2.0
  stream_transform: ^2.0.0
  dio: ^4.0.4
  fluttertoast: ^8.0.8  # toast
```





## 4. 原理

### 4.1 数据哪里来

原始数据只有不到20个问题，基本上告别了nlp训练，但是可以使用 [nlpcda](https://github.com/425776024/nlpcda)进行数据增广。

```python
from nlpcda import Simbert
config = {
        'model_path': 'D:\\workspace\\customer_service_models\\kashg\\sim\\chinese_simbert_L-12_H-768_A-12',
        'CUDA_VISIBLE_DEVICES': '-1',
        'max_len': 64, # 生成的数据最大长度64个字符
        'seed': 1
}

simbert = Simbert(config=config)
sent = '这里写入要增广的str数据，比如`我很帅`'
synonyms = simbert.replace(sent=sent, create_num=100) #使用工具生成100句数据
print(synonyms)
```



### 4.2 数据怎么训练

[kashgari](https://github.com/BrikerMan/Kashgari)是一个nlp集成训练工具，基于tensorflow以及keras开发。

其教程中含有[文本分类](https://eliyar.biz/nlp_chinese_text_classification_in_15mins/)。

训练数据格式如下（中间是tab）：

```python
类名	语句
```



生成train.txt 以及 val.txt之后，可以直接使用kashgari进行训练。

```python
from kashgari.tasks.classification import CNN_Model  #可以换别的模型
from keras.callbacks import TensorBoard
import tqdm
import jieba


def read_data_file(path):
    lines = open(path, 'r', encoding='utf-8').read().splitlines()
    x_list = []
    y_list = []
    for line in tqdm.tqdm(lines):
        rows = line.split('\t')
        if len(rows) >= 2:
            y_list.append(rows[0])
            x_list.append(list(jieba.cut('\t'.join(rows[1:]))))
        else:
            print(rows)
    return x_list, y_list

if __name__ == '__main__':
    train_x, train_y = read_data_file('train.txt')
    val_x, val_y = read_data_file('val.txt')


    # Using TensorBoard record training process
    tf_board = TensorBoard(log_dir='tf_dir/cnn_model',
                        histogram_freq=5,
                        update_freq='batch')

    model = CNN_Model()
    model.fit(train_x, train_y, val_x, val_y,
            batch_size=128,
            callbacks=[tf_board])

    model.save('./model')
```



生成模型之后，使用如下代码可以进行测试。

```python
import kashgari
import jieba

model = kashgari.utils.load_model("model2")
news_sample = """「DeepMind 击败人类职业玩家的方式与他们声称的 AI 使命，以及所声称的『正确』方式完全相反。」
DeepMind 的人工智能 AlphaStar 一战成名，击败两名人类职业选手。掌声和欢呼之余，它也引起了一些质疑。在前天 DeepMind 举办的 AMA 中，AlphaStar 项目领导者 Oriol Vinyals 和 David Silver、职业玩家 LiquidTLO 与 LiquidMaNa 回答了一些疑问。不过困惑依然存在……
"""

# 我要怎么绑定用工单位
x = list(jieba.cut(news_sample))
y = model.predict_top_k_class([x],top_k=3)
print(y) # 输出相似度top3 的数据,新版本kashgari不支持这个函数了，所以使用1.1.5版本的
```

训练以及测试过程比较简单

### 4.3 模型部署与服务端开发

#### server.py

```python
from flask import Flask
from flask_cors import CORS
from controller import questions


app = Flask(__name__)
app.register_blueprint(questions,url_prefix='/question')
CORS(app, supports_credentials=True)

if __name__ == '__main__':
    app.debug = True
    app.run(host='0.0.0.0', port=9001)
```

#### controller.py (核心代码)

```python
import tensorflow as tf
import kashgari
import jieba
from keras import backend as kb

graph = tf.get_default_graph()
sess = tf.Session()
kb.set_session(sess)

graph = tf.get_default_graph()
sess = tf.Session()
kb.set_session(sess)
CNNmodel = kashgari.utils.load_model("model2")

...

global graph, sess
with graph.as_default():
    kb.set_session(sess)
    y = CNNmodel.predict_top_k_class([x], top_k=3)[0]

    ...
```

### 4.4 前端样式

![image-20211229151454169](images\image-20211229151454169.png)

![image-20211229151613786](images\image-20211229151613786.png)

![image-20211229151654763](images\image-20211229151654763.png)

![image-20211229151741867](images\image-20211229151741867.png)