Class {
	#name : #EDAAVOMongoRepository,
	#superclass : #VOMongoRepository,
	#traits : 'EDACPrintOnHelper + EDACPragmaHelper',
	#classTraits : 'EDACPrintOnHelper classTrait + EDACPragmaHelper classTrait',
	#category : #'EDAA-EventStore-Voyage'
}

{ #category : #voyage }
EDAAVOMongoRepository class >> voyageCollectionName [
	^ 'EDAEventSourcingEvent'
]

{ #category : #private }
EDAAVOMongoRepository >> collectionNameFor: aClass [

	^ (self retrievePragma: #eventStoreCollection: in: aClass) ifNil: [ aClass voyageCollectionName ] ifNotNil: [ :p | p arguments first ]

]

{ #category : #persistence }
EDAAVOMongoRepository >> selectMany: aClass where: aBlock sortBy: sortBlock [
	^ self selectManyOperation
		queryClass: aClass;
		where: aBlock;
		sortBlock: sortBlock;
		execute

]
