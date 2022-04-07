

export interface Candidate  {
  name: string
  lastActAt: number
  slackUserId: string
}

export type CandidateList = {
  candidates: [Candidate]
}

export function chooseNextOne(candidates: CandidateList): Candidate {
  return candidates.candidates.sort((a, b) => a.lastActAt - b.lastActAt)[0]
}

export type FacilitatorRemind = {
  candidate: Candidate
}

export function reminderMessage(candidate: Candidate): string {
  return `Today's facilitator is <@${candidate.slackUserId}> (${candidate.name})`
}

export type NoCandidateFoundError = {}


