//
//  ParseViewController.m
//  TanieChlanie
//
//  Created by Edzio27 Edzio27 on 27.05.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import "ParseViewController.h"
#import "AFNetworking.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface ParseViewController ()

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation ParseViewController

- (void)hideIndicator {
    NSLog(@"hide");
}

- (NSOperationQueue *)queue {
    if(_queue == nil) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

- (NSManagedObjectContext *)managedObjectContext {
    if(_managedObjectContext == nil) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = appDelegate.managedObjectContext;
    }
    return _managedObjectContext;
}

- (void)downloadJSONAsString:(void(^)(NSString *result))handler; {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://taniechlanie.pl/JSON/promocje"]];
    [self performSelector:@selector(cancelAllOperations) withObject:self afterDelay:30];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(cancelAllOperations) object:self];
            NSDictionary *jsonDict = (NSDictionary *) JSON;
            /* remove all element from core data */
            [self removeDataFromDatabase];
            [self parseDictionaryToCoreDataModel:jsonDict];
            handler(@"parsed");
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(cancelAllOperations) object:self];
            NSLog(@"Request Failure Because %@",[error userInfo]);
        }];
    [self.queue addOperation:operation];
    [operation start];
}

- (void)cancelAllOperations {
    [self.queue cancelAllOperations];
    [self.delegate hideIndicator];
}

- (void)parseDictionaryToCoreDataModel:(NSDictionary *)dictionary {
    for(NSDictionary *dict in dictionary) {
        NSDictionary *productDictionary = [dict objectForKey:@"fields"];
        
        NSManagedObjectContext *context = [self managedObjectContext];
        NSManagedObject *failedBankInfo = [NSEntityDescription
                                           insertNewObjectForEntityForName:@"Product"
                                           inManagedObjectContext:context];
        
        [failedBankInfo setValue:[productDictionary objectForKey:@"name"] forKey:@"name"];
        [failedBankInfo setValue:[productDictionary objectForKey:@"price"] forKey:@"price"];
        [failedBankInfo setValue:[productDictionary objectForKey:@"literprice"] forKey:@"priceForLiter"];
        [failedBankInfo setValue:[productDictionary objectForKey:@"end_date"] forKey:@"endDate"];
        [failedBankInfo setValue:[productDictionary objectForKey:@"start_date"] forKey:@"startDate"];
        [failedBankInfo setValue:[productDictionary objectForKey:@"product_image"] forKey:@"imageURL"];
        [failedBankInfo setValue:[productDictionary objectForKey:@"url"] forKey:@"productURL"];
        [failedBankInfo setValue:[productDictionary objectForKey:@"size"] forKey:@"size"];
        [failedBankInfo setValue:[productDictionary objectForKey:@"quantity"] forKey:@"quantity"];


        if(![self getManagetObjectWithName:[productDictionary objectForKey:@"shop"]]) {
            NSManagedObject *failedBankDetails = [NSEntityDescription
                                                  insertNewObjectForEntityForName:@"Shop"
                                                  inManagedObjectContext:self.managedObjectContext];
            [failedBankDetails setValue:[productDictionary objectForKey:@"shop"] forKey:@"name"];
            [failedBankInfo setValue:failedBankDetails forKey:@"shop"];
        } else {
            [failedBankInfo setValue:[self getManagetObjectWithName:[productDictionary objectForKey:@"shop"]] forKey:@"shop"];
        }
        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
}

- (NSManagedObject *)getManagetObjectWithName:(NSString *)shopName {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Shop" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"name = %@", shopName]];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if(array.count > 0) {
        return [array objectAtIndex:0];
    }
    return nil;
}

- (void)clearEntity:(NSString *)entity {
    NSFetchRequest *fetchLLObjects = [[NSFetchRequest alloc] init];
    [fetchLLObjects setEntity:[NSEntityDescription entityForName:entity inManagedObjectContext:self.managedObjectContext]];

    NSError *error = nil;
    NSArray *allObjects = [self.managedObjectContext executeFetchRequest:fetchLLObjects error:&error];
    for (NSManagedObject *object in allObjects) {
        [self.managedObjectContext deleteObject:object];
    }

    NSError *saveError = nil;
    if (![self.managedObjectContext save:&saveError]) {
        NSLog(@"removed");
    }
}

- (void)removeDataFromDatabase {
    [self clearEntity:@"Product"];
    [self clearEntity:@"Shop"];
}

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
