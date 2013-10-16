//
//  Articoli.h
//  ProvaCocoaPod
//
//  Created by Daniele Ceglia on 14/10/13.
//  Copyright (c) 2013 Relifeit (Daniele Ceglia). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Autori;

@interface Articoli : NSManagedObject

@property (nonatomic, retain) NSString * corpo;
@property (nonatomic, retain) NSString * dataPubblicazione;
@property (nonatomic, retain) NSNumber * idArticolo;
@property (nonatomic, retain) NSString * titolo;
@property (nonatomic, retain) NSSet *newRelationship;
@end

@interface Articoli (CoreDataGeneratedAccessors)

- (void)addNewRelationshipObject:(Autori *)value;
- (void)removeNewRelationshipObject:(Autori *)value;
- (void)addNewRelationship:(NSSet *)values;
- (void)removeNewRelationship:(NSSet *)values;

@end
