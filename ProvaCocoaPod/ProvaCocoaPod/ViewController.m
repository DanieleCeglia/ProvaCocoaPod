//
//  ViewController.m
//  ProvaCocoaPod
//
//  Created by Daniele Ceglia on 14/10/13.
//  Copyright (c) 2013 Relifeit (Daniele Ceglia). All rights reserved.
//

#import "ViewController.h"
#import <RestKit/RestKit.h>

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
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:baseURL];
    [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    
    
    /* CORE DATA */
    
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ProvaCocoaPod" ofType:@"momd"]];
    NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
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
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:articoliMapping method:RKRequestMethodGET pathPattern:nil keyPath:@"response" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    [objectManager getObjectsAtPath:[NSString stringWithFormat:@"%@%@", [objectManager.baseURL absoluteString], @"/asd"]
                         parameters:nil
                            success:^(RKObjectRequestOperation *operaton, RKMappingResult *mappingResult)
                                    {
                                        NSLog(@"Mappatura riuscita: %@", mappingResult);
                                    }
                            failure:^(RKObjectRequestOperation *operaton, NSError *error)
                                    {
                                        NSLog (@"Mappattura FALLITA: %@ \n\nErrore: %@", operaton, error);
                                    }];
}

@end
