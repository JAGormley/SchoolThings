#include <stdio.h>
#include <stdlib.h>

// COURSE

typedef struct {
    char* name;
    int mark;
} Course;

void init_Course(Course* c, char* n, int m) {
    c->name = n;
    c->mark = m;
}

// TRANSCRIPT

typedef struct {
    char* studentName;
    int maxNoCourses;        // max number of courses transcript can have
    int noCourses;           // actual number of courses in the transcript
    Course courses[];        // array of courses
} Transcript;

void init_Transcript(Transcript* t, int n){
    t = (Transcript*) malloc(sizeof(Transcript) + n*sizeof(Course));
    t->maxNoCourses = n;
    t->noCourses = 0;
//    return t;
}

void setName(Transcript* t, char* newName){
    t->studentName = newName;
}

char* getName(Transcript* t){
    return t->studentName;
}

int getNoCourses(Transcript* t){
    return t->noCourses;
}

void addCourse(Transcript* t, Course* c){
    int num = getNoCourses(t);
    int max = t->maxNoCourses;
    
    if (num < max){
        t->courses[num].name = c->name;
        t->courses[num].mark = c->mark;
        t->noCourses++;
    }
}

float average(Transcript* t) {
    float sum = 0.0;
    int total = t->noCourses;
    
    int i;
    for (i=0; i<total; i++){
        sum += t->courses[i].mark;
    }
    return sum / total;
}

// MAIN

int main() {
    Transcript t;
    Course c;
    
    init_Transcript(&t, 10);
    init_Course(&c, "cooking", 233);
    
//    char* name = "John Too";
//    setName(t, name);
//    
//    c = (Course*) malloc(sizeof(Course));
//    char* cn1 = "CPSC 121";
//    init_Course(c, cn1, 75);
//    addCourse(t, c);
//    free(c);
//    
//    c = (Course*) malloc(sizeof(Course));
//    char* cn2 = "CPSC 210";
//    init_Course(c, cn2, 85);
//    addCourse(t, c);
//    free(c);
//    
//    c = (Course*) malloc(sizeof(Course));
//    char* cn3 = "CPSC 213";
//    init_Course(c, cn3, 90);
//    addCourse(t, c);
//    free(c);
//    
//    char* stName = getName(t);
//    float stAvg = average(t);
//    
//    printf("%s's marks are:\n", stName);
//    int i;
//    for (i=0; i<getNoCourses(t); i++) {
//        printf("   %s: %d", t->courses[i].name, t->courses[i].mark);
//    }
//    printf("\n");
//    printf("%s's average is %f.", stName, stAvg); 
//    printf("\n");
    
    return 0;
}
