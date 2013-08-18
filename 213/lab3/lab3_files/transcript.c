typedef struct {
    static String studentName;
	static int maxNoCourses; // max number of courses transcript can have
	static int noCourses;  // actual number of courses in the transcript	
	static Course *courses;  //   array of courses
} Transcript;

typedef struct {
    static String name;
	static int mark;
} Course;

void init_Transcript(Transcript* t, int n){
    t->maxNoCourses = n;
    t->noCourses = 0;
    t->courses = (Course *) malloc(3*sizeof(Course));
}

void init_Course(Course* c, String n, int m){
    c->name = n;
    c->mark = m;
}

void setName(Transcript* t, String newName) {
    t->studentName = newName;
}

String getName(Transcript* t) {
    return t->studentName;
}

int getNoCourses(Transcript* t) {
    return t->noCourses;
}

void addCourse(Transcript* t, Course c) {
    if (t->noCourses < t->maxNoCourses) {
        courses[t->noCourses] = c;
        t->noCourses++;
    }
}
/**
 * @return the average over all the marks of this transcript
 */
float average(Transcript* t) {
    float sum = 0;
    int i = 0;
    for (i; i< t->noCourses; i++) {
        sum += t->courses[i]->mark;
    }
    return sum/t->noCourses;
}