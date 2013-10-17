//
//  ViewController.m
//  ProvaCocoaPod
//
//  Created by Daniele Ceglia on 14/10/13.
//  Copyright (c) 2013 Relifeit (Daniele Ceglia). All rights reserved.
//

#import "ViewController.h"
#import <RestKit/RestKit.h>

#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)test:(id)sender
{
    NSLog(@"test RestKit con Core Data...");
    
    /* DEFINIZIONE URL DEL WEBSERVICE REST */
    
    NSURL *baseURL = [NSURL URLWithString:@"https://relifeit.apiary.io"];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];
    
    /* CORE DATA */
	// Il managed object model e context sono già gestiti dai metodi dichiarati nell'app delegate
	// quindi qui lo recuperiamo. Sarebbe meglio usare un singleton tipo https://gist.github.com/rojotek/2362546
	// invece dell'app delegate per metodi relativi a core data.
	AppDelegate *appDelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
    NSManagedObjectModel *managedObjectModel = appDelegate.managedObjectModel;
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    objectManager.managedObjectStore = managedObjectStore;
    
    
    
    /* MAPPATURA JSON CON GLI OGGETTI DEL MODELLO */
    
    RKEntityMapping *autoriMapping = [RKEntityMapping mappingForEntityForName:@"Autori" inManagedObjectStore:managedObjectStore];
    RKEntityMapping *articoliMapping = [RKEntityMapping mappingForEntityForName:@"Articoli" inManagedObjectStore:managedObjectStore];
    
    
    /*** mappatura stats ***/
    
    [autoriMapping addAttributeMappingsFromDictionary:@{@"name"     : @"nome",
                                                        @"email"    : @"email",
                                                        @"id"       : @"idAutore"}];
    autoriMapping.identificationAttributes = @[@"idAutore"];
    
    
    /*** mappatura venues ***/
    
    [articoliMapping addAttributeMappingsFromDictionary:@{@"id"               : @"idArticolo",
                                                          @"title"            : @"titolo",
                                                          @"body"             : @"corpo",
                                                          @"publication_date" : @"dataPubblicazione"}];
    articoliMapping.identificationAttributes = @[@"idArticolo"];
	
	RKResponseDescriptor *articleDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:articoliMapping method:RKRequestMethodGET pathPattern:nil keyPath:@"article" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
	RKResponseDescriptor *authorDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:autoriMapping method:RKRequestMethodGET pathPattern:nil keyPath:@"authors" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
	[objectManager addResponseDescriptorsFromArray:@[articleDescriptor, authorDescriptor]];

	// Preparo operazione con managedObejctContext che permetterà a RestKit di creare una entry in CoreData.
	// Nota: Il managed object context è inizializzato in AppDelegate con un concurrency type NSMainQueueConcurrencyType
	// perché RestKit userà [NSManagedObjectContext -performBlockAndWait:]
	RKManagedObjectRequestOperation *operation = [objectManager managedObjectRequestOperationWithRequest:[NSURLRequest requestWithURL:[objectManager.baseURL URLByAppendingPathComponent:@"/asd"]]
                                                                                    managedObjectContext:appDelegate.managedObjectContext
                                                                                                 success:^(RKObjectRequestOperation *operaton, RKMappingResult *mappingResult)
                                                                                                        {
                                                                                                            NSLog(@"Mappatura riuscita: %@", mappingResult);
                                                                                                        }
                                                                                                 failure:^(RKObjectRequestOperation *operaton, NSError *error)
                                                                                                        {
                                                                                                            NSLog (@"Mappattura FALLITA: %@ \n\nErrore: %@", operaton, error);
                                                                                                        }];
	
	[objectManager enqueueObjectRequestOperation:operation];
}

@end
