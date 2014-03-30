import java.util.Arrays;
import java.util.Collections;

String[] phrases;
int totalTrialNum = 4; //the total number of phrases to be tested - set this low for testing. Might be ~10 for the real bakeoff!
int currTrialNum = 0; // the current trial number (indexes into trials array above)
float startTime = 0; // time starts when the first letter is entered
float finishTime = 0; // records the time of when the final trial ends
float lastTime = 0; //the timestamp of when the last trial was completed
float lettersEnteredTotal = 0; //a running total of the number of letters the user has entered (need this for final WPM computation)
float lettersExpectedTotal = 0; //a running total of the number of letters expected (correct phrases)
float errorsTotal = 0; //a running total of the number of errors (when hitting next)
String currentPhrase = ""; //the current target phrase
String currentTyped = ""; //what the user has typed so far
final int DPIofYourDeviceScreen = 306; //you will need to look up the DPI or PPI of your device to make sure you get the right scale!!
                                      //http://en.wikipedia.org/wiki/List_of_displays_by_pixel_density
final float sizeOfInputArea = DPIofYourDeviceScreen*1.25; //aka, 1.25 inches square!

//Variables for my silly implementation. You can delete these:
char currentLetter = 'a';

//You can modify anything in here. This is just a basic implementation.
void setup()
{
  phrases = loadStrings("phrases2.txt"); //load the phrase set into memory
  Collections.shuffle(Arrays.asList(phrases)); //randomize the order of the phrases
  orientation(PORTRAIT); //can also be LANDSCAPE -- sets orientation on android device
  size(720,1280); //Sets the size of the app. You may want to modify this to your device. Many phones today are 1080 wide by 1920 tall.
  textFont(createFont("Arial", 36)); //set the font to arial 36
  noStroke(); //my code doesn't use any strokes.
}

//You can modify anything in here. This is just a basic implementation.
void draw()
{
  background(0); //clear background

  fill(100);
  rect(200, 200, sizeOfInputArea, sizeOfInputArea); //input area should be 2" by 2"

  if (finishTime!=0)
  {
    fill(255);
    textAlign(CENTER);
    text("Finished", 280, 150);
    return;
  }

  if (startTime==0 & !mousePressed)
  {
    fill(255);
    textAlign(CENTER);
    text("Click to start time!", 280, 150); //display this messsage until the user clicks!
  }

  if (startTime==0 & mousePressed)
  {
    nextTrial(); //start the trials!
  }

  if (startTime!=0)
  {
    //you will need something like the next 10 lines in your code. Output does not have to be within the 2 inch area!
    textAlign(LEFT); //align the text left
    fill(128);
    text("Phrase " + (currTrialNum+1) + " of " + totalTrialNum, 70, 50); //draw the trial count
    fill(255);
    text("Target:   " + currentPhrase, 70, 100); //draw the target string
    text("Entered:  " + currentTyped, 70, 140); //draw what the user has entered thus far 
    fill(255, 0, 0);
    rect(620, 300, 100, 100); //drag next button
    fill(255);
    textFont(createFont("Arial", 20)); //set the font to arial 36
    text("NEXT > ", 670, 300); //draw next label

    //my draw code
    textAlign(CENTER);
    text("" + currentLetter, 200+sizeOfInputArea/2, 200+sizeOfInputArea/5); //draw current letter
    
    
    String letters = "";
    for (int i=0; i<3; i++) { 
      for(int j=0; j<3; j++){
        fill(255, 0, 0);
        strokeWeight(2);
        stroke(0, 0, 0);
        rect(200+(i%3)*sizeOfInputArea/3, 200+sizeOfInputArea/4+(j%3)*sizeOfInputArea/4, sizeOfInputArea/3, sizeOfInputArea/4); //draw left red button
        
        if (j == 0 && i == 0) {
          letters = "_";
        }
        else if (j == 0 && i == 1) {
          letters = "abc";
        }
        else if (j == 0 && i == 2) {
          letters = "def";
        }
        else if (j == 1 && i == 0) {
          letters = "ghi";
        }
        else if (j == 1 && i == 1) {
          letters = "jkl";
        }
        else if (j == 1 && i == 2) {
          letters = "mno";
        }
        else if (j == 2 && i == 0) {
          letters = "pqrs";
        }
        else if (j == 2 && i == 1) {
          letters = "tuv";
        }
        else if (j == 2 && i == 2) {
          letters = "wxyz";
        }
        
        fill(0,0,0);
        text(letters, 200+(i%3)*sizeOfInputArea/3 + sizeOfInputArea/6, 200+sizeOfInputArea/4+(j%3)*sizeOfInputArea/4 + sizeOfInputArea/7);
      }
    }
  }
}

