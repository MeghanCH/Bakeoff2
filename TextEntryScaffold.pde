import java.util.Arrays;
import java.util.Collections;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException; 
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

String[] phrases;
int totalTrialNum = 4; //the total number of phrases to be tested - set this low for testing. Might be ~10 for the real bakeoff!
int currTrialNum = 0; // the current trial number (indexes into trials array above)
int matchIndex = 0;
float startTime = 0; // time starts when the first letter is entered
float finishTime = 0; // records the time of when the final trial ends
float lastTime = 0; //the timestamp of when the last trial was completed
float lettersEnteredTotal = 0; //a running total of the number of letters the user has entered (need this for final WPM computation)
float lettersExpectedTotal = 0; //a running total of the number of letters expected (correct phrases)
float errorsTotal = 0; //a running total of the number of errors (when hitting next)
String currentPhrase = ""; //the current target phrase
String currentTyped = ""; //what the user has typed so far
String currentWord = ""; //current word typed so far
String currentGuess = "";

WordBuckets wb;
final int DPIofYourDeviceScreen = 306; //you will need to look up the DPI or PPI of your device to make sure you get the right scale!!
                                      //http://en.wikipedia.org/wiki/List_of_displays_by_pixel_density
final float sizeOfInputArea = DPIofYourDeviceScreen*1.25; //aka, 1.25 inches square!

//Variables for my silly implementation. You can delete these:
char currentLetter = ' ';

//You can modify anything in here. This is just a basic implementation.
void setup()
{
  phrases = loadStrings("phrases2.txt"); //load the phrase set into memory
  Collections.shuffle(Arrays.asList(phrases)); //randomize the order of the phrases
  orientation(PORTRAIT); //can also be LANDSCAPE -- sets orientation on android device
  size(720,1280); //Sets the size of the app. You may want to modify this to your device. Many phones today are 1080 wide by 1920 tall.
  textFont(createFont("Arial", 30)); //set the font to arial 36
  noStroke(); //my code doesn't use any strokes.
  
  //path to dictionary file
    String dictFile = "E://Documents//processing-2.0.3-windows64//processing-2.0.3//TextEntryScaffold//TextEntryScaffold//data//newDict.txt";
    //word for which keypad equivalents have to be found
    
    //no. of dictionary words to pre-process
    int preprocessCount = 200000;    
    
    wb = new WordBuckets(dictFile);
    try {
        wb.init();    
        wb.loadWordsFromDict(preprocessCount);
        wb.addWord("cnz"); //illustrates adding non-dictionary words

        long startMatch = System.currentTimeMillis();
        System.out.println("Matches for word: "+currentWord+" "+wb.getMatches(currentWord));
        //System.out.println("match time:"+(System.currentTimeMillis()-startMatch));
    }catch(FileNotFoundException e){
      System.out.println("Could not find dict: " + dictFile);      
      e.printStackTrace();
    }catch(IOException e){
      System.out.println("Error loading dict: " + dictFile);      
      e.printStackTrace();
    }
}

