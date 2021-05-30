Class {
	#name : #EDAACandidateTest,
	#superclass : #TestCase,
	#category : #'EDAA-Domain-Tests'
}

{ #category : #tests }
EDAACandidateTest >> testAdapterClassAsCandidateKey [
	| candidate |
	candidate := EDAACandidate withKey: 'EDAAMongoEventStore' value: nil.
	self assert: candidate adapterClass equals: #EDAAMongoEventStore.
	candidate := EDAACandidate withKey: 'EDAAMemoryEventStore' value: nil.
	self assert: candidate adapterClass equals: #EDAAMemoryEventStore.
]

{ #category : #tests }
EDAACandidateTest >> testBuilderMethod [
	| key candidate value |
	key := 'candidateKey'.
	value := 'candidateValue'.
	candidate := EDAACandidate withKey: key value: value.
	self
		assert: candidate key equals: key;
		assert: candidate value equals: value
]
