
public class Transcript {
	
	private String studentName;
	private int maxNoCourses; // max number of courses transcript can have
	private int noCourses;  // actual number of courses in the transcript 
	
	private Course[] courses;  //   array of courses
	
	/**
	 * Creates a Transcript with space for n courses, but 
	 * containing no actual courses
	 * @param n  the max number of courses in the transcript
	 */
	public Transcript(int n) {
		courses = new Course[n];
		maxNoCourses = n;
		noCourses = 0;
	}
	
	public void setName(String newName) {
		studentName = newName;
	}
	
	public String getName() {
		return studentName;
	}
	
	public int getNoCourses() {
		return noCourses;
	}
	
	public void addCourse(Course c) {
		if (noCourses < maxNoCourses) {
			courses[noCourses] = c;
			noCourses++;
		}
	}
	
	/**
	 * @return the average over all the marks of this transcript
	 */
	public float average() {
		float sum = 0;
		for (int i=0; i<noCourses; i++) {
			sum += courses[i].mark;
		}
		return sum/noCourses;
	}
	
	public static void main(String[] args) {
		Transcript t = new Transcript(10);
		t.setName("John Too");
		
		Course c = new Course("CPSC 121", 75);
		t.addCourse(c);
		c = new Course("CPSC 210", 85);
		t.addCourse(c);
		c = new Course("CPSC 213", 90);
		t.addCourse(c);
		
		System.out.println(t.getName() + "'s marks are:");
		for (int i = 0; i < t.getNoCourses(); i++ )
			System.out.println("   " + t.courses[i].name + ": " + t.courses[i].mark);
		System.out.println(t.getName() + "'s average is "+ t.average());
		
	}

}
