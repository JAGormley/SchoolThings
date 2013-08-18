struct bst_node {
 int d;
 int l;
 int r;
};

int s1;
int s2;
int s3;
int s4;

/*
 This array holds the following BST structure:
          412
        /     \
      106     900
      / \     / \
     7  215 450  1024
    / \     / \
   1   9  420 512
*/
struct bst_node tree[11] = {
 {  412, 1, 6 },
 {  106, 2, 5 },
 {    7, 3, 4 },
 {    1, -1, -1 }, 
 {    9, -1, -1 },
 {  215, -1, -1 },
 {  900, 7, 10 },
 {  450, 8, 9 },
 {  420, -1, -1 },
 {  512, -1, -1 },
 { 1024, -1, -1 }
};

/* stub code makes this call */
dosearch();

int search(int i, int n) {
 if(i < 0)
  return i;
 if(tree[i].d == n)
  return i;
 return search(n > tree[i].d ? tree[i].r : tree[i].l, n);
}

void dosearch() {
 s1 = search(0, 215);
 s2 = search(0, 450);
 s3 = search(0, 9);
 s4 = search(0, 115);
}
