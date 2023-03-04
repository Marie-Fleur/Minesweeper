import de.bezier.guido.*;

int NUM_ROWS = 25;
int NUM_COLS = 25;
int MAX_MINES = 65;
boolean endGame = false;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton> ();

//ArrayList of just the minesweeper buttons that are mined

void setup ()
{
  size(600, 600);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make(this);

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }

  setMines();
}
public void setMines()
{
  int createdMines = 0;
  while (createdMines < MAX_MINES) {
    int r = (int)(Math.random()*(NUM_ROWS));
    int c = (int)(Math.random()*(NUM_COLS));
    if (!mines.contains(buttons[r][c])) {
      mines.add(buttons[r][c]);
      createdMines++;
    }
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}

public boolean isWon()
{
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      if (!(buttons[r][c].isClicked() || mines.contains(buttons[r][c]))) {
        return false;
      }
    }
  }
  return true;
}

public void displayMessage(String message)
{
  endGame = true;
  int rows = NUM_ROWS / 2 ;
  int cols = NUM_COLS / 2- message.length() / 2;
  for (int i = 0; i < message.length(); i++)
    buttons[rows][cols + i].setLabel("" + message.charAt(i));
}

public void displayLosingMessage()
{
  for (int i = 0; i < mines.size(); i++)
    mines.get(i).setClicked(true);

  displayMessage("You lost");
}

public void displayWinningMessage()
{
  displayMessage("You win");
}

public boolean isValid(int r, int c)
{
  if (r >= 0 && c >= 0 && r < NUM_ROWS && c < NUM_COLS) {
    return true;
  }
  return false;
}

public int countMines(int row, int col)
{
  int sum = 0;
  for (int numCol = col-1; numCol < col+2; numCol++) {
    if (isValid(row-1, numCol) == true && mines.contains(buttons[row-1][numCol])) {
      sum++;
    }
    if (isValid(row+1, numCol) == true && mines.contains(buttons[row+1][numCol])) {
      sum++;
    }
  }
  if (isValid(row, col-1) == true && mines.contains(buttons[row][col-1])) {
    sum++;
  }
  if (isValid(row, col+1) == true && mines.contains(buttons[row][col+1])) {
    sum++;
  }
  return sum;
}

public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 600/NUM_COLS;
    height = 600/NUM_ROWS;
    myRow = row;
    myCol = col;
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  public boolean isClicked() {
    return clicked;
  }

  public void setClicked(boolean val) {
    clicked = val;
  }

  // called by manager
  public void mousePressed ()
  {
    if (endGame) return;

    clicked = true;

    if (mouseButton == RIGHT) {
      flagged = !flagged;
      if (!flagged) clicked = false;
    } else if (mines.contains(this)) {
      displayLosingMessage();
    } else if (countMines(myRow, myCol) > 0) {
      myLabel = "" + countMines(myRow, myCol);
    } else {
      for (int col = myCol-1; col < myCol+2; col++) {
        for (int row = myRow-1; row < myRow+2; row++) {
          if (col == myCol && row == myRow) continue;
          if (isValid(row, col) && !buttons[row][col].isClicked()) buttons[row][col].mousePressed();
        }
      }
    }
  }

  public void draw ()
  {
    if (flagged) 
      fill(0);
    else if ( clicked && mines.contains(this) )
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else
      fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
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
}
