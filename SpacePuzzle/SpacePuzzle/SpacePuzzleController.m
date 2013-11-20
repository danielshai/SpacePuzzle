//
//  GViewViewController.m
//  SpacePuzzle

#import "SpacePuzzleController.h"
#import "Element.h"
#import "Converter.h"
#import "Rock.h"
#import "Star.h"
#import "Player.h"

@implementation SpacePuzzleController
@synthesize board = _board;
@synthesize scene = _scene;
@synthesize currentUnit = _currentUnit;
@synthesize bigL = _bigL;
@synthesize littleJohn = _littleJohn;
@synthesize player = _player;

-(void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    _scene = [MainScene sceneWithSize:skView.bounds.size];
    _scene.scaleMode = SKSceneScaleModeAspectFill;
    
    _player = [[Player alloc] init];
    
    [self setupBoard];
    [self setupElements];
    [self setupUnits];
    
    // Present the scene.
    [skView presentScene:_scene];
    
    // Add observers to the view.
    [self observeText:UNIT_MOVED Selector:@selector(unitMoved:)];
    [self observeText:UNIT_WANTS_TO_MOVE Selector:@selector(unitWantsToMove:)];
}

/*
 *  Loads the board according to the level. ADD LEVELFACTORY!!!. */
-(void)setupBoard {
    // TEMP CODE.
    _board = [[Board alloc] init];
    // Load the board.

    NSString *path = [[NSBundle mainBundle] pathForResource:@"mario" ofType:@"splvl"];
    
    [_board loadBoard:path];
    
    for(int i = 0; i < BOARD_SIZE_Y; i++) {
        for(int j = 0; j < BOARD_SIZE_X; j++) {
            BoardCoord *bc = [_board.board objectAtIndex:BOARD_SIZE_X*i + j];
            [_scene setupBoardX:[bc x] Y:[bc y] Status:[bc status]];
        }
    }
}

-(void)setupElements {
    // Talk to the scene what to show.
    NSEnumerator *enumerator = [[_board elementDictionary] objectEnumerator];
    Element *obj;
    while((obj = [enumerator nextObject])) {
        CGPoint p = CGPointMake([obj x], [obj y]);
        NSString *str = NSStringFromClass([obj class]);
        
        [_scene setupElement:p Name:str];
    }
}

-(void)unitWantsToMove:(NSNotification *)notification {
    // Get data.
    NSArray *data = [self getDataFromNotification:notification Key:UNIT_WANTS_TO_MOVE];
    NSValue *val = [data objectAtIndex:0];
    NSValue *val2 = [data objectAtIndex:1];
    
    // The position that the unit wants to move to.
    NSInteger x  = val.CGPointValue.x;
    NSInteger y = val.CGPointValue.y;
    
    // The unit who wants to move's position.
    NSInteger unitX = val2.CGPointValue.x;
    NSInteger unitY = val2.CGPointValue.y;
    
    // First check if the movement was inside the board and if the tile isn't |void| (which units cannot
    // move to).
    if(x >= 0 && x < BOARD_SIZE_X && y >= 0 && y < BOARD_SIZE_Y
       && [[[_board board] objectAtIndex:y*BOARD_SIZE_X + x] status] != MAPSTATUS_VOID) {
        // Checks if the move is 1 step in x or y, but not both at the same time.
        if( ((x - unitX == 1 || x - unitX == -1) && y == unitY) ||
            ((y - unitY == 1 || y - unitY == -1) && x == unitX) )
        {
            // Check elements on the board.
            NSNumber *curKey = [NSNumber numberWithInt:y*BOARD_SIZE_X + x];
            Element *e = [[_board elementDictionary] objectForKey:curKey];
            
            // If the element exists.
            if(e) {
                if ([e isKindOfClass:[Rock class]]) {
                    NSInteger nextTile;
                    Element *ee;
                    CGPoint hitPoint = CGPointMake(x, y);
                    CGPoint origin = CGPointMake(unitX, unitY);
                    NSInteger dir = [Converter convertCoordsTo:hitPoint Direction:origin];
                    NSNumber *nextKey = [NSNumber numberWithInt:y*BOARD_SIZE_X + x];
                    
                    if (dir == RIGHT) {
                        nextKey = [NSNumber numberWithInt:y*BOARD_SIZE_X + x + 1];
                        ee = [[_board elementDictionary] objectForKey:nextKey];
                    } else if (dir == LEFT) {
                        nextKey = [NSNumber numberWithInt:y*BOARD_SIZE_X + x - 1];
                        ee = [[_board elementDictionary] objectForKey:nextKey];
                    } else if (dir == UP) {
                        nextKey = [NSNumber numberWithInt:(y - 1)*BOARD_SIZE_X + x];
                        ee = [[_board elementDictionary] objectForKey:nextKey];
                    } else {
                        nextKey = [NSNumber numberWithInt:(y + 1)*BOARD_SIZE_X + x];
                        ee = [[_board elementDictionary] objectForKey:nextKey];
                    }
                
                    if (![ee isKindOfClass:[Rock class]]) {
                        NSInteger intKey = [nextKey integerValue];
                        // Add this to if-statement when |Lever|-class is created "|| [ee isKindOfClass:[Lever class]]"
                        nextTile = [[[_board board] objectAtIndex:intKey] status];
                        
                        NSLog(@"%d", nextTile);
                        if(nextTile != MAPSTATUS_SOLID) {
                            [[_board elementDictionary] removeObjectForKey:curKey];
                            [_scene removeElementAtPosition:curKey];
                        }
                        
                        [e doMoveAction:dir];
                        [_scene updateElement:origin NewCoord:hitPoint];
                        //nextTile should invoke its "doAction"...
                    }
                }
                //[e doMoveAction];
                // If the element isn't blocking, move unit.
                if(![e blocking]) {
                    _currentUnit.x = x;
                    _currentUnit.y = y;
                    [_scene updateUnit:CGPointMake(x, y)];
                    [e movedTo];
                    
                    // If the element is a star.
                    if([e isKindOfClass:[Star class]]) {
                        _player.starsTaken += 1;
                        [[_board elementDictionary] removeObjectForKey:curKey];
                        [_scene removeElementAtPosition:curKey];
                    }
                }
            }
            else {
                _currentUnit.x = x;
                _currentUnit.y = y;
                [_scene updateUnit:CGPointMake(x, y)];
            }
        }
    }
}

/* 
 *  Called when a notification of unit movement is sent from the |MainScene|. Updates the data model of the
 *  unit accordingly. */
-(void)unitMoved:(NSNotification *)notification {
    NSArray *data = [self getDataFromNotification:notification Key:UNIT_MOVED];
    NSValue *val = [data objectAtIndex:0];
    // UPDATE DATA MODEL.
}

-(NSArray*) getDataFromNotification:(NSNotification *)notif Key:(NSString *)key {
    NSDictionary *userInfo = notif.userInfo;
    NSSet *objectSent = [userInfo objectForKey:key];
    return [objectSent allObjects];
}

/*
 *  Creates the units. */
-(void)setupUnits {
    _bigL = [[BigL alloc] init];
    _littleJohn = [[LittleJohn alloc] init];
    
    _currentUnit = _littleJohn;
    _littleJohn.x = _board.startPos.x;
    _littleJohn.y = _board.startPos.y;
    CGPoint p = CGPointMake(_littleJohn.x, _littleJohn.y);
    [_scene setupUnits:p];
}

/*
 *  Adds a notification to listen to from this class. */
-(void)observeText:(NSString *)text Selector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:text object:nil];
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
