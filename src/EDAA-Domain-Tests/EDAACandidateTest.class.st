Class {
	#name : #EDAACandidateTest,
	#superclass : #TestCase,
	#traits : 'EDAAPragmaBasedCandidateAdapterClassNameResolver',
	#classTraits : 'EDAAPragmaBasedCandidateAdapterClassNameResolver classTrait',
	#category : #'EDAA-Domain-Tests'
}

{ #category : #annotations }
EDAACandidateTest class >> arbitraryKey [
	"Maps 'arbitraryKey' to #EDAAMemoryventStore"

	<edaAdapterClass: #EDAAMemoryEventStore priority: 101>
	^ self
]

{ #category : #annotations }
EDAACandidateTest class >> classSideArbitraryKey [
	"Maps 'classSideArbitraryKey' to #EDAAMemoryventStore"

	<edaAdapterClass: #EDAAMemoryEventStore priority: 102>
	^ self
]

{ #category : #tests }
EDAACandidateTest >> EDAAMongoEventStore [
	"See testAdapterMatchingKeyIsPreferred"

	<edaAdapterClass: #EDAAMongoEventStore priority: 1000>
	^ self
]

{ #category : #tests }
EDAACandidateTest >> arbitraryKey [
	"Maps 'arbitraryKey' to #EDAAMongoEventStore"

	<edaAdapterClass: #EDAAMongoEventStore priority: 2000>
	^ self
]

{ #category : #tests }
EDAACandidateTest >> testAdapterClassAsCandidateKey [
	| candidate |
	candidate := EDAACandidate withKey: 'EDAAMongoEventStore' value: nil.
	self assert: candidate adapterClass equals: #EDAAMongoEventStore.
	candidate := EDAACandidate withKey: 'EDAAMemoryEventStore' value: nil.
	self assert: candidate adapterClass equals: #EDAAMemoryEventStore.
]

{ #category : #tests }
EDAACandidateTest >> testAdapterClassFromPragma [
	| candidate |
	candidate := EDAACandidate withKey: 'arbitraryKey' value: nil.
	self assert: candidate adapterClass equals: #EDAAMemoryEventStore.
	candidate := EDAACandidate
		withKey: 'classSideArbitraryKey'
		value: nil.
	self assert: candidate adapterClass equals: #EDAAMemoryEventStore
]

{ #category : #tests }
EDAACandidateTest >> testAdapterMatchingKeyIsPreferred [
	| candidate |
	candidate := (EDAACandidate withKey: 'EDAAMongoEventStore' value: nil)
		adapterClass.
	self assert: candidate equals: #EDAAMongoEventStore
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

{ #category : #tests }
EDAACandidateTest >> testPriorityIsUsedToPickThePragmaAdapter [
	| candidate |
	candidate := (EDAACandidate withKey: 'arbitraryKey' value: nil)
		adapterClassesFromPragma first.
	self assert: candidate equals: #EDAAMemoryEventStore
]

{ #category : #tests }
EDAACandidateTest >> testSeveralAdaptersWithTheSameKeyAreSupported [
	| candidates |
	candidates := (EDAACandidate withKey: 'arbitraryKey' value: nil)
		adapterClasses.
	self assert: (candidates includes: #EDAAMongoEventStore).
	self assert: (candidates includes: #EDAAMemoryEventStore)
]
