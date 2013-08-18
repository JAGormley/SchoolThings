// Andrew Gormley
// Student ID 22724124
// CS ID b7q8
// Lab L0A (WF 1:30-3:30pm)
//
// Susannah Kirby
// Student ID 24087124
// CS ID e5r8
// Lab L0A (WF 1:30-3:30pm)

#include <iostream>
#include <fstream>
#include <sstream>
#include <cstdlib>
#include <ctime>
#include <iostream>
#include <cmath>
#include <algorithm>
#include <cstring>

using namespace std;

/* A TableEntry holds a key-value pair */
class TableEntry {
private:
    std::string key;
    int value;
public:
    TableEntry(std::string key, int value) {
        this->key = key;
        this->value = value;
    }
    
    std::string getKey() { return key; }
    int getValue() { return value; }
    
};

static int TOMBSTONE = -1;

/* A Hasher has a pointer to a table, a hash function type (good/bad),
 and a probe type (quadratic, double). */
class Hasher {
private:
    TableEntry** table;
    char typ;
    char probe;
    int tableSize;
    int totalProbes;
    int numInserts;
    int probes2;
    
    // Helper functions that are not part of the public interface:
    
    //HASHERS:
    
    /* A not-great way to hash entries */
    int poorHash(std::string key){
        int acc = 0;
        for (int i = 0; i < key.length(); i++){
            acc += key[i];
        }
        acc = acc % getTableSize();
        return acc;
    }
    /* A better way to hash entries */
    int goodHash(std::string key){
        int acc = 0;
        int randy = 0;
        for (int i = 0; i < key.length(); i++){
            acc += key[i];
        }
        randy = rand() % getTableSize();
        acc = (acc * 37 + 17)*randy % getTableSize();        
        return acc;
        
    }
    
    /* Tally up how many probes were required on average to get
     all the desired key-value pairs into the table */
    void tallyProbes(int p) {
        totalProbes += p;
        numInserts++;
    };
    
    /* Print out the tallyProbes() stats */
    void printStats() {
        cout << "Average probes/insert = " <<
        (float)totalProbes / (float)numInserts << " = " <<
        totalProbes << "/" << numInserts << endl;
    }
    
    //PROBERS:
    
    /* Quadratic probing.
     PARAM: hashedKey - the key to hash
     searchType - search or insert
     PRE: searchType must be 's' or 'i'
     POST: if possible, location in table is found
     */
    int qProbe(int hashedKey, char searchType){
        
        int counter = 0;
        int power = 0;
        
        if (searchType == 's')
            while (table[(hashedKey + power)%getTableSize()] == NULL || table[(hashedKey + power)%getTableSize()]->getValue() == TOMBSTONE){
                counter++;
                power = counter*counter;
            }
        
        if (searchType == 'i')
            while (table[(hashedKey + power)%getTableSize()] != NULL){
                counter++;
                power = counter*counter;
                
            }
        tallyProbes(counter+1);
        return (hashedKey + power)%getTableSize();
    }
    /* Double probing.
     PARAM: hashedKey - the key to hash
     searchType - either search or insert
     PRE: searchType must be 's' or 'i'
     POST: if possible, location in table is found
     */
    int dProbe(int hashedKey, char searchType){
        
        int counter = 0;
        if (searchType == 's'){
            while (table[hashedKey] == NULL || table[hashedKey]->getValue() == TOMBSTONE){
                counter++;
                hashedKey = (hashedKey+counter)*7 % getTableSize();
            }
        }
        if (searchType == 'i'){
            while (table[hashedKey] != NULL){
                counter++;
                hashedKey = (hashedKey+counter)*7 % getTableSize();
            }
        }
        
        tallyProbes(counter+1);
        return hashedKey;
    }
    
public:
    
    /* This hasher initializes an empty table that can later have key-value pairs
     hashed to it manually.
     PARAM: type - (hash type) good or bad
     crp - conflict resolution principle (quadratic or double probing)
     PRE: type must be 'g' or 'b'
     crp must be 'q' or 'd'
     POST: empty hash table is initialized
     */
    Hasher(char type, char crp){
        this->typ = type;
        this->probe = crp;
        this->tableSize = 101;
        this->totalProbes = 0;
        this->numInserts = 0;
        this->probes2 = 0;
        table = new TableEntry* [getTableSize()];
        for( int i=0; i<getTableSize(); i++ ) {
            table[i] = NULL;
        }
    }
    
