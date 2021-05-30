Class {
	#name : #EDAAVOMongoRepository,
	#superclass : #VOMongoRepository,
	#traits : 'EDACTPrintOnHelper',
	#classTraits : 'EDACTPrintOnHelper classTrait',
	#category : #'EDAA-EventStore-Voyage'
}

{ #category : #voyage }
EDAAVOMongoRepository class >> voyageCollectionName [
	^ 'EventSourcingEvent'
]

{ #category : #voyage }
EDAAVOMongoRepository >> collectionNameFor: aClass [
	^ aClass voyageCollectionName
]

{ #category : #persistence }
EDAAVOMongoRepository >> selectMany: aClass where: aBlock sortBy: sortBlock [
	^ self selectManyOperation
		queryClass: aClass;
		where: aBlock;
		sortBlock: sortBlock;
		execute

]
