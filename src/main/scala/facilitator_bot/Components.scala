package facilitator_bot

import cats.effect.Effect
import facilitator_bot.domain.candidate.CandidateRepository
import facilitator_bot.domain.reminder.ReminderRepository
import facilitator_bot.infra.candidate.DDBCandidateRepository
import facilitator_bot.infra.ddb.Config
import facilitator_bot.infra.slack.{SlackConfig, SlackReminderRepository}
import facilitator_bot.usecase.{
  ChooseFacilitator,
  NotifyFacilitator,
  PopulateSeed
}
import pureconfig.ConfigSource
import pureconfig.generic.auto._

import scala.concurrent.ExecutionContext

class Components[F[_]: Effect](implicit ec: ExecutionContext) {
  private implicit val ddbConfig: Config =
    ConfigSource.default.at("ddb").loadOrThrow[Config]

  implicit val slackConfig: SlackConfig =
    ConfigSource.default.at("slack").loadOrThrow[SlackConfig]

  private implicit val candidateRepository: CandidateRepository[F] =
    new DDBCandidateRepository[F]

  private implicit val reminderRepository: ReminderRepository[F] =
    new SlackReminderRepository[F]

  val populateSeed: PopulateSeed[F] = new PopulateSeed[F]
  val chooseFacilitator: ChooseFacilitator[F] = new ChooseFacilitator[F]
  val notifyFacilitator: NotifyFacilitator[F] = new NotifyFacilitator[F]
}
