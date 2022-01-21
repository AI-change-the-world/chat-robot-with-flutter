from peewee import *

database = MySQLDatabase('custom_service', **{'charset': 'utf8', 'sql_mode': 'PIPES_AS_CONCAT', 'use_unicode': True, 'host': '127.0.0.1', 'port': 3306, 'user': 'root', 'password': '123456'})

class UnknownField(object):
    def __init__(self, *_, **__): pass

class BaseModel(Model):
    class Meta:
        database = database

class Question(BaseModel):
    click_count = IntegerField(constraints=[SQL("DEFAULT 0")], null=True)
    is_hot = IntegerField(null=True)
    question_answer = CharField(null=True)
    question_comment = CharField(null=True)
    question_id = AutoField()
    question_type = IntegerField(null=True)

    class Meta:
        table_name = 'question'

class QuestionType(BaseModel):
    type_id = AutoField()
    type_name = CharField(null=True)

    class Meta:
        table_name = 'question_type'

class UnAnsweredQuestion(BaseModel):
    prob_type = IntegerField(null=True)
    un_answered_question_comment = CharField(null=True)
    un_answered_question_id = AutoField()

    class Meta:
        table_name = 'un_answered_question'