    /* This hasher creates a table and fills it to some load using key-value pairs
     from a text file.
     PARAM: type - (hash type) good or bad
     crp - conflict resolution principle (quadratic or double probing)
     load - what proportion of the table should have entries
     filename - the txt file where the key-value pairs to be hashed are found
     PRE: type must be 'g' or 'b'
     crp must be 'q' or 'd'
     load must be 0 <= load <= 1.00
     filename must be txt file in same directory
     POST: hash table is initialized and filled with desired proportion of entries
     from given text file
     */
    Hasher(char type, char crp, double load, string filename){
        this->typ = type;
        this->probe = crp;
        this->tableSize = 101;
        this->totalProbes = 0;
        this->numInserts = 0;
        this->probes2 = 0;
        int numHashEntries = 0;
        
        // VARS FOR FILE READING
        string wholeLine;
        string keyToInsert;
        int valueToInsert;
        
        // GET NUM OF ELEMENTS IN FILE
        ifstream datafile;
        datafile.open(filename.c_str());
        if (datafile.is_open())
        while (getline(datafile, wholeLine)) {
            numHashEntries++;
        }
        datafile.close();
        
        
        // FILL THE TABLE
        datafile.open(filename.c_str());
        string hashEntriesTotal;
        ostringstream convert;
        convert << numHashEntries;
        hashEntriesTotal = convert.str();
        cout << "Number of entries will be " << hashEntriesTotal << endl;
        tableSize = numHashEntries/load;
        while (!isPrime(tableSize)) {
            tableSize++;
        }
        cout << "Table size will be " << tableSize << endl;
        
        table = new TableEntry* [tableSize];        

        if (datafile.is_open()) {
            
            cout << "datafile is open" << endl;
            
            for(int i=0; i<numHashEntries; i++) {
                getline(datafile, wholeLine);
                
//                cout << "wholeLine pulled from datafile" << endl;
                
                keyToInsert = wholeLine.substr(0,7);
                valueToInsert = atoi(wholeLine.substr(9).c_str());
                
//                cout << "About to enter key-value pair" << endl;
                
                insert(keyToInsert, valueToInsert);
                
//                cout << "KVP entered" << endl;
            }
            datafile.close();
        }
        else
            cout << "Unable to open file." << endl;
    }
    
    
    /* Search for the key of interest.
     PARAM: key you want to find in the table
     subscript - spot in the table you're currently searching in
     searchtype - whether search is for '
     PRE: search type must be valid ('q' or 'd')
     */
    bool search(std::string key, int& subscript, char searchType){
        
        int hashedKey = -1;
        int location = -1;
        
        if (getQuality() == 'g'){
            hashedKey = goodHash(key);
        }
        if (getQuality() == 'b'){
            hashedKey = poorHash(key);
        }
        if (getProbe() == 'q'){
            location = qProbe(hashedKey, searchType);
        }
        if (getProbe() == 'd'){
            location = dProbe(hashedKey, searchType);
        }
        if (location != -1){
            subscript = location;
            return true;
        }
        return false;
    }
    
    /* Insert the key-value pair into the table
     PARAM: key - key to be hashed for insert
     value - value to insert
     PRE: key must be alphanumeric
     POST: key-value pair is inserted into the table spot as a new TableEntry
     */
    bool insert(std::string key, int value){
        int chippy = -1;
        search(key, chippy, 'i');
        if (chippy != -1){
            
            table[chippy] = new TableEntry(key, value);
            return true;
        }
        return false;
    }
    
    /* Remove a key-value pair from the table
     PARAM: key - key to search for
     PRE: key must be a string
     POST: key-value pair associated with key is removed from table
     */
    bool remove(std::string key){
        int subscript = -1;
        search(key, subscript, 's');
        if (subscript != -1){
            table[subscript] = NULL;
            table[subscript] = new TableEntry("", TOMBSTONE);
            
            return true;
        }
        return false;
    }
    
