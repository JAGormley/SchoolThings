/* stub code makes this call */
a4_ex2.traverse(a);

public class a4_ex2 {
 public class ll_node {
  ll_node next;
  int data;
 }

 static int s;
 /* note this is not valid Java without a constructor (you will learn about later in
    this course) but is meant to show the (dynamically initialised) chained structure
    of a linked list containing elements with data = 3, 5, 1, 16. */
 static ll_node a =
  new ll_node(
   new ll_node(
    new ll_node( new ll_node(null, 16), 1 ), 5 ), 3 );

 public static int nodefunc(ll_node n) {
  int t = n.data;
  n.data += 3;
  return t;
 }

 public static void traverse(ll_node n) {
  int t = 0;
  while(n != null) {
   t += nodefunc(n);
   n = n.next;
  }
  s = t;
 }
}
