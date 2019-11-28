package facilitator_bot.domain.candidate

trait CandidateRepository[F[_]] {

  def list: F[CandidateList]

  def put(candidate: Candidate): F[Unit]

  def putIfAbsent(candidate: Candidate): F[Unit]

}

object CandidateRepository {
  implicit def repository[F[_]](
      implicit repository: CandidateRepository[F]): CandidateRepository[F] =
    repository
}
