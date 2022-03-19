import * as models from './models'

export interface CandidateRepository {
  list(): Promise<models.CandidateList>
  put(candidate: models.Candidate): Promise<void>
  putIfAbsent(candidate: models.Candidate): Promise<void>
}

export interface ReminderRepository {
  notify(remind: models.FacilitatorRemind): Promise<void>
}