package facilitator_bot.domain.reminder

import facilitator_bot.domain.candidate.Candidate

final case class FacilitatorRemind(candidate: Candidate) {
  val reminderMessage: String = s"Today's facilitator is ${candidate.name}"
}
