//
//  CoreDataHelper.h
//  
//
//  Created by Daniele Ceglia on 17/03/12.
//  Copyright (c) 2012 DCsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataHelper : NSObject


// metodi per il recupero degli oggetti

+ (NSMutableArray *)cercaOggettiPerEntita:(NSString*)nomeEntita
                             conPredicato:(NSPredicate *)predicato
                       eChiaveOrdimanento:(NSString*)chiaveOrdiamento
                    eOrdinamentoCrescente:(BOOL)ordinamentoCrescente
                                eContesto:(NSManagedObjectContext *)managedObjectContext;

+ (NSMutableArray *)ottieniOggettiPerEntita:(NSString*)nomeEntita
                       conChiaveOrdinamento:(NSString*)chiaveOrdiamento
                      eOrdinamentoCrescente:(BOOL)ordinamentoCrescente
                                  eContesto:(NSManagedObjectContext *)managedObjectContext;
 

// metodi per il conteggio degli oggetti

+ (NSUInteger)conteggioPerEntita:(NSString *)nomeEntita
                    conPredicato:(NSPredicate *)predicato
                       eContesto:(NSManagedObjectContext *)managedObjectContext;

+ (NSUInteger)conteggioPerEntita:(NSString *)nomeEntita
                       eContesto:(NSManagedObjectContext *)managedObjectContext;


// metodi per la cancellazione degli oggetti

+ (BOOL)cancellaTuttiGliOggettiPerEntita:(NSString*)nomeEntita
                            conPredicato:(NSPredicate*)predicato
                               eContesto:(NSManagedObjectContext *)managedObjectContext;

+ (BOOL)cancellaTuttiGliOggettiPerEntita:(NSString*)nomeEntita
                               eContesto:(NSManagedObjectContext *)managedObjectContext;


@end
