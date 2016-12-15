//
//  ViewController.m
//  TripleLiftTest
//
//  Created by iMac on 10/15/16.
//  Copyright © 2016 Moscova. All rights reserved.
//

#import "ViewController.h"
#import "TripleLiftAdObject.h"
#import <AFNetworking/AFNetworking.h>

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *numberofAdIDs;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* arrayOfObjects;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _arrayOfObjects = [[NSMutableArray alloc]init];
    [self addDoneToolBarToKeyboard];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- IBActions
- (IBAction)addIDs:(id)sender {
    
    UIAlertController* ac = [self searchForIDsAlertController];
    [self presentViewController:ac animated:YES completion:nil];
    
}
- (IBAction)dismissKeyboard:(id)sender {
    [_numberofAdIDs resignFirstResponder];
}




#pragma  mark -- TABLEVIEW

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrayOfObjects count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellID = @"cellID";
    TripleLiftAdObject* object = [_arrayOfObjects objectAtIndex:indexPath.row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.textLabel.text = [NSString stringWithFormat:@"%@, %@", object.adID, object.date];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", object.numberOfImpressions];
    }
    return cell;
}

#pragma  mark -- helper functions


-(UIAlertController*)searchForIDsAlertController{
    
    __weak ViewController* weakSelf = self;
    
    
    __block UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Search For Advertiser" message:@"Please only insert numeric values" preferredStyle:UIAlertControllerStyleAlert];
    
    int textFieldCount = [_numberofAdIDs.text intValue];
    if (textFieldCount > 0) {
        [self addTextFieldsToAlertController:alertController withCount:textFieldCount];
    } else {
        [self addTextFieldsToAlertController:alertController withCount:1];
    }

    
    UIAlertAction* alertAction = [UIAlertAction actionWithTitle:@"Done"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
    
                                                            for (UITextField* textField in alertController.textFields) {
                                                                int ID = [[weakSelf numberValueFromString:textField.text] intValue];
                                                                [weakSelf getAdvertiserInfoWithID:ID];
                                                            }
                                                            [alertController dismissViewControllerAnimated:YES completion:nil];
                                                            
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    

    [alertController addAction:alertAction];
    [alertController addAction:cancelAction];
    
    
    return alertController;
}




-(void)addTextFieldsToAlertController:(UIAlertController*)ac withCount:(int)count{
    for (int i = 0; i < count; ++i) {
        [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Advertiser ID";
        }];
    }
}



-(void)getAdvertiserInfoWithID:(int)ID{
    
    __weak ViewController* weakSelf = self;
    
    NSString* urlString = [NSString stringWithFormat:@"http://dan.triplelift.net/code_test.php?advertiser_id=%i",ID];
    NSURL* url =  [NSURL URLWithString:urlString];
    AFHTTPSessionManager* sessionManager = [[AFHTTPSessionManager alloc]init];
    [sessionManager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        for (NSDictionary* dict in responseObject) {
            TripleLiftAdObject* object = [[TripleLiftAdObject alloc]initWithDictionary:dict];
            [_arrayOfObjects addObject:object];
        }
        [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        NSLog(@"Success: %@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Failure: %@", error.localizedDescription);
    }];
}

-(NSString*)numberValueFromString:(NSString*)string{
    NSCharacterSet* charSet =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    return [[string componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
}

-(void)addDoneToolBarToKeyboard
{
    UIToolbar* doneToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    doneToolbar.barStyle = UIBarStyleBlackTranslucent;
    doneToolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyboard:)],
                         nil];
    [doneToolbar sizeToFit];
    _numberofAdIDs.inputAccessoryView = doneToolbar;
}

@end
