import * as repository from '../domain/repository'
import * as models from '../domain/models'
import * as dynamoose from "dynamoose"
import { Document } from "dynamoose/dist/Document";

type Config = {
  candidatesTable: string
}

const CandidateSchema = new dynamoose.Schema({
  name: {
    type: String,
    hashKey: true,
  },
  lastActAt: {
    type: Number
  },
  slackUserId: {
    type: String
  }
})

interface CandidateDoc extends models.Candidate, Document {}


export function newRepository(config: Config): repository.CandidateRepository {
  const CandidateModel = dynamoose.model<CandidateDoc>(config.candidatesTable, CandidateSchema, {create: false})
  return {
    async list(): Promise<models.CandidateList> {
      const candidates = await CandidateModel.scan().all().exec()
      return { candidates }
    },
    async put(candidate: models.Candidate): Promise<void> {
      await new CandidateModel(candidate).save()
    },
    async putIfAbsent(candidate: models.Candidate): Promise<void> {
      await new CandidateModel(candidate).save()
    }
  }
}