    /* Is the table already full? */
    bool isFull() {
        return (totalProbes == getTableSize());
    }
    
    // modified from an algorithm written by Francesco Balena
    // downloaded from http://www.devx.com/vb2themax/Tip/19051
    /**@pre x>0
     * @post if x was prime, true returned, else false
     */
    const bool isPrime(const int x){
        if (x == 1 || x == 2 || x == 3 || x == 5) return true; if (x % 2 == 0 || x % 3 == 0) { return false; }
        int incr = 4; // NOTE: sqrt needs #include <math.h>
        const int maxFact = (int) sqrt( (double) x );
        for (int fact = 5; fact <= maxFact; fact += incr) { if (x % fact == 0) { return false; }
            incr = 6 - incr;
        }
        return true; }
    
    // Simply outputs the current contents of the table and the indices (you can write a loop
    // that just prints out the underlying array):
    // E.g.
    // table->printTable() might generate:
    // 25 HBZEJKGA 1
    // 32 RHJMIVTA 2
    //
    
    /* Outputs the current key-value pair contents of the table and their indices
     POST: table is printed to console
     */
    void printTable(){
//        cout << "Started printTable()" << endl;
        
        for( int i=0; i<getTableSize(); i++ ) {
            if (table[i] != NULL && table[i]->getKey() != "" && table[i]->getValue() != TOMBSTONE){
                stringstream ss;
                ss << i;
                std::string position(ss.str());
                std::cout << position << " " << table[i]->getKey() << " " << table[i]->getValue() << std::endl;
            }
        }
//        cout << "Finished printTable()" << endl;
    }
    
    /* Various "getter" functions */
    char getQuality(){ return typ; };
    char getProbe(){ return probe; };
    int getTableSize(){ return tableSize; }
    void getStats() { printStats(); }
    
    /* Destructor -- do not alter. */
    ~Hasher()
    {
        for (int i = 0; i<getTableSize(); i++)
            if (table[i] != NULL)
                delete table[i];
        delete[] table;
    }
};

// **Sample** main function/driver-- THIS IS NOT A COMPLETE TEST SUITE
// YOU MUST WRITE YOUR OWN TESTS
// See assignment description.
int main(int argc, char* argv[])
{
    // Generate empty hash tables:
//    Hasher* goodHashRP1 = new Hasher('g', 'd');
//    Hasher* goodHashQP1 = new Hasher('g', 'q');
//    Hasher* badHashRP1 = new Hasher('b', 'd');
//    Hasher* badHashQP1 = new Hasher('b', 'q');
    
    // Generate hash tables that are systematically loaded from file.
    // Note that if you cannot fit an element you should stop inserting elements
    // and set a flag to full.
    
//    Hasher* goodHashRP2 = new Hasher('g', 'd', 0.75, "small.txt");
    Hasher* goodHashQP2 = new Hasher('g', 'q', 0.75, "big2.txt");
//    Hasher* poorHashRP2 = new Hasher('b', 'd', 0.75, "small.txt");
    Hasher* poorHashQP2 = new Hasher('b', 'q', 0.75, "big2.txt");
    
    // Sample use case:
    
//    std::string key = "TBWETRPQ";
//    int value = 10;
//    
//    if(goodHashQP2->insert(key, value))
//        std::cout << "Inserted" << std::endl;
//    else
//        std::cout << "Failed to insert" << std::endl;
//    
//    //
//    int subscript = -1;
//    
//    if(goodHashQP1->search(key, subscript, 's'))
//        std::cout << "Found at " << subscript << std::endl;
//    else
//        std::cout << "Failed to find" << std::endl;
//    
//    
//    goodHashQP1->printTable();
//    
//    if(goodHashQP1->remove(key))
//        std::cout << "Removed" << std::endl;
//    else
//        std::cout << "Not deleted/not found" << std::endl;
    
    
//    goodHashRP1->printTable();
//    goodHashQP1->printTable();
//    badHashRP1->printTable();
//    badHashQP1->printTable();
    
//    goodHashRP2->printTable();
//    poorHashQP2->printTable();
    goodHashQP2->getStats();
    poorHashQP2->getStats();
    
    
    return 0;
}
