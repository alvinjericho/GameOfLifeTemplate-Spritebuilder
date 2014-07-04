//
//  Grid.m
//  GameOfLife
//
//  Created by Alvin Jericho Perlas on 7/4/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//




#import "Grid.h"
#import "Creature.h"

// these are variables that cannot be changed
static const int GRID_ROWS = 8;
static const int GRID_COLUMNS = 10;

@implementation Grid
{
    NSMutableArray * _gridArray;
    float _cellWidth;
    float _cellHeight;
}

- (void)onEnter
{
    [super onEnter];
    
    [self setupGrid];
    
    // accept touches on the grid
    self.userInteractionEnabled = YES;
}

- (void)setupGrid
{
    // divide the grid's size by the number of columns/rows to figure out the right width and height of each cell
    _cellWidth = self.contentSize.width / GRID_COLUMNS;
    _cellHeight = self.contentSize.height / GRID_ROWS;
    
    float x = 0;
    float y = 0;
    
    // initialize the array as a blank NSMutableArray
    _gridArray = [NSMutableArray array];
    
    
    // initialize Creatures
    for (int i = 0; i < GRID_ROWS; i++)
    {
        // this is how you create two dimensional arrays in Objective-C. You put arrays into arrays.
        _gridArray[i] = [NSMutableArray array];
        x = 0;
        
        for (int j = 0; j < GRID_COLUMNS; j++)
        {
            Creature *creature = [[Creature alloc] initCreature];
            creature.anchorPoint = ccp(0, 0);
            creature.position = ccp(x, y);
            [self addChild:creature];
            
            // this is shorthand to access an array inside an array
            _gridArray[i][j] = creature;
            
            // make creatures visible to test this method, remove this once we know we have filled the grid properly
        //    creature.isAlive = YES;
            
            x+=_cellWidth;
        }
        
        y += _cellHeight;
    }
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    //get the x,y coordinates of the touch
    CGPoint touchLocation = [touch locationInNode:self];
    
    //get the Creature at that location
    Creature *creature = [self creatureForTouchPosition:touchLocation];
    
    //invert it's state - kill it if it's alive, bring it to life if it's dead.
    creature.isAlive = !creature.isAlive;
}

- (Creature *)creatureForTouchPosition:(CGPoint)touchPosition
{
    NSLog(@"creatureForTouchPosition");
    //get the row and column that was touched, return the Creature inside the corresponding cell
    
    
    int row = touchPosition.y/_cellHeight;
    int column = touchPosition.x/_cellWidth;
    
    return _gridArray[row][column];

}

- (void) evolveStep
{
    //update each Creature's neighbor count
    [self countNeighbors];
    
    //update each Creature's state
    [self updateCreatures];
    
    //update the generation so the label's text will display the correct generation
    _generation++;
}



- (void) updateCreatures
{
    /*
     Now it's your turn to write updateCreatures.
     Declare the method in Grid.h, create it in Grid.m.
     You will need to create a double-nested for-loop like we did in countNeighbors to access every creature in the Grid.
     Look over the code in countNeighbors if you need a refresher on how to do that.
     
     Next you need to create an if/else if statement.
     In the if statement, check if the Creature's livingNeighbors property is set to 3.
     If it is, that means it has 3 live neighbors so you want to set its isAlive property to TRUE.
     
     In the else if you want to check
     if the Creature has less than or equal to 1 living neighbors or more than or equal to 4.
     If either are true, set the Creature's isAlive property to FALSE.
     
     Once you've completed updateCreatures,
     run your game and see what happens.
     If you populate some cells and then tap start, you should see the game run properly.
     Try some of these popular patterns and see if they behave as expected.
     
     The only thing that should be missing is the count of live Creatures.
     To make the label update properly,
     add an int called numAlive to the beginning of your updateCreatures method and set it to 0.
     Inside the loop that checks if creatures are alive you need to increment numAlive by 1 for every creature that is alive.
     
     At the very end of your updateCreatures method,
     set _totalAlive = numAlive;.
     
     Run the game again */
    
    
    for(int i = 0; i< [_gridArray count] ; i++)
    {
        for(int j = 0; j < [_gridArray[i] count]; j++)
        {
            Creature * creature = _gridArray[i][j];
            if(creature.livingNeighbors == 3)
                creature.isAlive = true;
            else if (creature.livingNeighbors <= 1 || creature.livingNeighbors >=4)
                creature.isAlive = false;
            //else{}
        }
    }
}





- (void) countNeighbors
{
    // iterate through the rows
    // note that NSArray has a method 'count' that will return the number of elements in the array
    for (int i = 0; i < [_gridArray count]; i++)
    {
        // iterate through all the columns for a given row
        for (int j = 0; j < [_gridArray[i] count]; j++)
        {
            // access the creature in the cell that corresponds to the current row/column
            Creature *currentCreature = _gridArray[i][j];
            
            // remember that every creature has a 'livingNeighbors' property that we created earlier
            currentCreature.livingNeighbors = 0;
            
            // now examine every cell around the current one
            
            // go through the row on top of the current cell, the row the cell is in, and the row past the current cell
            for (int x = (i-1); x <= (i+1); x++)
            {
                // go through the column to the left of the current cell, the column the cell is in, and the column to the right of the current cell
                for (int y = (j-1); y <= (j+1); y++)
                {
                    // check that the cell we're checking isn't off the screen
                    BOOL isIndexValid;
                    isIndexValid = [self isIndexValidForX:x andY:y];
                    
                    // skip over all cells that are off screen AND the cell that contains the creature we are currently updating
                    if (!((x == i) && (y == j)) && isIndexValid)
                    {
                        //Creature *neighbor = ;
                        if ([_gridArray[x][y] isAlive])
                        {
                            currentCreature.livingNeighbors += 1;
                        }
                    }
                }
            }
        }
    }
}





- (BOOL)isIndexValidForX:(int)x andY:(int)y
{
    BOOL isIndexValid = YES;
    if(x < 0 || y < 0 || x >= GRID_ROWS || y >= GRID_COLUMNS)
    {
        isIndexValid = NO;
    }
    return isIndexValid;
}




@end

