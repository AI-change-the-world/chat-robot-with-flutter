from flask import Blueprint
from flask import request
from model import QuestionResult
from model2 import Question
from flask import jsonify
import threading
import kashgari
import jieba
import traceback

import tensorflow as tf
from keras import backend as kb

graph = tf.get_default_graph()
sess = tf.Session()
kb.set_session(sess)

from threading_functions import logToQuestion

questions = Blueprint('question', __name__)

CNNmodel = kashgari.utils.load_model("model2")

__dict_info__ = {
    "发工资": 1,
    "发薪通知": 7,
    "实名": 6,
    "工资条": 2,
    "打卡": 5,
    "授权": 3,
    "用工单位": 4,
}


@questions.route("/test")
def test():
    return "question test"


@questions.route("/ask", methods=["POST"])
def ask_question():
    # question_answer 可能是html富文本
    result = dict()
    try:
        __question: str = request.json.get('question')
        print(__question)
        # 这里判断意图，然后返回列表
        # 测试意图为 1
        x = list(jieba.cut(__question))
        global graph, sess
        with graph.as_default():
            kb.set_session(sess)
            y = CNNmodel.predict_top_k_class([x], top_k=3)[0]
            print(y)
        __intend_index = 0
        _candidates = set()
        result['data'] = []
        result['code'] = 200
        result['message'] = ""
        if y['confidence'] > 0.5:
            _label = y['label']
            __intend_index = __dict_info__.get(_label, 0)
            print(_label)
            print(__intend_index)

            for i in y['candidates']:
                _label = i['label']
                _candidates.add(__dict_info__.get(_label, 0))

            _list = list(_candidates)
            _list.append(__intend_index)
            for _id in _list:

                questions = Question.select().where(
                    (Question.question_type == _id)
                    & (Question.question_answer != "")).order_by(
                        Question.click_count.desc()).paginate(1, 5)

                for q in questions:
                    if q.question_type == __intend_index:
                        result['data'].append(
                            QuestionResult(q.question_comment,
                                           q.question_answer, q.question_id,
                                           True).__dict__)
                    else:
                        result['data'].append(
                            QuestionResult(q.question_comment,
                                           q.question_answer, q.question_id,
                                           False).__dict__)
        else:
            print(y['confidence'])

        # 这里新起一个线程存储question
        t = threading.Thread(target=logToQuestion,
                             args=(__question, __intend_index))
        t.run()
    except:
        traceback.print_exc()
        result['data'] = []
        result['code'] = 500
        result['message'] = "参数异常"
    return jsonify(result)


@questions.route("/hot")
def get_hot_question():
    questions = Question(is_hot=1).select()
    result = dict()

    result['data'] = []
    result['code'] = 200
    result['message'] = ""
    for q in questions:
        result['data'].append(
            QuestionResult(q.question_comment, q.question_answer,
                           q.question_id,False).__dict__)

    return jsonify(result)


@questions.route("/addone", methods=["POST"])
def add_one():
    """{"questionId":1}
    """
    try:
        __id: int = request.json.get('questionId')
        Question.update(click_count=Question.click_count +
                        1).where(Question.question_id == __id)
    except:
        pass
