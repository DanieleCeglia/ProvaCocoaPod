//
//  CoreDataHelper.m
//  
//
//  Created by Daniele Ceglia on 17/03/12.
//  Copyright (c) 2012 DCsoft. All rights reserved.
//

#import "CoreDataHelper.h"

@implementation CoreDataHelper


#pragma mark - Recupero oggetti

// metodo per recuperare oggetti con un predicato...
+ (NSMutableArray *)cercaOggettiPerEntita:(NSString*)nomeEntita conPredicato:(NSPredicate *)predicato eChiaveOrdimanento:(NSString*)chiaveOrdiamento eOrdinamentoCrescente:(BOOL)ordinamentoCrescente eContesto:(NSManagedObjectContext *)managedObjectContext
{
	// creo la richiesta di recupero...
	NSFetchRequest *richiesta = [[NSFetchRequest alloc] init];
	NSEntityDescription *entita = [NSEntityDescription entityForName:nomeEntita inManagedObjectContext:managedObjectContext];
	[richiesta setEntity:entita];
    
	// se un predicato è stato specificato, allora verrà utilizzato nella richiesta...
	if (predicato != nil)
    {
		[richiesta setPredicate:predicato];
    }
    
	// se una chiave d'ordinamento è stata passata, allora verrà utilizzata nella richiesta...
	if (chiaveOrdiamento != nil)
    {
		NSSortDescriptor *descrittoreOrdinamento = [[NSSortDescriptor alloc] initWithKey:chiaveOrdiamento ascending:ordinamentoCrescente];
		NSArray *descrittoriOrdinamento = @[descrittoreOrdinamento];
		[richiesta setSortDescriptors:descrittoriOrdinamento];
	}
    
	// eseguo la richiesta di recupero...
	NSError *errore = nil;
	NSMutableArray *risultatoRichiesta = [[managedObjectContext executeFetchRequest:richiesta error:&errore] mutableCopy];
    
	// se l'array restituito è vuoto, allora c'è stato un errore...
	if (risultatoRichiesta == nil)
    {
		NSLog(@"Non posso ottenere oggetti per l'entità: %@\nErrore: %@", nomeEntita, [errore localizedDescription]);
    }
    
	// restituisco i risultati
	return risultatoRichiesta;
}

// metodo per recuperare oggetti senza un predicato...
+ (NSMutableArray *)ottieniOggettiPerEntita:(NSString*)nomeEntita conChiaveOrdinamento:(NSString*)chiaveOrdiamento eOrdinamentoCrescente:(BOOL)ordinamentoCrescente eContesto:(NSManagedObjectContext *)managedObjectContext
{
	return [self cercaOggettiPerEntita:nomeEntita conPredicato:nil eChiaveOrdimanento:chiaveOrdiamento eOrdinamentoCrescente:ordinamentoCrescente eContesto:managedObjectContext];
}


#pragma mark - Conteggio oggetti

// metodo per ottenere un conteggio per una entita con un predicato...
+ (NSUInteger)conteggioPerEntita:(NSString *)nomeEntita conPredicato:(NSPredicate *)predicato eContesto:(NSManagedObjectContext *)managedObjectContext
{
	// creo la richiesta di recupero...
	NSFetchRequest *richiesta = [[NSFetchRequest alloc] init];
	NSEntityDescription *entita = [NSEntityDescription entityForName:nomeEntita inManagedObjectContext:managedObjectContext];
	[richiesta setEntity:entita];
	[richiesta setIncludesPropertyValues:NO];
    
	// se un predicato è stato specificato, allora verrà utilizzato nella richiesta...
	if (predicato != nil)
    {
		[richiesta setPredicate:predicato];
    }
    
	// eseguo la richiesta di conteggio...
	NSError *errore = nil;
	NSUInteger conteggio = [managedObjectContext countForFetchRequest:richiesta error:&errore];
    
	// se il conteggio ha ritornato NSNotFound, allora c'è stato un errore...
	if (conteggio == NSNotFound)
    {
        NSLog(@"Non posso ottenere il conteggio degli oggetti per l'entità: %@\nErrore: %@", nomeEntita, [errore localizedDescription]);
    }
    
	// restituisco il risultato
	return conteggio;
}

// metodo per ottenere un conteggio per una entita senza un predicato...
+ (NSUInteger)conteggioPerEntita:(NSString *)nomeEntita eContesto:(NSManagedObjectContext *)managedObjectContext
{
	return [self conteggioPerEntita:nomeEntita conPredicato:nil eContesto:managedObjectContext];
}


#pragma mark - Rimozione oggetti

// metodo per cancellare tutti gli oggetti di una data entità...
+ (BOOL)cancellaTuttiGliOggettiPerEntita:(NSString*)nomeEntita conPredicato:(NSPredicate*)predicato eContesto:(NSManagedObjectContext *)managedObjectContext
{
	// creo la richiesta di recupero...
	NSFetchRequest *richiesta = [[NSFetchRequest alloc] init];
	NSEntityDescription *entita = [NSEntityDescription entityForName:nomeEntita inManagedObjectContext:managedObjectContext];
	[richiesta setEntity:entita];	
    
	// ignoro le property values per massimizzare le performance
	[richiesta setIncludesPropertyValues:NO];
    
	// se un predicato è stato specificato, allora verrà utilizzato nella richiesta...
	if (predicato != nil)
    {
		[richiesta setPredicate:predicato];
    }
    
	// eseguo la richiesta di conteggio...
	NSError *errore = nil;
	NSArray *risultatoRichiesta = [managedObjectContext executeFetchRequest:richiesta error:&errore];
    
	// se il risultato non è stato nullo, cancello gli oggetti ritornati...
	if (risultatoRichiesta != nil)
    {
		for (NSManagedObject *managedObject in risultatoRichiesta)
        {
			[managedObjectContext deleteObject:managedObject];
		}
	} else {
        NSLog(@"Non posso cancellare gli oggetti per l'entità: %@\nErrore: %@", nomeEntita, [errore localizedDescription]);
        
		return NO;
	}
    
	return YES;	
}

+ (BOOL)cancellaTuttiGliOggettiPerEntita:(NSString*)nomeEntita eContesto:(NSManagedObjectContext *)managedObjectContext
{
	return [self cancellaTuttiGliOggettiPerEntita:nomeEntita conPredicato:nil eContesto:managedObjectContext];
}


@end