boolean didMouseClick(float x, float y, float w, float h) //simple function to do hit testing
{
  return (mouseX > x && mouseX<x+w && mouseY>y && mouseY<y+h); //check to see if it is in button bounds
}


void mousePressed()
{

//  if (didMouseClick(200, 200+sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/2)) //check if click in left button
//  {
//    currentLetter --;
//    if (currentLetter<'_') //wrap around to z
//      currentLetter = 'z';
//  }
//
//  if (didMouseClick(200+sizeOfInputArea/2, 200+sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/2)) //check if click in right button
//  {
//    currentLetter ++;
//    if (currentLetter>'z') //wrap back to space (aka underscore)
//      currentLetter = '_';
//  }
  float x;
  float y;
  for (int i=0; i<3; i++) { 
      for(int j=0; j<3; j++){
        fill(255, 0, 0);
        strokeWeight(2);
        stroke(0, 0, 0);
        x = 200+(i%3)*sizeOfInputArea/3;
        y = 200+sizeOfInputArea/4+(j%3)*sizeOfInputArea/4;
        rect(x, y, sizeOfInputArea/3, sizeOfInputArea/4); 
        if (didMouseClick(x, y, sizeOfInputArea/3, sizeOfInputArea/4)) {
          if (j == 0 && i == 0) {
              currentLetter = '_';  
          }
          else if (j == 0 && i == 1) {
              if(currentLetter!='_' && (currentLetter=='a' || currentLetter=='b'))
              currentLetter ++;
              else
              currentLetter = 'a';
              if (currentLetter>'c') 
                currentLetter = 'a';
          }
          else if (j == 0 && i == 2) {
              if(currentLetter!='_' && (currentLetter=='d' || currentLetter=='e'))
              currentLetter ++;
              else
              currentLetter = 'd';
              if (currentLetter>'f') 
                currentLetter = 'd';
          }
          else if (j == 1 && i == 0) {
              if(currentLetter!='_' && (currentLetter=='g' || currentLetter=='h'))
              currentLetter ++;
              else
              currentLetter = 'g';
              if (currentLetter>'i') 
                currentLetter = 'g';
          }
          else if (j == 1 && i == 1) {
              if(currentLetter!='_' && (currentLetter=='j' || currentLetter=='k'))
              currentLetter ++;
              else
              currentLetter = 'j';
              if (currentLetter>'l') 
                currentLetter = 'j';
          }
          else if (j == 1 && i == 2) {
              if(currentLetter!='_' && (currentLetter=='m' || currentLetter=='n'))
              currentLetter ++;
              else
              currentLetter = 'm';
              if (currentLetter>'o') 
                currentLetter = 'm';
          }
          else if (j == 2 && i == 0) {
              if(currentLetter!='_' && (currentLetter=='p' || currentLetter=='q' || currentLetter=='r'))
              currentLetter ++;
              else
              currentLetter = 'p';
              if (currentLetter>'s') 
                currentLetter = 'p';
          }
          else if (j == 2 && i == 1) {
              if(currentLetter!='_' && (currentLetter=='t' || currentLetter=='u'))
              currentLetter ++;
              else
              currentLetter = 't';
              if (currentLetter>'v') 
                currentLetter = 't';
          }
          else if (j == 2 && i == 2) {
              if(currentLetter!='_' && (currentLetter=='w' || currentLetter=='x' || currentLetter=='y'))
              currentLetter ++;
              else
              currentLetter = 'w';
              if (currentLetter>'z') 
                currentLetter = 'w';
          }
        }
      }
    }
  
  if (didMouseClick(200, 200, sizeOfInputArea, sizeOfInputArea/4)) //check if click occured in letter area
  {
    if (currentLetter=='_') //if underscore, consider that a space bar
      currentTyped+=" ";
//    else if (currentLetter=='`' & currentTyped.length()>0) //if `, treat that as a delete command
//      currentTyped = currentTyped.substring(0, currentTyped.length()-1);
//    else if (currentLetter!='`') //if not any of the above cases, add the current letter to the typed string
    else
      currentTyped+=currentLetter;
  }

  //You are allowed to have a next button outside the 2" area
  if (didMouseClick(800, 00, 200, 200)) //check if click is in next button
  {
    nextTrial(); //if so, advance to next trial
  }
}


