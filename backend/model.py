class QuestionResult:

    def __init__(self, comment, answer, qid, isPrimary: bool) -> None:
        self.comment = comment
        self.answer = answer
        self.qid = qid
        self.isPrimary = isPrimary
