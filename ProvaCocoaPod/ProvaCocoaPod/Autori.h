//
//  Autori.h
//  ProvaCocoaPod
//
//  Created by Daniele Ceglia on 14/10/13.
//  Copyright (c) 2013 Relifeit (Daniele Ceglia). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Articoli;

@interface Autori : NSManagedObject

@property (nonatomic, retain) NSNumber * idAutore;
@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSSet *newRelationship;
@end

@interface Autori (CoreDataGeneratedAccessors)

- (void)addNewRelationshipObject:(Articoli *)value;
- (void)removeNewRelationshipObject:(Articoli *)value;
- (void)addNewRelationship:(NSSet *)values;
- (void)removeNewRelationship:(NSSet *)values;

@end
