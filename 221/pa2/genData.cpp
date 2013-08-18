#include <cstdlib>
#include <ctime>
#include <iostream>
#include <fstream>
#include <sstream>

using namespace std;

/* A program that generates n lines containing key-value pairs and writes them to a file. */ 


/* Returns the letter corresponding to a number between 0 and 25
PRE: 0 <= n < 26
POST: Roman alphabet letter is returned 
 */
char numberToLetter(int n) {
  char alphabet[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  return alphabet[n];
}

/* Generate n random key-value pairs */
void printKeyValuePairs(int n, string fileName) {
  //srand(time(0));

  //  ofstream dataFile(fileName);
  ofstream outfile(fileName.c_str());

  if (outfile.is_open()) {
    
    // for n lines
    for (int i=0; i<n; i++) {
      // generate and push out strings corresponding to 8 random numbers
      for (int j=0; j<8; j++) {
	int randNumber = rand() % 26;
	outfile << numberToLetter(randNumber); 
      }
      int lineInt = i+1;
      string lineNumber;
      ostringstream convert;
      convert << lineInt;
      lineNumber = convert.str();
	outfile << " " << lineNumber << endl; 
    }
    outfile.close();
  }
  else {
    cout << "There was a problem writing to the file.";
  }
}



int main(int argc, char *argv[]) {

  int numLines = atoi(argv[1]);
  string fileName = argv[2];

  srand(time(0)); 

  printKeyValuePairs(numLines, fileName);

  return 0;

} 
