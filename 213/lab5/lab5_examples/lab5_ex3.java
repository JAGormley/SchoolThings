/* stub code makes this call */
a4_ex4.dosearch();

public class a4_ex4 {
 public class bst_node {
  int d;
  int l;
  int r;
 };

 static int s1;
 static int s2;
 static int s3;
 static int s4;

/*
 This array holds the following BST structure:
          412
        /     \
      106     900
      / \     / \
     7  215 450  1024
    / \     / \
   1   9  420 512

  Note that this is not valid Java without a bst_node constructor defined, and
  that Java does not have truly static arrays like C. See the C version.
*/
 static bst_node[11] tree = {
  new bst_node(  412, 1, 6 ),
  new bst_node(  106, 2, 5 ),
  new bst_node(    7, 3, 4 ),
  new bst_node(    1, -1, -1 ), 
  new bst_node(    9, -1, -1 ),
  new bst_node(  215, -1, -1 ),
  new bst_node(  900, 7, 10 ),
  new bst_node(  450, 8, 9 ),
  new bst_node(  420, -1, -1 ),
  new bst_node(  512, -1, -1 ),
  new bst_node( 1024, -1, -1 )
 };

 public static int search(int i, int n) {
  if(i < 0)
   return i;
  if(tree[i].d == n)
   return i;
  return search(n > tree[i].d ? tree[i].r : tree[i].l, n);
 }

 public static void dosearch() {
  s1 = search(0, 215);
  s2 = search(0, 450);
  s3 = search(0, 9);
  s4 = search(0, 115);
 }
}
