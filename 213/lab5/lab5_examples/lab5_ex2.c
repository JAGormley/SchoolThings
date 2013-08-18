/* This is the node of a linked list. Each node has an item and a link
   to the next node.  Each note is created dynamically. 
   The whole structure is represented by a pointer to the first node. 
   
   In the following example, we assume that a list has been created and 
   the pointer a points to the first node.

   Also notice that here the structs are defined without using a "typedef"
   definition. Therefore thir name should always start with "struct ..." 
*/

struct ll_node {
 struct ll_node *next;
 int data;
};

int s;
/* note this is not valid C but is meant to show the (dynamically initialised)
 chained structure of a linked list containing elements with data = 3, 5, 1, 16. */
struct ll_node *a = { { { { 0, 16 }, 1 }, 5 }, 3 };

/* stub code makes this call */
traverse(a);

int nodefunc(struct ll_node *n) {
 int t = n->data;
 n->data += 3;
 return t;
}

void traverse(struct ll_node *n) {
 int t = 0;
 while(n) {
  t += nodefunc(n);
  n = n->next;
 }
 s = t;
}
