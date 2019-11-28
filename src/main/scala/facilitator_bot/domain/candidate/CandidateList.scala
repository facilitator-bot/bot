package facilitator_bot.domain.candidate

final case class CandidateList(candidates: List[Candidate]) {

  def chooseNextOne: Option[Candidate] =
    candidates.sortBy(_.lastActAt).headOption

}
