import de.bezier.guido.*;
public final static int NUM_ROWS = 10;
public final static int NUM_COLS = 10;
private MSButton[][] buttons; //2d array of minesweeper buttons
public int numClicked = 0;
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int i = 0; i < NUM_ROWS; i++)
    {
      for(int j = 0; j < NUM_COLS; j++)
      {
        buttons[i][j] = new MSButton(i,j);
      }
    }
    
    setMines();
}
public void setMines()
{
    int nX = (int)(Math.random() * NUM_COLS);
    int nY = (int)(Math.random() * NUM_ROWS);
    for(int i = 0; i < 15; i++)
    {
      if(mines.contains(buttons[nY][nX]))
      {
        nX = (int)(Math.random() * NUM_COLS);
        nY = (int)(Math.random() * NUM_ROWS);
        i--; 
      } else
      {
        mines.add(buttons[nY][nX]);
      }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    return (numClicked > (NUM_ROWS * NUM_COLS) - mines.size());
}
public void displayLosingMessage()
{
    for(int i = 0; i < buttons.length; i++)
    {
      for(int j = 0; j < buttons[i].length; j++)
      {
        buttons[i][j].setLabel("womp womp");
      }
    }
}
public void displayWinningMessage()
{
    for(int i = 0; i < buttons.length; i++)
    {
      for(int j = 0; j < buttons[i].length; j++)
      {
        buttons[i][j].setLabel("yay");
      }
    }
}
public boolean isValid(int r, int c)
{ 
    return (((r > -1) && (r < NUM_ROWS)) && ((c > -1) && (c < NUM_COLS)));
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int i = row - 1; i < row + 2; i++)
    {
      for(int g = col - 1; g < col + 2; g++)
      {
        if(isValid(i,g) && mines.contains(buttons[i][g]))
        {
          numMines++;
          //System.out.println(numMines);
        }
      }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
         width = 400/NUM_COLS;
         height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        if(mouseButton == RIGHT)
        {
          flagged = !flagged;
        } else if(mines.contains(this) && !flagged)
        {
          clicked = true;
          displayLosingMessage();
        } else if(countMines(myRow, myCol) > 0 && !flagged)
        {
          numClicked++;
          clicked = true;
          this.setLabel(countMines(myRow, myCol));
        } else if(!flagged)
        {
          numClicked++;
          clicked = true;
          for(int i = myRow - 1; i < myRow+2; i++)
          {
          for(int j = myCol - 1; j < myCol + 2; j++)
           {
            //if((i == myRow) &&(j == myCol))
            //{
            // i++;
            //}
            if(isValid(i,j) && !buttons[i][j].isClicked())
            {
              buttons[i][j].mousePressed();
            }
          }
         }
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
         else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
    public boolean isClicked()
    {
      return clicked;
    }
}
