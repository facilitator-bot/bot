package facilitator_bot.infra.slack

final case class SlackConfig(botToken: String,
                             reminderChannel: String,
                             skipButtonBlockActionId: String)