void nextTrial()
{
  if (currTrialNum >= totalTrialNum) //check to see if experiment is done
    return; //if so, just return

    if (startTime!=0 && finishTime==0) //in the middle of trials
  {
    System.out.println("==================");
    System.out.println("Phrase " + (currTrialNum+1) + " of " + totalTrialNum); //output
    System.out.println("Target phrase: " + currentPhrase); //output
    System.out.println("Phrase length: " + currentPhrase.length()); //output
    System.out.println("User typed: " + currentTyped); //output
    System.out.println("User typed length: " + currentTyped.length()); //output
    System.out.println("Number of errors: " + computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim())); //trim whitespace and compute errors
    System.out.println("Time taken on this trial: " + (millis()-lastTime)); //output
    System.out.println("Time taken since beginning: " + (millis()-startTime)); //output
    System.out.println("==================");
    lettersExpectedTotal+=currentPhrase.length();
    lettersEnteredTotal+=currentTyped.length();
    errorsTotal+=computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim());
  }

  if (currTrialNum == totalTrialNum-1) //check to see if experiment just finished
  {
    finishTime = millis();
    System.out.println("==================");
    System.out.println("Trials complete!"); //output
    System.out.println("Total time taken: " + (finishTime - startTime)); //output
    System.out.println("Total letters entered: " + lettersEnteredTotal); //output
    System.out.println("Total letters expected: " + lettersExpectedTotal); //output
    System.out.println("Total errors entered: " + errorsTotal); //output
    System.out.println("WPM: " + (lettersEnteredTotal/5.0f)/((finishTime - startTime)/60000f)); //output
    System.out.println("==================");
    currTrialNum++; //increment by one so this mesage only appears once when all trials are done
    return;
  }

  if (startTime==0) //first trial starting now
  {
    System.out.println("Trials beginning! Starting timer..."); //output we're done
    startTime = millis(); //start the timer!
  }
  else
  {
    currTrialNum++; //increment trial number
  }

  lastTime = millis(); //record the time of when this trial ended
  currentTyped = ""; //clear what is currently typed preparing for next trial
  currentPhrase = phrases[currTrialNum]; // load the next phrase!
  //currentPhrase = "abc"; // uncomment this to override the test phrase (useful for debugging)
}




//=========SHOULD NOT NEED TO TOUCH THIS AT ALL!==============
int computeLevenshteinDistance(String phrase1, String phrase2)  
{
  int[][] distance = new int[phrase1.length() + 1][phrase2.length() + 1];

  for (int i = 0; i <= phrase1.length(); i++)
    distance[i][0] = i;
  for (int j = 1; j <= phrase2.length(); j++)
    distance[0][j] = j;

  for (int i = 1; i <= phrase1.length(); i++)
    for (int j = 1; j <= phrase2.length(); j++)
      distance[i][j] = min(min(distance[i - 1][j] + 1, distance[i][j - 1] + 1), distance[i - 1][j - 1] + ((phrase1.charAt(i - 1) == phrase2.charAt(j - 1)) ? 0 : 1));

  return distance[phrase1.length()][phrase2.length()];
}
