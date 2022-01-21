from model2 import UnAnsweredQuestion


def logToQuestion(comment: str, ptype: int):
    u = UnAnsweredQuestion()
    u.un_answered_question_comment = comment
    u.prob_type = ptype
    try:
        u.save()
        print("logged OK")
    except:
        pass
