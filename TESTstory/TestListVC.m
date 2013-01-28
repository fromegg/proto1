
#import "TestInfo.h"
#import "TestListVC.h"
#import "TestDetailsVC.h"
#import "AppDelegate.h"

#include <map>

@implementation TestListVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
   // [self.navigationController setToolbarHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
   // [self.navigationController setToolbarHidden:YES animated:YES];
   // [self.navigationController setToolbarHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
     [self.navigationController setToolbarHidden:NO animated:YES];
   // [self.navigationController setNavigationBarHidden: NO animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//#pragma message("why this doesnt depend on storyboard customization, it shouldnt be done programmaticaly")
    
    _managedObjectContext = [[AppDelegate sharedInstance] managedObjectContext];
    
    _testList = [[NSMutableArray alloc] initWithCapacity:20];
    
    NSEntityDescription* entDescription = [NSEntityDescription entityForName:@"TestInfo" inManagedObjectContext:_managedObjectContext];
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray* sortDiscriptors = @[sortDescriptor];
    
    NSFetchRequest* fetchReq = [NSFetchRequest new];
    [fetchReq setEntity:entDescription];
    [fetchReq setSortDescriptors:sortDiscriptors];
    
    NSError* err = nil;
    NSMutableArray* fetchResults = [[_managedObjectContext executeFetchRequest:fetchReq error:&err] mutableCopy];
    
    if(fetchResults == nil)
    {
        NSLog(@"Error");
    }
    
    _testList = [fetchResults mutableCopy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _testList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellCustom";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [[_testList objectAtIndex:indexPath.row] name];
    cell.detailTextLabel.text = [[_testList objectAtIndex:indexPath.row] cat];
    
    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddTest"])
	{
        UINavigationController *navigationController = segue.destinationViewController;
        TestDetailsVC* vc = [[navigationController viewControllers] objectAtIndex:0];
        
        vc.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"gotoTest"])
    {
        //        NSString* selectedTestName = [[_testList objectAtIndex:[[self tableView] indexPathForSelectedRow].row] name];
        TestInfo* selectedTest = [_testList objectAtIndex:[[self tableView] indexPathForSelectedRow].row];
        
        ((id<TestInfoHolder>)segue.destinationViewController).test = selectedTest;
    }
    else
    {
        return;
    }
    
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

-(void)createTestInfo:(NSString *)name :(NSString *)cat
{
    TestInfo* testInfoManaged = (TestInfo*)[NSEntityDescription insertNewObjectForEntityForName:@"TestInfo"  inManagedObjectContext:_managedObjectContext];
    
    testInfoManaged.cat = cat;
    testInfoManaged.name = name;
    
    NSError* err = nil;
    if(![_managedObjectContext save:&err])
    {
        NSLog(@"%@",[err localizedDescription]);
    }
    
    [_testList insertObject:testInfoManaged atIndex:0];
    [self.tableView reloadData];
}

-(IBAction)gotoPatientProfile:(id)sender
{
#pragma message("why this crashes?, without storyboard")
    //UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"userProfile"];
    //[self.navigationController popToViewController:next animated:YES];
   // [self presentViewController:next animated:YES completion:nil];
}






@end