//You can modify anything in here. This is just a basic implementation.
void draw()
{
  background(0); //clear background

  fill(100);
  rect(200, 500, sizeOfInputArea, sizeOfInputArea); //input area should be 2" by 2"

  if (finishTime!=0)
  {
    fill(255);
    textAlign(CENTER);
    text("Finished", 280, 450);
    return;
  }

  if (startTime==0 & !mousePressed)
  {
    fill(255);
    textAlign(CENTER);
    text("Click to start time!", 280, 450); //display this messsage until the user clicks!
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
    text("Phrase " + (currTrialNum+1) + " of " + totalTrialNum, 70, 350); //draw the trial count
    fill(255);
    text("Target:   " + currentPhrase, 70, 400); //draw the target string
    text("Entered:  " + currentTyped, 70, 440); //draw what the user has entered thus far 
    fill(51, 163, 255);
    rect(620, 600, 100, 100); //draw next button
    fill(255);
    textFont(createFont("Arial", 20)); //set the font to arial 20
    text("NEXT > ", 640, 650); //draw next label
    textFont(createFont("Arial", 30)); //set the font to arial 36
    
    // draw backspace box
    fill(255,0,0);
    rect(200+sizeOfInputArea*3/4,500,sizeOfInputArea/4,sizeOfInputArea/4);
    fill(255);
    text("<-",200+sizeOfInputArea*3/4+sizeOfInputArea/12,500+sizeOfInputArea/7);
    
    //my draw code
    textAlign(CENTER);
    System.out.println(currentWord);
    if (wb.getMatches(currentWord).size() != 0) {
       System.out.println("match: " + wb.getMatches(currentWord).get(0).toString());
    }
    text(currentGuess, 200+sizeOfInputArea*3/8, 500+sizeOfInputArea/7); //draw current letter
     
    String letters = "";
    for (int i=0; i<3; i++) { 
      for(int j=0; j<3; j++){
        fill(51,163,255);
        strokeWeight(2);
        stroke(0, 0, 0);
        if (j == 0 && i == 0) {
          fill(51,255,153);
        }
        rect(200+(i%3)*sizeOfInputArea/3, 500+sizeOfInputArea/4+(j%3)*sizeOfInputArea/4, sizeOfInputArea/3, sizeOfInputArea/4); //draw left red button
        
        if (j == 0 && i == 0) {
          letters = "guess";
          fill(51,163,255);
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
        text(letters, 200+(i%3)*sizeOfInputArea/3 + sizeOfInputArea/6, 500+sizeOfInputArea/4+(j%3)*sizeOfInputArea/4 + sizeOfInputArea/7);
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
    
    //check if backspace is hit, delete
    if(didMouseClick(200+sizeOfInputArea*3/4,500,sizeOfInputArea/4,sizeOfInputArea/4)){
      if (currentWord.length() == 0) {
        if (currentTyped.length()>=2) {
          int lastIndex = currentTyped.lastIndexOf(' ');
          if (lastIndex == -1) {
            currentTyped = "";
          }
          else {
            currentTyped = currentTyped.substring(0,lastIndex);
          }
          currentTyped+="|";
        }
      }
      else {
        if (currentWord.length() >= 1) {
          currentWord = currentWord.substring(0,currentWord.length()-1);
          currentGuess = currentWord;
        }
      }
    }
    
  float x;
  float y;
  for (int i=0; i<3; i++) { 
      for(int j=0; j<3; j++){
        x = 200+(i%3)*sizeOfInputArea/3;
        y = 500+sizeOfInputArea/4+(j%3)*sizeOfInputArea/4;
        if (didMouseClick(x, y, sizeOfInputArea/3, sizeOfInputArea/4)) {
          if (j == 0 && i == 0) {
              if (wb.getMatches(currentWord).size() != 0) {
                int numMatches = wb.getMatches(currentWord).size();
                currentGuess = wb.getMatches(currentWord).get(matchIndex).toString();
                if (matchIndex < numMatches-1) {
                  matchIndex++;
                }
                else if (matchIndex == numMatches-1) {
                  matchIndex = 0;
                }
              }
          } 
          else if (j == 0 && i == 1) {
              currentLetter = 'a';
          }
          else if (j == 0 && i == 2) {
                currentLetter = 'd';
          }
          else if (j == 1 && i == 0) { 
                currentLetter = 'g';
          }
          else if (j == 1 && i == 1) {
                currentLetter = 'j';
          }
          else if (j == 1 && i == 2) {
                currentLetter = 'm';
          }
          else if (j == 2 && i == 0) {
                currentLetter = 'p';
          }
          else if (j == 2 && i == 1) {
                currentLetter = 't';
          }
          else if (j == 2 && i == 2) {
                currentLetter = 'w';
          }
          if (!(j == 0 && i == 0)) {
            currentWord += currentLetter;
            currentGuess = currentWord;
            matchIndex = 0;
          }
          fill(0, 0, 0);
          rect(200+(i%3)*sizeOfInputArea/3, 500+sizeOfInputArea/4+(j%3)*sizeOfInputArea/4, sizeOfInputArea/3, sizeOfInputArea/4);
         
          fill(51, 163, 255);
          rect(200+(i%3)*sizeOfInputArea/3, 500+sizeOfInputArea/4+(j%3)*sizeOfInputArea/4, sizeOfInputArea/3, sizeOfInputArea/4);
        }
      }
    }
  
  if (didMouseClick(200, 500, sizeOfInputArea*3/4, sizeOfInputArea/4)) //check if click occured in submit area
  {
    if (currentLetter != ' ') {
      if(currentTyped.length()!=0){
        currentTyped = currentTyped.substring(0,currentTyped.length()-1);
      }
        currentWord = currentGuess;
        if (currentTyped.length() == 0)  {
          currentTyped += currentWord+"|";
        }
        else {
          currentTyped += " " + currentWord+"|";
        }
        currentWord = "";
        currentGuess = currentWord;
        currentLetter = ' ';
    }
  }

  //You are allowed to have a next button outside the 2" area
  if (didMouseClick(620, 600, 100, 100)) //check if click is in next button
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
    currentWord = "";
    currentGuess = currentWord;
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



public class PreSorted {
  
//  public static void main(String[] args){
//    //path to dictionary file
//    String dictFile = "C://Users//Claire//Desktop//dict.txt";
//    //word for which keypad equivalents have to be found
//    String word = "dg";
//    
//    //no. of dictionary words to pre-process
//    int preprocessCount = 200000;    
//    
//    WordBuckets wb = new WordBuckets(dictFile);
//    try {
//        wb.init();    
//        wb.loadWordsFromDict(preprocessCount);
//        wb.addWord("cnz"); //illustrates adding non-dictionary words
//
//        long startMatch = System.currentTimeMillis();
//        System.out.println("Matches for word: "+word+" "+wb.getMatches(word));
//        //System.out.println("match time:"+(System.currentTimeMillis()-startMatch));
//    }catch(FileNotFoundException e){
//      System.out.println("Could not find dict: " + dictFile);      
//      e.printStackTrace();
//    }catch(IOException e){
//      System.out.println("Error loading dict: " + dictFile);      
//      e.printStackTrace();
//    }
//  }
}

//methods to split the dictionary into buckets based on keypad,
//find matches for a given key sequence and add words to the wordlist 
class WordBuckets{
  
    //String(concatenated bucketid of each char in the word) -> List of strings  
  Map bucketedWords = new HashMap(); 
  
  Map charBuckets = new HashMap(); //char -> int (bucketid)
  List dict = new ArrayList(); //list of all dictionary words
  
  private final String[] buckets = {"abc","def", "ghi", "jkl", "mno", 
                                         "pqrs", "tuv", "wxyz"};  
  private String dictFile;  
  
  WordBuckets(String dictFile){
    this.dictFile = dictFile;
  }
  
  public void init() throws FileNotFoundException, IOException{
        for(int i=0;i<buckets.length;i++){
          String word = buckets[i];
          for(int j=0;j<word.length();j++){
            charBuckets.put(new Character(word.charAt(j)),new Integer(i));
          }
        }
        loadDict();
  }
  
  public List getMatches(String word){
    List matches = new ArrayList();
    String key = getKeyForWord(word);
    if(key != null){
      if(bucketedWords.containsKey(key)){
            matches = (List)bucketedWords.get(key);    
      }
    }
    return matches;
  }
  
  public void loadWordsFromDict(int wordCount){
        for(Iterator it=dict.iterator();it.hasNext() && wordCount>0;){
          String word = (String)it.next();
          addWord(word);
          wordCount--;
        }
  }
  
  public void addWord(String word){
    String key = getKeyForWord(word);
    if(key != null){
        if(!bucketedWords.containsKey(key)){
          bucketedWords.put(key, new ArrayList());
        }
        ((List)bucketedWords.get(key)).add(word);      
    }
  }  
 
  private String getKeyForWord(String word){
    String key = "";
    boolean isValidWord = true;
      for(int i=0;i<word.length() && isValidWord;i++){
          char ch = word.charAt(i);
          if(charBuckets.containsKey(new Character(ch))){
            Object keynum = charBuckets.get(new Character(ch));
            key = key + ((Integer)keynum).toString();
          }else{
              key = null;
              isValidWord = false;
          }
      }
      return key;
  }
  
  private void loadDict() throws FileNotFoundException, IOException{
//    BufferedReader fr = null;
//    try{
//      fr = createReader(dictFile);
//      //BufferedReader br = createReader(fr);
//      String line;
//      while((line=fr.readLine()) != null){
//        line = line.trim();
//        dict.add(line);
//      }
//    }finally{
//      if(fr != null){
//        try{
//          fr.close();
//        }catch(IOException e){
//          
//        }
//      }
     String[] dictArray = loadStrings("newDict.txt");
     for (int i=0; i<dictArray.length; i++) {
       dict.add(dictArray[i]);  
     }  
  }
  
}
